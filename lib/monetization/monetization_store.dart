import 'package:shared_preferences/shared_preferences.dart';

/// Caché local: Premium (la tienda manda al arrancar), desbloqueo por anuncio y último anuncio a pantalla completa.
class MonetizationStore {
  MonetizationStore(this._prefs);

  final SharedPreferences _prefs;

  static const _premium = 'premium';
  static const _rewardedUntil = 'rewarded_until';
  static const _lastFullScreen = 'last_full_screen';

  static Future<MonetizationStore> open() async => MonetizationStore(await SharedPreferences.getInstance());

  bool get premium => _prefs.getBool(_premium) ?? false;

  Future<void> setPremium(bool value) => _prefs.setBool(_premium, value);

  int get rewardedUntilMs => _prefs.getInt(_rewardedUntil) ?? 0;

  Future<void> setRewardedUntil(int epochMs) => _prefs.setInt(_rewardedUntil, epochMs);

  int get lastFullScreenAt => _prefs.getInt(_lastFullScreen) ?? 0;

  Future<void> setLastFullScreenAt(int epochMs) => _prefs.setInt(_lastFullScreen, epochMs);
}
