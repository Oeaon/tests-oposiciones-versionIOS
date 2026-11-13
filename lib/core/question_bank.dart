import 'dart:convert';

class Topic {
  const Topic(this.id, this.title);

  final String id;
  final String title;
}

/// En el archivo la primera opción es siempre la correcta; los tests las barajan al crearse.
class Question {
  const Question({
    required this.id,
    required this.topicId,
    required this.text,
    required this.correctOption,
    required this.wrongOptions,
    required this.explanation,
  });

  final String id;
  final String topicId;
  final String text;
  final String correctOption;
  final List<String> wrongOptions;
  final String explanation;
}

/// Un temario: la Constitución, una ley… [id] es estable y sirve para guardar el progreso y la mejor nota.
class QuestionBank {
  const QuestionBank({
    required this.id,
    required this.shortTitle,
    required this.title,
    required this.source,
    required this.topics,
    required this.questions,
  });

  final String id;
  final String shortTitle;
  final String title;
  final String source;
  final List<Topic> topics;
  final List<Question> questions;

  List<Question> questionsOf(String topicId) => questions.where((q) => q.topicId == topicId).toList();
}

class QuestionBankFormatException implements Exception {
  const QuestionBankFormatException(this.message);

  final String message;

  @override
  String toString() => 'QuestionBankFormatException: $message';
}

class QuestionBankParser {
  QuestionBankParser._();

  static QuestionBank parse(String body) {
    final Object? decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      throw const QuestionBankFormatException('JSON no válido');
    }
    if (decoded is! Map<String, dynamic>) throw const QuestionBankFormatException('Formato inesperado');
    final topics = [
      for (final item in _list(decoded, 'topics')) Topic(_text(item, 'id'), _text(item, 'title')),
    ];
    final topicIds = {for (final t in topics) t.id};
    final questions = <Question>[];
    for (final item in _list(decoded, 'questions')) {
      final options = _list(item, 'options').map((o) => o is String ? o : throw const QuestionBankFormatException('Opción no válida')).toList();
      final id = _text(item, 'id');
      if (options.length < 2) throw QuestionBankFormatException('Pregunta con menos de dos opciones: $id');
      final topic = _text(item, 'topic');
      if (!topicIds.contains(topic)) throw QuestionBankFormatException('Tema desconocido: $topic');
      questions.add(Question(
        id: id,
        topicId: topic,
        text: _text(item, 'question'),
        correctOption: options.first,
        wrongOptions: options.sublist(1),
        explanation: _text(item, 'explanation'),
      ));
    }
    final title = _text(decoded, 'title');
    return QuestionBank(
      id: decoded['id'] as String? ?? title,
      shortTitle: decoded['shortTitle'] as String? ?? title,
      title: title,
      source: _text(decoded, 'source'),
      topics: topics,
      questions: questions,
    );
  }

  static List<dynamic> _list(Object? object, String key) {
    final value = object is Map ? object[key] : null;
    if (value is! List) throw QuestionBankFormatException('Falta $key');
    return value;
  }

  static String _text(Object? object, String key) {
    final value = object is Map ? object[key] : null;
    if (value is! String) throw QuestionBankFormatException('Falta $key');
    return value;
  }
}
