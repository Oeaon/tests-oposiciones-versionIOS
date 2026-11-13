import 'dart:math';

import 'question_bank.dart';

enum QuizMode {
  /// Corrige cada pregunta al momento y enseña la explicación.
  practice,

  /// Simulacro: con tiempo, sin corrección hasta el final y con penalización por fallo.
  exam,
}

/// Pregunta con las opciones ya barajadas.
class QuizItem {
  const QuizItem(this.question, this.options, this.correctIndex);

  final Question question;
  final List<String> options;
  final int correctIndex;
}

class QuizResult {
  const QuizResult({
    required this.total,
    required this.correct,
    required this.wrong,
    required this.blank,
    required this.penaltyPerWrong,
  });

  final int total;
  final int correct;
  final int wrong;
  final int blank;
  final double penaltyPerWrong;

  /// Aciertos menos la penalización de los fallos (habitual en la AGE: cada fallo resta un tercio).
  double get netCorrect => max(correct - wrong * penaltyPerWrong, 0);

  /// Nota sobre 10.
  double get score => total == 0 ? 0 : netCorrect / total * 10;
}

/// Estado inmutable de un test en curso.
class QuizSession {
  QuizSession(this.mode, this.items, {List<int?>? answers, this.current = 0, double? penaltyPerWrong})
      : answers = answers ?? List<int?>.filled(items.length, null),
        penaltyPerWrong = penaltyPerWrong ?? (mode == QuizMode.exam ? 1 / 3 : 0);

  final QuizMode mode;
  final List<QuizItem> items;

  /// Índice de opción elegida por pregunta; null si se dejó en blanco.
  final List<int?> answers;
  final int current;
  final double penaltyPerWrong;

  QuizItem get currentItem => items[current];
  bool get isLast => current == items.length - 1;
  int get answeredCount => answers.where((a) => a != null).length;

  QuizSession _copy({List<int?>? answers, int? current}) =>
      QuizSession(mode, items, answers: answers ?? this.answers, current: current ?? this.current, penaltyPerWrong: penaltyPerWrong);

  QuizSession answer(int optionIndex) {
    // En práctica la primera respuesta es la que cuenta.
    if (mode == QuizMode.practice && answers[current] != null) return this;
    return _copy(answers: [...answers]..[current] = optionIndex);
  }

  QuizSession goTo(int index) => _copy(current: index.clamp(0, items.length - 1));

  QuizSession next() => goTo(current + 1);

  bool? isCorrect(int index) {
    final answer = answers[index];
    return answer == null ? null : answer == items[index].correctIndex;
  }

  QuizResult result() {
    var correct = 0;
    var wrong = 0;
    for (var i = 0; i < items.length; i++) {
      switch (isCorrect(i)) {
        case true:
          correct++;
        case false:
          wrong++;
        case null:
          break;
      }
    }
    return QuizResult(
      total: items.length,
      correct: correct,
      wrong: wrong,
      blank: items.length - correct - wrong,
      penaltyPerWrong: penaltyPerWrong,
    );
  }

  /// Ids acertados y fallados, para guardar el progreso. Las de en blanco no cuentan.
  Map<String, bool> outcomes() => {
        for (var i = 0; i < items.length; i++)
          if (isCorrect(i) != null) items[i].question.id: isCorrect(i)!,
      };
}

class QuizBuilder {
  QuizBuilder._();

  static QuizSession build(List<Question> questions, int count, QuizMode mode, {Random? random}) {
    if (questions.isEmpty) throw ArgumentError('No hay preguntas');
    final rng = random ?? Random();
    final items = ([...questions]..shuffle(rng)).take(count).map((q) => shuffleOptions(q, rng)).toList();
    return QuizSession(mode, items);
  }

  static QuizItem shuffleOptions(Question question, Random random) {
    final options = [question.correctOption, ...question.wrongOptions]..shuffle(random);
    return QuizItem(question, options, options.indexOf(question.correctOption));
  }
}
