import 'package:flutter/material.dart';

import '../core/question_bank.dart';
import '../core/quiz.dart';
import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import '../monetization/monetization_ui.dart';
import 'study.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.bank, required this.session, required this.monetization});

  final QuestionBank bank;
  final QuizSession session;
  final Monetization monetization;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final result = session.result();
    final mistakes = [for (var i = 0; i < session.items.length; i++) if (session.isCorrect(i) == false) i];
    final correct = AnswerColors.correct(context);
    final wrong = AnswerColors.wrong(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.results), automaticallyImplyLeading: false),
      bottomNavigationBar: AdBanner(monetization: monetization),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: [
                Text(
                  l.score(formatScore(result.score, l.localeName)),
                  style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: result.score >= 5 ? correct : wrong),
                ),
                Text(l.resultCounts(result.correct, result.wrong, result.blank)),
                if (session.mode == QuizMode.exam)
                  Text(
                    l.resultPenalty(formatScore(result.netCorrect, l.localeName)),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l.backHome)),
          if (mistakes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l.yourMistakes, style: theme.textTheme.titleMedium),
          ],
          for (final index in mistakes) _Mistake(bank: bank, item: session.items[index], answer: session.answers[index]),
        ],
      ),
    );
  }
}

class _Mistake extends StatelessWidget {
  const _Mistake({required this.bank, required this.item, required this.answer});

  final QuestionBank bank;
  final QuizItem item;
  final int? answer;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final topic = bank.topics.where((t) => t.id == item.question.topicId).firstOrNull;
    final answer = this.answer;
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 4, children: [
          if (topic != null) Text(topic.title, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(item.question.text, style: theme.textTheme.bodyLarge),
          if (answer != null) Text(l.yourAnswer(item.options[answer]), style: TextStyle(color: AnswerColors.wrong(context))),
          Text(l.correctAnswer(item.options[item.correctIndex]), style: TextStyle(color: AnswerColors.correct(context))),
          Text(item.question.explanation, style: theme.textTheme.bodySmall),
        ]),
      ),
    );
  }
}
