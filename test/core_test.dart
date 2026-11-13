import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tests_oposiciones/core/progress.dart';
import 'package:tests_oposiciones/core/question_bank.dart';
import 'package:tests_oposiciones/core/quiz.dart';
import 'package:tests_oposiciones/data/question_repository.dart';

void main() {
  group('temarios incluidos en la app', () {
    final files = Directory('assets/banks').listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    final banks = files.map((f) => QuestionBankParser.parse(f.readAsStringSync())).toList();

    test('están los tres temarios con sus preguntas', () {
      expect(banks.map((b) => b.id).toSet(), {'ce', 'l39', 'l40'});
      expect(banks.fold<int>(0, (sum, b) => sum + b.questions.length), greaterThanOrEqualTo(240));
    });

    test('cada tema tiene al menos cinco preguntas', () {
      for (final bank in banks) {
        for (final topic in bank.topics) {
          expect(bank.questionsOf(topic.id).length, greaterThanOrEqualTo(5), reason: topic.id);
        }
      }
    });

    test('ids de preguntas y temas únicos entre todos los temarios', () {
      final questionIds = [for (final b in banks) ...b.questions.map((q) => q.id)];
      final topicIds = [for (final b in banks) ...b.topics.map((t) => t.id)];
      expect(questionIds.toSet().length, questionIds.length);
      expect(topicIds.toSet().length, topicIds.length);
    });

    test('cuatro opciones distintas y explicación en cada pregunta', () {
      for (final q in banks.expand((b) => b.questions)) {
        final options = [q.correctOption, ...q.wrongOptions];
        expect(options.length, 4, reason: q.id);
        expect(options.toSet().length, 4, reason: q.id);
        expect(q.explanation.trim(), isNotEmpty, reason: q.id);
      }
    });

    test('la app carga los temarios en este orden', () {
      expect(bankFiles, ['constitucion.json', 'ley39.json', 'ley40.json']);
      for (final f in bankFiles) {
        expect(File('assets/banks/$f').existsSync(), isTrue, reason: f);
      }
    });
  });

  test('un tema desconocido es un error', () {
    expect(
      () => QuestionBankParser.parse(
        '{"title":"t","source":"s","topics":[{"id":"a","title":"A"}],'
        '"questions":[{"id":"1","topic":"b","question":"?","options":["x","y"],"explanation":"e"}]}',
      ),
      throwsA(isA<QuestionBankFormatException>()),
    );
  });

  test('un JSON roto es un error de formato', () {
    expect(() => QuestionBankParser.parse('{'), throwsA(isA<QuestionBankFormatException>()));
  });

  group('tests', () {
    final questions = [
      for (var i = 1; i <= 10; i++)
        Question(
          id: 'q$i',
          topicId: 't',
          text: 'Pregunta $i',
          correctOption: 'bien',
          wrongOptions: const ['mal1', 'mal2', 'mal3'],
          explanation: 'Art. $i',
        ),
    ];

    test('baraja opciones y conserva cuál es la correcta', () {
      final session = QuizBuilder.build(questions, 5, QuizMode.practice, random: Random(42));
      expect(session.items.length, 5);
      for (final item in session.items) {
        expect(item.options[item.correctIndex], 'bien');
      }
    });

    test('en práctica no se puede cambiar la respuesta', () {
      final item = QuizBuilder.shuffleOptions(questions[0], Random(1));
      final wrong = (item.correctIndex + 1) % 4;
      final session = QuizSession(QuizMode.practice, [item]).answer(wrong).answer(item.correctIndex);
      expect(session.isCorrect(0), isFalse);
    });

    test('el simulacro resta un tercio por fallo', () {
      var session = QuizBuilder.build(questions, 9, QuizMode.exam, random: Random(7));
      // 6 bien, 3 mal: 6 - 1 = 5 netas de 9 → 5,56.
      for (var i = 0; i < 9; i++) {
        final item = session.items[i];
        session = session.goTo(i).answer(i < 6 ? item.correctIndex : (item.correctIndex + 1) % 4);
      }
      final result = session.result();
      expect(result.correct, 6);
      expect(result.wrong, 3);
      expect(result.netCorrect, closeTo(5, 1e-9));
      expect(result.score, closeTo(50 / 9, 1e-9));
    });

    test('las preguntas en blanco no cuentan ni penalizan', () {
      final session = QuizBuilder.build(questions, 4, QuizMode.exam, random: Random(3));
      final answered = session.answer(session.items[0].correctIndex);
      final result = answered.result();
      expect(result.correct, 1);
      expect(result.blank, 3);
      expect(answered.outcomes().length, 1);
      expect(session.isCorrect(1), isNull);
    });

    test('en el simulacro sí se puede cambiar la respuesta', () {
      final item = QuizBuilder.shuffleOptions(questions[0], Random(1));
      final wrong = (item.correctIndex + 1) % 4;
      final session = QuizSession(QuizMode.exam, [item]).answer(wrong).answer(item.correctIndex);
      expect(session.isCorrect(0), isTrue);
    });
  });

  group('progreso', () {
    test('guarda el último resultado de cada pregunta', () {
      final progress = const Progress().record({'a': true, 'b': false}).record({'b': true, 'c': false});
      expect(progress.correctIds, {'a', 'b'});
      expect(progress.wrongIds, {'c'});
    });

    test('primero las preguntas pendientes', () {
      final questions = [
        for (var i = 1; i <= 10; i++)
          Question(id: 'q$i', topicId: 't', text: '', correctOption: 'a', wrongOptions: const ['b'], explanation: ''),
      ];
      final ordered = const Progress(correctIds: {'q1', 'q2'}).pendingFirst(questions);
      expect(ordered.take(8).where((q) => q.id == 'q1' || q.id == 'q2'), isEmpty);
    });

    test('racha de días de estudio', () {
      final day = DateTime(2026, 10, 15);
      DateTime plus(int n) => DateTime(2026, 10, 15 + n);
      final streak = const StudyStreak().studiedOn(day).studiedOn(day).studiedOn(plus(1));
      expect(streak.days, 2);
      expect(streak.current(plus(2)), 2);
      expect(streak.current(plus(3)), 0);
      expect(streak.studiedOn(plus(5)).days, 1);
    });

    test('la racha cruza el cambio de hora de octubre', () {
      final streak = const StudyStreak().studiedOn(DateTime(2026, 10, 24, 23)).studiedOn(DateTime(2026, 10, 25, 9));
      expect(streak.days, 2);
    });
  });
}
