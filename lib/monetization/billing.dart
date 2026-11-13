import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_2_wrappers.dart';

enum PremiumOption { monthly, lifetime }

/// Compras de la tienda: suscripción mensual [monthlyId] y compra única [lifetimeId].
/// La tienda manda: al arrancar se consultan las compras vigentes y, si la suscripción caducó, vuelven los anuncios.
class Billing {
  Billing({required this.onPremiumChanged, required this.onPricesLoaded});

  /// Crear en App Store Connect con estos IDs: suscripción mensual y compra no consumible.
  static const monthlyId = 'premium_monthly';
  static const lifetimeId = 'premium_lifetime';
  static const _ids = {monthlyId, lifetimeId};

  final void Function(bool premium) onPremiumChanged;
  final void Function(String? monthly, String? lifetime) onPricesLoaded;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchases;
  ProductDetails? _monthly;
  ProductDetails? _lifetime;

  Future<void> start() async {
    _purchases = _iap.purchaseStream.listen(_handle, onError: (_) {});
    if (!await _iap.isAvailable()) return;
    await _queryProducts();
    await refreshPurchases();
  }

  /// Devuelve false si los productos aún no están cargados (sin conexión con la tienda).
  Future<bool> launchPurchase(PremiumOption option) async {
    final details = option == PremiumOption.monthly ? _monthly : _lifetime;
    if (details == null) return false;
    try {
      // Las suscripciones también se compran como "no consumibles" en este plugin.
      return await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: details));
    } catch (_) {
      return false;
    }
  }

  /// "Restaurar compras": sincroniza con la tienda y vuelve a mirar qué compras siguen vigentes.
  Future<void> restorePurchases() async {
    if (Platform.isIOS) {
      try {
        await _iap.restorePurchases();
      } catch (_) {
        // Si el usuario cancela el inicio de sesión de Apple, se mantiene lo que hubiera.
      }
    }
    await refreshPurchases();
  }

  /// Consulta solo compras vigentes: en iOS las entitlements de StoreKit 2, en Android las compras activas.
  Future<void> refreshPurchases() async {
    try {
      if (Platform.isIOS) {
        final entitlements = await SK2Transaction.currentEntitlements();
        onPremiumChanged(entitlements.any((t) => _ids.contains(t.productId)));
      } else {
        final addition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        final response = await addition.queryPastPurchases();
        // Sin respuesta completa de la tienda se mantiene lo guardado.
        if (response.error != null) return;
        final owned = response.pastPurchases.where(
          (p) => _ids.contains(p.productID) && (p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored),
        );
        for (final purchase in owned) {
          if (purchase.pendingCompletePurchase) await _iap.completePurchase(purchase);
        }
        onPremiumChanged(owned.isNotEmpty);
      }
    } catch (_) {
      // Sin conexión con la tienda se mantiene lo guardado.
    }
  }

  Future<void> _handle(List<PurchaseDetails> purchases) async {
    var premium = false;
    for (final purchase in purchases) {
      if (!_ids.contains(purchase.productID)) continue;
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) premium = true;
      if (purchase.pendingCompletePurchase) await _iap.completePurchase(purchase);
    }
    if (premium) onPremiumChanged(true);
  }

  Future<void> _queryProducts() async {
    final response = await _iap.queryProductDetails(_ids);
    for (final product in response.productDetails) {
      if (product.id == monthlyId) _monthly ??= product;
      if (product.id == lifetimeId) _lifetime ??= product;
    }
    onPricesLoaded(_monthly?.price, _lifetime?.price);
  }

  void dispose() => _purchases?.cancel();
}
