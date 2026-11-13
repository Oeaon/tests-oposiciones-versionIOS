import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/question_bank.dart';
import '../core/quiz.dart';
import '../data/progress_store.dart';

const practiceSize = 10;
const examSize = 30;
const examMinutes = 30;

/// Colores de acierto y fallo, legibles en claro y en oscuro.
class AnswerColors {
  AnswerColors._();

  static Color correct(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF81C784) : const Color(0xFF2E7D32);

  static Color wrong(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFFE57373) : const Color(0xFFC62828);
}

String formatScore(double value, String locale) => NumberFormat('0.00', locale).format(value);

/// Un test listo para empezar, con su hora límite si es un simulacro.
class QuizStart {
  const QuizStart(this.bank, this.session, {this.deadline});

  final QuestionBank bank;
  final QuizSession session;
  final DateTime? deadline;
}

/// Prepara los distintos tipos de test a partir del temario y el progreso.
class QuizFactory {
  QuizFactory._();

  static QuizStart? topic(QuestionBank bank, ProgressStore store, String topicId) {
    // Primero las que aún no se han acertado, luego al azar.
    final pool = store.progress.pendingFirst(bank.questionsOf(topicId)..shuffle()).take(practiceSize).toList();
    return _start(bank, pool, QuizMode.practice);
  }

  static QuizStart? quick(QuestionBank bank) => _start(bank, bank.questions, QuizMode.practice, count: practiceSize);

  static QuizStart? failed(QuestionBank bank, ProgressStore store) =>
      _start(bank, store.progress.failedQuestions(bank), QuizMode.practice, count: practiceSize);

  static QuizStart? exam(QuestionBank bank) => _start(
        bank,
        bank.questions,
        QuizMode.exam,
        count: examSize,
        deadline: DateTime.now().add(const Duration(minutes: examMinutes)),
      );

  static QuizStart? _start(QuestionBank bank, List<Question> pool, QuizMode mode, {int? count, DateTime? deadline}) {
    if (pool.isEmpty) return null;
    return QuizStart(bank, QuizBuilder.build(pool, count ?? pool.length, mode), deadline: deadline);
  }
}
