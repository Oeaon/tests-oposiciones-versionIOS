import 'question_bank.dart';

/// Último resultado de cada pregunta contestada.
class Progress {
  const Progress({this.correctIds = const {}, this.wrongIds = const {}});

  final Set<String> correctIds;
  final Set<String> wrongIds;

  Progress record(Map<String, bool> outcomes) {
    final right = {for (final e in outcomes.entries) if (e.value) e.key};
    final wrong = {for (final e in outcomes.entries) if (!e.value) e.key};
    return Progress(
      correctIds: correctIds.difference(wrong).union(right),
      wrongIds: wrongIds.difference(right).union(wrong),
    );
  }

  TopicStats stats(QuestionBank bank, [String? topicId]) {
    final ids = (topicId == null ? bank.questions : bank.questionsOf(topicId)).map((q) => q.id).toList();
    return TopicStats(
      total: ids.length,
      correct: ids.where(correctIds.contains).length,
      wrong: ids.where(wrongIds.contains).length,
    );
  }

  List<Question> failedQuestions(QuestionBank bank) => bank.questions.where((q) => wrongIds.contains(q.id)).toList();

  /// Preguntas que nunca se han contestado o que se fallaron, primero (orden estable).
  List<Question> pendingFirst(List<Question> questions) => [
        ...questions.where((q) => !correctIds.contains(q.id)),
        ...questions.where((q) => correctIds.contains(q.id)),
      ];
}

class TopicStats {
  const TopicStats({required this.total, required this.correct, required this.wrong});

  final int total;
  final int correct;
  final int wrong;

  int get answered => correct + wrong;
  double get mastery => total == 0 ? 0 : correct / total;
}

/// Racha de días seguidos estudiando. Los días son fechas locales sin hora.
class StudyStreak {
  const StudyStreak({this.days = 0, this.lastDay});

  final int days;
  final DateTime? lastDay;

  static DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  static int _between(DateTime a, DateTime b) => _day(b).difference(_day(a)).inDays;

  StudyStreak studiedOn(DateTime day) {
    final last = lastDay;
    if (last != null && _between(last, day) == 0) return this;
    if (last != null && _between(last, day) == 1) return StudyStreak(days: days + 1, lastDay: _day(day));
    return StudyStreak(days: 1, lastDay: _day(day));
  }

  /// La racha sigue viva si se estudió hoy o ayer.
  int current(DateTime today) {
    final last = lastDay;
    return last != null && _between(last, today) <= 1 ? days : 0;
  }
}
