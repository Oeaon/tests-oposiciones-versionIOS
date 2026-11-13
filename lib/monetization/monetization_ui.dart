import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import 'ad_units.dart';
import 'monetization.dart';

/// Abre un enlace en el navegador del sistema.
Future<void> openUrl(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

/// Banner adaptativo anclado. Solo en pantallas de consulta, nunca en formularios a medio rellenar.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key, required this.monetization});

  final Monetization monetization;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  int? _loadedWidth;

  @override
  void initState() {
    super.initState();
    // El consentimiento llega después del primer dibujo: se carga en cuanto AdMob está listo.
    widget.monetization.addListener(_onMonetizationChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  void _onMonetizationChanged() {
    if (widget.monetization.showAds) {
      _load();
    } else if (mounted) {
      setState(() {});
    }
  }

  Future<void> _load() async {
    if (!widget.monetization.showAds || !mounted) return;
    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width == _loadedWidth) return;
    _loadedWidth = width;
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null || !mounted) return;
    final ad = BannerAd(
      adUnitId: AdUnits.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() {});
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    await ad.load();
    if (!mounted) {
      ad.dispose();
      return;
    }
    final old = _ad;
    setState(() => _ad = ad);
    old?.dispose();
  }

  @override
  void dispose() {
    widget.monetization.removeListener(_onMonetizationChanged);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!widget.monetization.showAds || ad == null) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(width: ad.size.width.toDouble(), height: ad.size.height.toDouble(), child: AdWidget(ad: ad)),
    );
  }
}

/// Botón de la barra superior que abre la pantalla Premium; desaparece si ya es Premium.
class PremiumAction extends StatelessWidget {
  const PremiumAction({super.key, required this.monetization, required this.onPressed});

  final Monetization monetization;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (monetization.isPremium) return const SizedBox.shrink();
    return IconButton(onPressed: onPressed, icon: const Icon(Icons.star), tooltip: L.of(context).premiumTitle);
  }
}

/// Muestra [child] si la función está desbloqueada; si no, una tarjeta para desbloquearla
/// 24 h con un anuncio recompensado o para siempre con Premium.
class LockedFeature extends StatefulWidget {
  const LockedFeature({
    super.key,
    required this.monetization,
    required this.title,
    required this.description,
    required this.onGoPremium,
    required this.child,
  });

  final Monetization monetization;
  final String title;
  final String description;
  final VoidCallback onGoPremium;
  final Widget child;

  @override
  State<LockedFeature> createState() => _LockedFeatureState();
}

class _LockedFeatureState extends State<LockedFeature> {
  bool _rewardFailed = false;

  @override
  Widget build(BuildContext context) {
    final monetization = widget.monetization;
    if (monetization.isUnlocked) return widget.child;
    final l = L.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Row(children: [
              const Icon(Icons.lock, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.title, style: Theme.of(context).textTheme.titleMedium)),
            ]),
            Text(widget.description, style: Theme.of(context).textTheme.bodyMedium),
            if (monetization.adsReady)
              OutlinedButton(
                onPressed: monetization.rewardedAvailable
                    ? () => monetization.unlockWithReward((earned) {
                          if (mounted) setState(() => _rewardFailed = !earned);
                        })
                    : null,
                child: Text(l.lockedWatchAd),
              ),
            if (_rewardFailed)
              Text(l.rewardedUnavailable, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.error)),
            FilledButton(onPressed: widget.onGoPremium, child: Text(l.lockedGoPremium)),
          ],
        ),
      ),
    );
  }
}

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({
    super.key,
    required this.monetization,
    required this.features,
    required this.privacyUrl,
    required this.termsUrl,
  });

  final Monetization monetization;
  final List<String> features;

  /// Apple exige enlazar la política de privacidad y los términos donde se venden suscripciones.
  final String privacyUrl;
  final String termsUrl;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _storeUnavailable = false;

  Future<void> _buy(PremiumOption option) async {
    final ok = await widget.monetization.buy(option);
    if (mounted) setState(() => _storeUnavailable = !ok);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: widget.monetization,
      builder: (context, _) {
        final m = widget.monetization;
        return Scaffold(
          appBar: AppBar(title: Text(l.premiumTitle)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                spacing: 16,
                children: [
                  Icon(Icons.star, size: 56, color: theme.colorScheme.primary),
                  Text(
                    m.isPremium ? l.premiumActive : l.premiumHeadline,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  for (final feature in [l.premiumBenefitNoAds, ...widget.features])
                    Row(children: [
                      Icon(Icons.check, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(child: Text(feature, style: theme.textTheme.bodyLarge)),
                    ]),
                  if (!m.isPremium) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: m.monthlyPrice == null ? null : () => _buy(PremiumOption.monthly),
                        child: Text(m.monthlyPrice == null ? l.premiumLoading : l.premiumMonthly(m.monthlyPrice!)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: m.lifetimePrice == null ? null : () => _buy(PremiumOption.lifetime),
                        child: Text(m.lifetimePrice == null ? l.premiumLoading : l.premiumLifetime(m.lifetimePrice!)),
                      ),
                    ),
                    if (_storeUnavailable)
                      Text(l.premiumStoreUnavailable,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
                    TextButton(onPressed: m.restorePurchases, child: Text(l.premiumRestore)),
                    Text(
                      l.premiumLegal,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    Wrap(alignment: WrapAlignment.center, children: [
                      TextButton(onPressed: () => openUrl(widget.privacyUrl), child: Text(l.privacyPolicy)),
                      TextButton(onPressed: () => openUrl(widget.termsUrl), child: Text(l.termsOfUse)),
                    ]),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
