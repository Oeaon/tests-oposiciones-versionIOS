import 'package:flutter/services.dart';

import '../core/question_bank.dart';

/// Temarios incluidos en la app, en el orden en que se muestran.
const bankFiles = ['constitucion.json', 'ley39.json', 'ley40.json'];

/// Lee los temarios de los assets una sola vez.
class QuestionRepository {
  QuestionRepository([AssetBundle? bundle]) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  Future<List<QuestionBank>>? _banks;

  Future<List<QuestionBank>> banks() => _banks ??= Future.wait([
        for (final file in bankFiles) _bundle.loadString('assets/banks/$file').then(QuestionBankParser.parse),
      ]);
}
