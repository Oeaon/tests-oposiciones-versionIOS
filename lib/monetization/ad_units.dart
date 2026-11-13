import 'dart:io';

/// IDs de AdMob. En la compilación de la tienda llegan con `--dart-define` desde Codemagic
/// (grupo de variables `admob`); sin ellos se usan los de prueba de Google.
class AdUnits {
  AdUnits._();

  static const _banner = String.fromEnvironment('AD_BANNER');
  static const _interstitial = String.fromEnvironment('AD_INTERSTITIAL');
  static const _appOpen = String.fromEnvironment('AD_APP_OPEN');
  static const _rewarded = String.fromEnvironment('AD_REWARDED');

  static String get banner => _or(_banner, ios: 'ca-app-pub-3940256099942544/2435281174', android: 'ca-app-pub-3940256099942544/9214589741');

  static String get interstitial =>
      _or(_interstitial, ios: 'ca-app-pub-3940256099942544/4411468910', android: 'ca-app-pub-3940256099942544/1033173712');

  static String get appOpen => _or(_appOpen, ios: 'ca-app-pub-3940256099942544/5575463023', android: 'ca-app-pub-3940256099942544/9257395921');

  static String get rewarded => _or(_rewarded, ios: 'ca-app-pub-3940256099942544/1712485313', android: 'ca-app-pub-3940256099942544/5224354917');

  static String _or(String value, {required String ios, required String android}) =>
      value.isNotEmpty ? value : (Platform.isIOS ? ios : android);
}
