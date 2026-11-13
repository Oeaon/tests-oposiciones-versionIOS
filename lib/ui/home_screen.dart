import 'package:flutter/material.dart';

import '../app_info.dart';
import '../core/question_bank.dart';
import '../data/progress_store.dart';
import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import '../monetization/monetization_ui.dart';
import 'study.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.banks,
    required this.store,
    required this.monetization,
    required this.onStart,
    required this.onOpenSettings,
    required this.onOpenPremium,
  });

  /// null mientras se cargan; un error si no se han podido leer.
  final AsyncSnapshot<List<QuestionBank>> banks;
  final ProgressStore store;
  final Monetization monetization;
  final ValueChanged<QuizStart> onStart;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenPremium;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([store, monetization]),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text(AppInfo.name),
          actions: [
            PremiumAction(monetization: monetization, onPressed: onOpenPremium),
            IconButton(onPressed: onOpenSettings, icon: const Icon(Icons.settings), tooltip: l.settings),
          ],
        ),
        bottomNavigationBar: AdBanner(monetization: monetization),
        body: switch (banks) {
          AsyncSnapshot(hasError: true) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(l.loadError))),
          AsyncSnapshot(:final data?) when data.isNotEmpty => _content(context, data),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  Widget _content(BuildContext context, List<QuestionBank> banks) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final bank = banks.firstWhere((b) => b.id == store.selectedBankId, orElse: () => banks.first);
    final progress = store.progress;
    final overall = progress.stats(bank);
    final failed = progress.failedQuestions(bank).length;
    final streak = store.streak.current(DateTime.now());
    final best = store.bestExamScores[bank.id];
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);

    void start(QuizStart? quiz) {
      if (quiz != null) onStart(quiz);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (banks.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(spacing: 8, children: [
              for (final option in banks)
                FilterChip(
                  selected: option.id == bank.id,
                  onSelected: (_) => store.selectBank(option.id),
                  label: Text(option.shortTitle),
                ),
            ]),
          ),
        const SizedBox(height: 12),
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: [
              Text(bank.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(l.mastery(overall.correct, overall.total)),
              LinearProgressIndicator(value: overall.mastery),
              Text(streak > 0 ? l.streak(streak) : l.streakNone, style: theme.textTheme.bodyMedium),
              if (best != null) Text(l.bestExam(formatScore(best, l.localeName))),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        Row(spacing: 8, children: [
          Expanded(child: FilledButton(onPressed: () => start(QuizFactory.quick(bank)), child: Text(l.quickTest(practiceSize)))),
          Expanded(
            child: OutlinedButton(
              onPressed: failed > 0 ? () => start(QuizFactory.failed(bank, store)) : null,
              child: Text(l.reviewFailed(failed)),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        LockedFeature(
          monetization: monetization,
          title: l.examTitle,
          description: l.examLocked(examSize, examMinutes),
          onGoPremium: onOpenPremium,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 8, children: [
                Text(l.examTitle, style: theme.textTheme.titleMedium),
                Text(l.examDescription(examSize, examMinutes)),
                FilledButton(onPressed: () => start(QuizFactory.exam(bank)), child: Text(l.examStart)),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(l.topics, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final topic in bank.topics) ...[
          Builder(builder: (context) {
            final stats = progress.stats(bank, topic.id);
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => start(QuizFactory.topic(bank, store, topic.id)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: [
                    Text(topic.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    LinearProgressIndicator(value: stats.mastery),
                    Text(l.topicStats(stats.total, (stats.mastery * 100).round()), style: muted),
                  ]),
                ),
              ),
            );
          }),
          const SizedBox(height: 4),
        ],
        const SizedBox(height: 8),
        Text(bank.source, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
