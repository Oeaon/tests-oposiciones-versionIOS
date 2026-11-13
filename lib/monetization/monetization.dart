import 'package:flutter/foundation.dart';

import 'ads_consent.dart';
import 'ads_manager.dart';
import 'billing.dart';
import 'monetization_store.dart';

export 'billing.dart' show PremiumOption;

/// Punto único para anuncios y Premium. Se crea una vez al arrancar la app.
class Monetization extends ChangeNotifier {
  Monetization._(this._store) {
    _isPremium = _store.premium;
    _rewardedUntilMs = _store.rewardedUntilMs;
    _ads = AdsManager(_store, () => _isPremium);
    _ads.rewardedReady.addListener(notifyListeners);
    _billing = Billing(
      onPremiumChanged: (premium) {
        if (premium == _isPremium) return;
        _isPremium = premium;
        _store.setPremium(premium);
        if (!premium) _ads.preload();
        notifyListeners();
      },
      onPricesLoaded: (monthly, lifetime) {
        monthlyPrice = monthly ?? monthlyPrice;
        lifetimePrice = lifetime ?? lifetimePrice;
        notifyListeners();
      },
    );
  }

  static const _rewardUnlock = Duration(hours: 24);

  final MonetizationStore _store;
  late final AdsManager _ads;
  late final Billing _billing;

  late bool _isPremium;
  late int _rewardedUntilMs;
  bool _adsReady = false;
  bool _privacyOptionsRequired = false;
  String? monthlyPrice;
  String? lifetimePrice;

  static Future<Monetization> create() async {
    final monetization = Monetization._(await MonetizationStore.open());
    monetization._billing.start();
    return monetization;
  }

  bool get isPremium => _isPremium;

  bool get adsReady => _adsReady;

  bool get showAds => _adsReady && !_isPremium;

  bool get rewardedAvailable => _ads.rewardedReady.value;

  bool get privacyOptionsRequired => _privacyOptionsRequired;

  /// Las funciones extra se abren con Premium o durante 24 h tras ver un anuncio recompensado.
  bool get isUnlocked => _isPremium || DateTime.now().millisecondsSinceEpoch < _rewardedUntilMs;

  /// Tras mostrarse la primera pantalla: pide el consentimiento y arranca AdMob.
  Future<void> gatherConsent() async {
    final ready = await AdsConsent.gather();
    _privacyOptionsRequired = await AdsConsent.isPrivacyOptionsRequired();
    if (ready) {
      _adsReady = true;
      _ads.onSdkReady();
    }
    notifyListeners();
  }

  /// En una pausa natural; [onDone] se llama siempre, haya anuncio o no.
  void maybeShowInterstitial([VoidCallback? onDone]) => _ads.maybeShowInterstitial(onDone);

  void unlockWithReward(void Function(bool earned) onClosed) {
    _ads.showRewarded(
      onReward: () {
        _rewardedUntilMs = DateTime.now().add(_rewardUnlock).millisecondsSinceEpoch;
        _store.setRewardedUntil(_rewardedUntilMs);
        notifyListeners();
      },
      onClosed: onClosed,
    );
  }

  Future<bool> buy(PremiumOption option) => _billing.launchPurchase(option);

  Future<void> restorePurchases() => _billing.restorePurchases();

  Future<void> showPrivacyOptions() => AdsConsent.showPrivacyOptions();

  @override
  void dispose() {
    _ads.dispose();
    _billing.dispose();
    super.dispose();
  }
}
