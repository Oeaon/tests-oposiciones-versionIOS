import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Pide el consentimiento (RGPD y, en iOS, el aviso de seguimiento si está configurado en AdMob)
/// con UMP antes de iniciar AdMob. Nunca se solicitan anuncios antes de que [gather] termine con `true`.
class AdsConsent {
  AdsConsent._();

  static bool _initialized = false;

  static Future<bool> gather() async {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
        if (!done.isCompleted) done.complete();
      },
      (_) {
        if (!done.isCompleted) done.complete();
      },
    );
    // Consentimiento de una sesión anterior: no hace falta esperar al formulario.
    if (await ConsentInformation.instance.canRequestAds()) return _initialize();
    await done.future;
    if (await ConsentInformation.instance.canRequestAds()) return _initialize();
    return false;
  }

  static Future<bool> isPrivacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() == PrivacyOptionsRequirementStatus.required;

  static Future<void> showPrivacyOptions() => ConsentForm.showPrivacyOptionsForm((_) {});

  static Future<bool> _initialize() async {
    if (!_initialized) {
      _initialized = true;
      await MobileAds.instance.initialize();
    }
    return true;
  }
}
