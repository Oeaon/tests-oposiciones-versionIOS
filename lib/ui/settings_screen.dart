import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app_info.dart';
import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import '../monetization/monetization_ui.dart';

/// Ajustes comunes: lo propio de la app ([appSection]), Premium, privacidad de anuncios y acerca de.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.monetization,
    required this.onOpenPremium,
    required this.sourceLabels,
    this.appSection = const [],
  });

  final Monetization monetization;
  final VoidCallback onOpenPremium;

  /// Nombre de cada enlace de [AppInfo.officialSources], en el mismo orden.
  final List<String> sourceLabels;
  final List<Widget> appSection;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListenableBuilder(
        listenable: monetization,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (appSection.isNotEmpty) ...[...appSection, const Divider(height: 32)],
            if (!monetization.isPremium) ...[
              SectionTitle(l.premiumTitle),
              Text(l.premiumSettingsText, style: theme.textTheme.bodyMedium),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FilledButton(onPressed: onOpenPremium, child: Text(l.removeAds)),
                ),
              ),
              const Divider(height: 32),
            ],
            if (monetization.privacyOptionsRequired) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(onPressed: monetization.showPrivacyOptions, child: Text(l.privacyOptions)),
              ),
              const Divider(height: 32),
            ],
            SectionTitle(l.aboutTitle),
            Text(l.aboutText, style: theme.textTheme.bodyMedium),
            // Las tiendas exigen enlazar las fuentes oficiales de la información.
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l.sourceTitle, style: theme.textTheme.labelLarge),
            ),
            for (var i = 0; i < AppInfo.officialSources.length; i++)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: () => openUrl(AppInfo.officialSources[i]), child: Text(sourceLabels[i])),
              ),
            Text(l.aboutDisclaimer, style: muted),
            const SizedBox(height: 8),
            Wrap(children: [
              TextButton(onPressed: () => openUrl(AppInfo.privacyUrl), child: Text(l.privacyPolicy)),
              TextButton(onPressed: () => openUrl(AppInfo.termsUrl), child: Text(l.termsOfUse)),
            ]),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => Text(
                snapshot.hasData ? l.version(snapshot.data!.version) : '',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
    );
  }
}
