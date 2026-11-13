# Tests Oposiciones (iOS)

Versión para iPhone de Tests Oposiciones, hecha con Flutter.
Preguntas tipo test sobre la Constitución Española y las leyes 39/2015 y 40/2015 para preparar oposiciones:
tests por tema, test rápido, repaso de fallos, racha de estudio y, como función Premium, simulacros de examen con
tiempo y penalización por fallo. Todo funciona sin conexión y el progreso se guarda en el móvil.

- Bundle ID: `com.oeaon.testsoposiciones`
- iOS 15 o superior
- Idiomas: español, inglés, catalán y gallego
- Anuncios con AdMob (consentimiento con UMP) y Premium con compras de Apple:
  `premium_monthly` (suscripción mensual, 1,99 €) y `premium_lifetime` (compra no consumible, 9,99 €)

## Desarrollo

```bash
flutter pub get
flutter test
flutter run
```

Sin `--dart-define` se usan los anuncios de prueba de Google. La carpeta `android/` solo sirve para probar en un
emulador desde Windows; la app se publica en el App Store.

## Publicar con Codemagic

1. **App Store Connect**: crea la app con el bundle ID `com.oeaon.testsoposiciones` y los dos productos de compra.
2. **Clave API**: en App Store Connect → Usuarios y acceso → Integraciones → Claves de API del equipo, crea una
   clave con rol *App Manager*. En Codemagic → Ajustes del equipo → Integraciones → App Store Connect, añádela con
   el nombre `OEAON` (sube el `.p8`, el Issuer ID y el Key ID).
3. **Variables**: en la app de Codemagic → Environment variables, grupo `admob`:
   `ADMOB_APP_ID`, `AD_BANNER`, `AD_INTERSTITIAL`, `AD_APP_OPEN`, `AD_REWARDED` y `APP_STORE_APPLE_ID`.
4. **Compilar**: lanza el workflow `ios-release` o crea una etiqueta `v1.0.0`. La build se sube a TestFlight y
   desde ahí se envía a revisión en App Store Connect.
