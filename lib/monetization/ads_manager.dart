import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_units.dart';
import 'monetization_store.dart';

/// Anuncios a pantalla completa con límites de frecuencia:
/// - Intersticial: solo en pausas naturales que decide cada pantalla, como mucho cada [_interstitialGap].
/// - App Open: al volver a la app desde segundo plano (nunca en el primer arranque, que es cuando sale el consentimiento).
/// - Recompensado: solo cuando el usuario lo pide para desbloquear algo.
/// Con Premium no se carga ni se muestra nada.
class AdsManager {
  AdsManager(this._store, this._isPremium);

  final MonetizationStore _store;
  final bool Function() _isPremium;

  static const _interstitialGap = Duration(minutes: 3);
  static const _appOpenGap = Duration(minutes: 5);
  static const _appOpenExpiry = Duration(hours: 4);

  bool _sdkReady = false;
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  AppOpenAd? _appOpen;
  DateTime _appOpenLoadedAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _loadingInterstitial = false;
  bool _loadingRewarded = false;
  bool _loadingAppOpen = false;
  bool _showingFullScreen = false;
  StreamSubscription<AppState>? _appState;

  final ValueNotifier<bool> rewardedReady = ValueNotifier(false);

  void onSdkReady() {
    if (_sdkReady) return;
    _sdkReady = true;
    AppStateEventNotifier.startListening();
    _appState = AppStateEventNotifier.appStateStream.listen((state) {
      if (state == AppState.foreground) _showAppOpenIfAvailable();
    });
    preload();
  }

  void preload() {
    if (!_sdkReady || _isPremium()) return;
    _loadInterstitial();
    _loadRewarded();
    _loadAppOpen();
  }

  /// Llamar en una pausa natural (cambio de calculadora, fin de un test…). [onDone] se llama siempre.
  void maybeShowInterstitial([VoidCallback? onDone]) {
    final ad = _interstitial;
    if (ad == null || !_canShowFullScreen(_interstitialGap)) {
      _loadInterstitial();
      onDone?.call();
      return;
    }
    _interstitial = null;
    ad.fullScreenContentCallback = _callback(onDone ?? () {}, _loadInterstitial);
    _markShown();
    ad.show();
  }

  /// [onClosed] recibe si el usuario ganó la recompensa.
  void showRewarded({required VoidCallback onReward, required void Function(bool earned) onClosed}) {
    final ad = _rewarded;
    if (ad == null || !_sdkReady || _showingFullScreen) {
      _loadRewarded();
      onClosed(false);
      return;
    }
    _rewarded = null;
    rewardedReady.value = false;
    var earned = false;
    ad.fullScreenContentCallback = _callback(() => onClosed(earned), _loadRewarded);
    _markShown();
    ad.show(onUserEarnedReward: (_, _) {
      earned = true;
      onReward();
    });
  }

  void _showAppOpenIfAvailable() {
    final ad = _appOpen;
    if (ad == null || DateTime.now().difference(_appOpenLoadedAt) > _appOpenExpiry) {
      ad?.dispose();
      _appOpen = null;
      _loadAppOpen();
      return;
    }
    if (!_canShowFullScreen(_appOpenGap)) return;
    _appOpen = null;
    ad.fullScreenContentCallback = _callback(() {}, _loadAppOpen);
    _markShown();
    ad.show();
  }

  void _loadInterstitial() {
    if (!_canLoad() || _interstitial != null || _loadingInterstitial) return;
    _loadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdUnits.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _loadingInterstitial = false;
        },
        onAdFailedToLoad: (_) => _loadingInterstitial = false,
      ),
    );
  }

  void _loadRewarded() {
    if (!_sdkReady || _rewarded != null || _loadingRewarded) return;
    _loadingRewarded = true;
    RewardedAd.load(
      adUnitId: AdUnits.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewarded = ad;
          _loadingRewarded = false;
          rewardedReady.value = true;
        },
        onAdFailedToLoad: (_) => _loadingRewarded = false,
      ),
    );
  }

  void _loadAppOpen() {
    if (!_canLoad() || _appOpen != null || _loadingAppOpen) return;
    _loadingAppOpen = true;
    AppOpenAd.load(
      adUnitId: AdUnits.appOpen,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpen = ad;
          _appOpenLoadedAt = DateTime.now();
          _loadingAppOpen = false;
        },
        onAdFailedToLoad: (_) => _loadingAppOpen = false,
      ),
    );
  }

  FullScreenContentCallback<T> _callback<T extends Ad>(VoidCallback onDone, VoidCallback reload) =>
      FullScreenContentCallback<T>(
        onAdShowedFullScreenContent: (_) => _showingFullScreen = true,
        onAdDismissedFullScreenContent: (ad) {
          _showingFullScreen = false;
          ad.dispose();
          reload();
          onDone();
        },
        onAdFailedToShowFullScreenContent: (ad, _) {
          _showingFullScreen = false;
          ad.dispose();
          reload();
          onDone();
        },
      );

  bool _canLoad() => _sdkReady && !_isPremium();

  bool _canShowFullScreen(Duration gap) =>
      _canLoad() &&
      !_showingFullScreen &&
      DateTime.now().millisecondsSinceEpoch - _store.lastFullScreenAt >= gap.inMilliseconds;

  void _markShown() => _store.setLastFullScreenAt(DateTime.now().millisecondsSinceEpoch);

  void dispose() {
    _appState?.cancel();
    _interstitial?.dispose();
    _rewarded?.dispose();
    _appOpen?.dispose();
  }
}
