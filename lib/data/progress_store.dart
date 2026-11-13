import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/progress.dart';

/// Aciertos, fallos, racha, mejores notas y temario elegido, guardados en el móvil.
class ProgressStore extends ChangeNotifier {
  ProgressStore._(this._prefs) {
    _load();
  }

  static Future<ProgressStore> open() async => ProgressStore._(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  late Progress progress;
  late StudyStreak streak;

  /// Mejor nota de simulacro por id de temario.
  late Map<String, double> bestExamScores;

  /// Temario elegido; null hasta que el usuario cambia el primero.
  String? selectedBankId;

  static const _correct = 'correct_ids';
  static const _wrong = 'wrong_ids';
  static const _streakDays = 'streak_days';
  static const _streakLast = 'streak_last';
  static const _bestPrefix = 'best_exam_';
  static const _selectedBank = 'selected_bank';

  void _load() {
    progress = Progress(
      correctIds: (_prefs.getStringList(_correct) ?? const []).toSet(),
      wrongIds: (_prefs.getStringList(_wrong) ?? const []).toSet(),
    );
    streak = StudyStreak(
      days: _prefs.getInt(_streakDays) ?? 0,
      lastDay: DateTime.tryParse(_prefs.getString(_streakLast) ?? ''),
    );
    bestExamScores = {
      for (final key in _prefs.getKeys())
        if (key.startsWith(_bestPrefix) && _prefs.getDouble(key) != null) key.substring(_bestPrefix.length): _prefs.getDouble(key)!,
    };
    selectedBankId = _prefs.getString(_selectedBank);
  }

  /// Guarda el resultado de un test y suma el día a la racha.
  Future<void> record({required Map<String, bool> outcomes, required String bankId, double? examScore, required DateTime today}) async {
    progress = progress.record(outcomes);
    streak = streak.studiedOn(today);
    if (examScore != null && examScore > (bestExamScores[bankId] ?? -1)) bestExamScores = {...bestExamScores, bankId: examScore};
    notifyListeners();
    await _prefs.setStringList(_correct, progress.correctIds.toList());
    await _prefs.setStringList(_wrong, progress.wrongIds.toList());
    await _prefs.setInt(_streakDays, streak.days);
    await _prefs.setString(_streakLast, streak.lastDay!.toIso8601String().substring(0, 10));
    if (examScore != null) await _prefs.setDouble(_bestPrefix + bankId, bestExamScores[bankId]!);
  }

  Future<void> selectBank(String bankId) async {
    selectedBankId = bankId;
    notifyListeners();
    await _prefs.setString(_selectedBank, bankId);
  }

  /// Borra el progreso pero mantiene el temario elegido.
  Future<void> reset() async {
    for (final key in _prefs.getKeys().toList()) {
      if (key != _selectedBank && (key.startsWith(_bestPrefix) || const [_correct, _wrong, _streakDays, _streakLast].contains(key))) {
        await _prefs.remove(key);
      }
    }
    _load();
    notifyListeners();
  }
}
