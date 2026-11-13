import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_gl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
    Locale('gl'),
  ];

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @loadError.
  ///
  /// In es, this message translates to:
  /// **'No se han podido cargar las preguntas.'**
  String get loadError;

  /// No description provided for @mastery.
  ///
  /// In es, this message translates to:
  /// **'Dominas {p1} de {p2} preguntas'**
  String mastery(int p1, int p2);

  /// No description provided for @streakNone.
  ///
  /// In es, this message translates to:
  /// **'Haz un test hoy para empezar tu racha.'**
  String get streakNone;

  /// No description provided for @bestExam.
  ///
  /// In es, this message translates to:
  /// **'Mejor nota en simulacro: {p1}'**
  String bestExam(String p1);

  /// No description provided for @quickTest.
  ///
  /// In es, this message translates to:
  /// **'Test rápido ({p1})'**
  String quickTest(int p1);

  /// No description provided for @reviewFailed.
  ///
  /// In es, this message translates to:
  /// **'Repasar fallos ({p1})'**
  String reviewFailed(int p1);

  /// No description provided for @examTitle.
  ///
  /// In es, this message translates to:
  /// **'Simulacro de examen'**
  String get examTitle;

  /// No description provided for @examLocked.
  ///
  /// In es, this message translates to:
  /// **'Examen de {p1} preguntas en {p2} minutos, con penalización por fallo como en las oposiciones de la Administración del Estado.'**
  String examLocked(int p1, int p2);

  /// No description provided for @examDescription.
  ///
  /// In es, this message translates to:
  /// **'{p1} preguntas de todos los temas, {p2} minutos. Cada fallo resta un tercio de acierto.'**
  String examDescription(int p1, int p2);

  /// No description provided for @examStart.
  ///
  /// In es, this message translates to:
  /// **'Empezar simulacro'**
  String get examStart;

  /// No description provided for @topics.
  ///
  /// In es, this message translates to:
  /// **'Temas'**
  String get topics;

  /// No description provided for @topicStats.
  ///
  /// In es, this message translates to:
  /// **'{p1} preguntas · {p2} % dominado'**
  String topicStats(int p1, int p2);

  /// No description provided for @questionOf.
  ///
  /// In es, this message translates to:
  /// **'Pregunta {p1} de {p2}'**
  String questionOf(int p1, int p2);

  /// No description provided for @quitTest.
  ///
  /// In es, this message translates to:
  /// **'Salir del test'**
  String get quitTest;

  /// No description provided for @quitTestText.
  ///
  /// In es, this message translates to:
  /// **'Si sales ahora no se guardará este test.'**
  String get quitTestText;

  /// No description provided for @quit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get quit;

  /// No description provided for @keepGoing.
  ///
  /// In es, this message translates to:
  /// **'Seguir'**
  String get keepGoing;

  /// No description provided for @answerRight.
  ///
  /// In es, this message translates to:
  /// **'¡Correcto!'**
  String get answerRight;

  /// No description provided for @answerWrong.
  ///
  /// In es, this message translates to:
  /// **'Incorrecto'**
  String get answerWrong;

  /// No description provided for @previous.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In es, this message translates to:
  /// **'Terminar'**
  String get finish;

  /// No description provided for @finishExamNow.
  ///
  /// In es, this message translates to:
  /// **'Entregar examen'**
  String get finishExamNow;

  /// No description provided for @finishExamText.
  ///
  /// In es, this message translates to:
  /// **'Has contestado {p1} de {p2} preguntas. Las que estén en blanco no restan.'**
  String finishExamText(int p1, int p2);

  /// No description provided for @results.
  ///
  /// In es, this message translates to:
  /// **'Resultado'**
  String get results;

  /// No description provided for @score.
  ///
  /// In es, this message translates to:
  /// **'Nota: {p1}'**
  String score(String p1);

  /// No description provided for @resultCounts.
  ///
  /// In es, this message translates to:
  /// **'{p1} aciertos · {p2} fallos · {p3} en blanco'**
  String resultCounts(int p1, int p2, int p3);

  /// No description provided for @resultPenalty.
  ///
  /// In es, this message translates to:
  /// **'Aciertos netos tras la penalización: {p1}'**
  String resultPenalty(String p1);

  /// No description provided for @backHome.
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio'**
  String get backHome;

  /// No description provided for @yourMistakes.
  ///
  /// In es, this message translates to:
  /// **'Tus fallos'**
  String get yourMistakes;

  /// No description provided for @yourAnswer.
  ///
  /// In es, this message translates to:
  /// **'Tu respuesta: {p1}'**
  String yourAnswer(String p1);

  /// No description provided for @correctAnswer.
  ///
  /// In es, this message translates to:
  /// **'Correcta: {p1}'**
  String correctAnswer(String p1);

  /// No description provided for @resetProgress.
  ///
  /// In es, this message translates to:
  /// **'Borrar mi progreso'**
  String get resetProgress;

  /// No description provided for @resetProgressText.
  ///
  /// In es, this message translates to:
  /// **'Se borrarán tus aciertos, fallos, racha y mejor nota. No se puede deshacer.'**
  String get resetProgressText;

  /// No description provided for @reset.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get reset;

  /// No description provided for @premiumFeatureExam.
  ///
  /// In es, this message translates to:
  /// **'Simulacros de examen con tiempo y penalización'**
  String get premiumFeatureExam;

  /// No description provided for @premiumSettingsText.
  ///
  /// In es, this message translates to:
  /// **'Quita los anuncios y desbloquea los simulacros de examen.'**
  String get premiumSettingsText;

  /// No description provided for @removeAds.
  ///
  /// In es, this message translates to:
  /// **'Quitar anuncios'**
  String get removeAds;

  /// No description provided for @privacyOptions.
  ///
  /// In es, this message translates to:
  /// **'Opciones de privacidad de anuncios'**
  String get privacyOptions;

  /// No description provided for @aboutTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get aboutTitle;

  /// No description provided for @aboutText.
  ///
  /// In es, this message translates to:
  /// **'Preguntas tipo test sobre la Constitución Española y las leyes 39/2015 y 40/2015 para preparar oposiciones. Las preguntas están en castellano, como en los exámenes de la Administración General del Estado.'**
  String get aboutText;

  /// No description provided for @sourceTitle.
  ///
  /// In es, this message translates to:
  /// **'Fuentes oficiales'**
  String get sourceTitle;

  /// No description provided for @source1.
  ///
  /// In es, this message translates to:
  /// **'Constitución Española (BOE)'**
  String get source1;

  /// No description provided for @source2.
  ///
  /// In es, this message translates to:
  /// **'Ley 39/2015 (BOE)'**
  String get source2;

  /// No description provided for @source3.
  ///
  /// In es, this message translates to:
  /// **'Ley 40/2015 (BOE)'**
  String get source3;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión {p1}'**
  String version(String p1);

  /// No description provided for @streak.
  ///
  /// In es, this message translates to:
  /// **'{p1, plural, =1{🔥 {p1} día seguido estudiando} other{🔥 {p1} días seguidos estudiando}}'**
  String streak(int p1);

  /// No description provided for @premiumTitle.
  ///
  /// In es, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// No description provided for @premiumBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get premiumBack;

  /// No description provided for @premiumHeadline.
  ///
  /// In es, this message translates to:
  /// **'Pásate a Premium'**
  String get premiumHeadline;

  /// No description provided for @premiumActive.
  ///
  /// In es, this message translates to:
  /// **'Ya eres Premium. ¡Gracias por tu apoyo!'**
  String get premiumActive;

  /// No description provided for @premiumBenefitNoAds.
  ///
  /// In es, this message translates to:
  /// **'Sin anuncios'**
  String get premiumBenefitNoAds;

  /// No description provided for @premiumMonthly.
  ///
  /// In es, this message translates to:
  /// **'{p1} al mes'**
  String premiumMonthly(String p1);

  /// No description provided for @premiumLifetime.
  ///
  /// In es, this message translates to:
  /// **'{p1}, pago único para siempre'**
  String premiumLifetime(String p1);

  /// No description provided for @premiumLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando precio…'**
  String get premiumLoading;

  /// No description provided for @premiumStoreUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No se puede conectar con el App Store. Inténtalo más tarde.'**
  String get premiumStoreUnavailable;

  /// No description provided for @premiumRestore.
  ///
  /// In es, this message translates to:
  /// **'Restaurar compras'**
  String get premiumRestore;

  /// No description provided for @premiumLegal.
  ///
  /// In es, this message translates to:
  /// **'La suscripción se renueva cada mes y puedes cancelarla cuando quieras en el App Store.'**
  String get premiumLegal;

  /// No description provided for @lockedWatchAd.
  ///
  /// In es, this message translates to:
  /// **'Ver un anuncio y desbloquear 24 h'**
  String get lockedWatchAd;

  /// No description provided for @lockedGoPremium.
  ///
  /// In es, this message translates to:
  /// **'Hazte Premium'**
  String get lockedGoPremium;

  /// No description provided for @rewardedUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No hay ningún anuncio disponible ahora mismo. Prueba dentro de un rato.'**
  String get rewardedUnavailable;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In es, this message translates to:
  /// **'Términos de uso'**
  String get termsOfUse;

  /// No description provided for @aboutDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'App independiente, sin relación con ningún organismo público.'**
  String get aboutDisclaimer;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es', 'gl'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return LCa();
    case 'en':
      return LEn();
    case 'es':
      return LEs();
    case 'gl':
      return LGl();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
