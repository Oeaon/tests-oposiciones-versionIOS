import 'dart:async';

import 'package:flutter/material.dart';

import '../core/quiz.dart';
import '../l10n/app_localizations.dart';
import 'study.dart';

/// Pantalla de un test. Sin banner: no se ponen anuncios mientras se contesta.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.start, required this.onFinish});

  final QuizStart start;

  /// Se llama una sola vez, al entregar o al acabarse el tiempo.
  final ValueChanged<QuizSession> onFinish;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizSession _session = widget.start.session;
  Timer? _timer;
  Duration? _remaining;
  bool _finished = false;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.start.deadline != null) {
      _tick();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  void _tick() {
    final left = widget.start.deadline!.difference(DateTime.now());
    if (left <= Duration.zero) {
      _finish();
    } else {
      setState(() => _remaining = left);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    widget.onFinish(_session);
  }

  void _update(QuizSession session, {bool toTop = false}) {
    setState(() => _session = session);
    if (toTop && _scroll.hasClients) _scroll.jumpTo(0);
  }

  Future<void> _confirmQuit() async {
    final l = L.of(context);
    final quit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.quitTest),
        content: Text(l.quitTestText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.keepGoing)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.quit)),
        ],
      ),
    );
    if (quit == true && mounted) {
      _timer?.cancel();
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmFinish() async {
    final l = L.of(context);
    final finish = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.finishExamNow),
        content: Text(l.finishExamText(_session.answeredCount, _session.items.length)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.keepGoing)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.finish)),
        ],
      ),
    );
    if (finish == true) _finish();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final session = _session;
    final isExam = session.mode == QuizMode.exam;
    final item = session.currentItem;
    final chosen = session.answers[session.current];
    final reveal = !isExam && chosen != null;
    final remaining = _remaining;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_finished) _confirmQuit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.questionOf(session.current + 1, session.items.length)),
          leading: IconButton(icon: const Icon(Icons.close), tooltip: l.quitTest, onPressed: _confirmQuit),
          actions: [
            if (remaining != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: remaining.inSeconds < 60 ? AnswerColors.wrong(context) : null,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.all(16),
            children: [
              LinearProgressIndicator(value: (session.current + 1) / session.items.length),
              const SizedBox(height: 12),
              if (isExam) ...[_QuestionDots(session: session, onGoTo: (i) => _update(session.goTo(i), toTop: true)), const SizedBox(height: 12)],
              Text(item.question.text, style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              for (var i = 0; i < item.options.length; i++) ...[
                _OptionCard(
                  label: '${String.fromCharCode(65 + i)}) ${item.options[i]}',
                  color: switch (i) {
                    _ when reveal && i == item.correctIndex => AnswerColors.correct(context),
                    _ when reveal && i == chosen => AnswerColors.wrong(context),
                    _ when !reveal && i == chosen => theme.colorScheme.primary,
                    _ => null,
                  },
                  onTap: reveal ? null : () => _update(session.answer(i)),
                ),
                const SizedBox(height: 8),
              ],
              if (reveal)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 4, children: [
                      Text(
                        chosen == item.correctIndex ? l.answerRight : l.answerWrong,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: chosen == item.correctIndex ? AnswerColors.correct(context) : AnswerColors.wrong(context),
                        ),
                      ),
                      Text(item.question.explanation, style: theme.textTheme.bodyMedium),
                    ]),
                  ),
                ),
              const SizedBox(height: 12),
              Row(spacing: 8, children: [
                if (isExam)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: session.current > 0 ? () => _update(session.goTo(session.current - 1), toTop: true) : null,
                      child: Text(l.previous),
                    ),
                  ),
                Expanded(
                  child: session.isLast
                      ? FilledButton(
                          onPressed: isExam ? _confirmFinish : (reveal ? _finish : null),
                          child: Text(l.finish),
                        )
                      : FilledButton(
                          onPressed: isExam || reveal ? () => _update(session.next(), toTop: true) : null,
                          child: Text(l.next),
                        ),
                ),
              ]),
              if (isExam && !session.isLast)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(onPressed: _confirmFinish, child: Text(l.finishExamNow)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.label, required this.color, required this.onTap});

  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = this.color;
    return Material(
      color: color?.withValues(alpha: 0.10) ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: color != null ? 2 : 1, color: color ?? theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: Text(label, style: theme.textTheme.bodyLarge)),
      ),
    );
  }
}

/// Mapa de preguntas del simulacro: contestadas en color, la actual con borde.
class _QuestionDots extends StatelessWidget {
  const _QuestionDots({required this.session, required this.onGoTo});

  final QuizSession session;
  final ValueChanged<int> onGoTo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(spacing: 6, children: [
        for (var i = 0; i < session.items.length; i++)
          Material(
            color: session.answers[i] != null ? scheme.primaryContainer : Colors.transparent,
            shape: CircleBorder(
              side: BorderSide(
                width: i == session.current ? 2 : 1,
                color: i == session.current ? scheme.primary : scheme.outlineVariant,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onGoTo(i),
              child: SizedBox.square(
                dimension: 36,
                child: Center(child: Text('${i + 1}', style: Theme.of(context).textTheme.labelMedium)),
              ),
            ),
          ),
      ]),
    );
  }
}
