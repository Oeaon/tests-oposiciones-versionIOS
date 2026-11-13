// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LEs extends L {
  LEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Ajustes';

  @override
  String get loadError => 'No se han podido cargar las preguntas.';

  @override
  String mastery(int p1, int p2) {
    return 'Dominas $p1 de $p2 preguntas';
  }

  @override
  String get streakNone => 'Haz un test hoy para empezar tu racha.';

  @override
  String bestExam(String p1) {
    return 'Mejor nota en simulacro: $p1';
  }

  @override
  String quickTest(int p1) {
    return 'Test rápido ($p1)';
  }

  @override
  String reviewFailed(int p1) {
    return 'Repasar fallos ($p1)';
  }

  @override
  String get examTitle => 'Simulacro de examen';

  @override
  String examLocked(int p1, int p2) {
    return 'Examen de $p1 preguntas en $p2 minutos, con penalización por fallo como en las oposiciones de la Administración del Estado.';
  }

  @override
  String examDescription(int p1, int p2) {
    return '$p1 preguntas de todos los temas, $p2 minutos. Cada fallo resta un tercio de acierto.';
  }

  @override
  String get examStart => 'Empezar simulacro';

  @override
  String get topics => 'Temas';

  @override
  String topicStats(int p1, int p2) {
    return '$p1 preguntas · $p2 % dominado';
  }

  @override
  String questionOf(int p1, int p2) {
    return 'Pregunta $p1 de $p2';
  }

  @override
  String get quitTest => 'Salir del test';

  @override
  String get quitTestText => 'Si sales ahora no se guardará este test.';

  @override
  String get quit => 'Salir';

  @override
  String get keepGoing => 'Seguir';

  @override
  String get answerRight => '¡Correcto!';

  @override
  String get answerWrong => 'Incorrecto';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get finish => 'Terminar';

  @override
  String get finishExamNow => 'Entregar examen';

  @override
  String finishExamText(int p1, int p2) {
    return 'Has contestado $p1 de $p2 preguntas. Las que estén en blanco no restan.';
  }

  @override
  String get results => 'Resultado';

  @override
  String score(String p1) {
    return 'Nota: $p1';
  }

  @override
  String resultCounts(int p1, int p2, int p3) {
    return '$p1 aciertos · $p2 fallos · $p3 en blanco';
  }

  @override
  String resultPenalty(String p1) {
    return 'Aciertos netos tras la penalización: $p1';
  }

  @override
  String get backHome => 'Volver al inicio';

  @override
  String get yourMistakes => 'Tus fallos';

  @override
  String yourAnswer(String p1) {
    return 'Tu respuesta: $p1';
  }

  @override
  String correctAnswer(String p1) {
    return 'Correcta: $p1';
  }

  @override
  String get resetProgress => 'Borrar mi progreso';

  @override
  String get resetProgressText =>
      'Se borrarán tus aciertos, fallos, racha y mejor nota. No se puede deshacer.';

  @override
  String get reset => 'Borrar';

  @override
  String get premiumFeatureExam =>
      'Simulacros de examen con tiempo y penalización';

  @override
  String get premiumSettingsText =>
      'Quita los anuncios y desbloquea los simulacros de examen.';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get privacyOptions => 'Opciones de privacidad de anuncios';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutText =>
      'Preguntas tipo test sobre la Constitución Española y las leyes 39/2015 y 40/2015 para preparar oposiciones. Las preguntas están en castellano, como en los exámenes de la Administración General del Estado.';

  @override
  String get sourceTitle => 'Fuentes oficiales';

  @override
  String get source1 => 'Constitución Española (BOE)';

  @override
  String get source2 => 'Ley 39/2015 (BOE)';

  @override
  String get source3 => 'Ley 40/2015 (BOE)';

  @override
  String version(String p1) {
    return 'Versión $p1';
  }

  @override
  String streak(int p1) {
    String _temp0 = intl.Intl.pluralLogic(
      p1,
      locale: localeName,
      other: '🔥 $p1 días seguidos estudiando',
      one: '🔥 $p1 día seguido estudiando',
    );
    return '$_temp0';
  }

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumBack => 'Volver';

  @override
  String get premiumHeadline => 'Pásate a Premium';

  @override
  String get premiumActive => 'Ya eres Premium. ¡Gracias por tu apoyo!';

  @override
  String get premiumBenefitNoAds => 'Sin anuncios';

  @override
  String premiumMonthly(String p1) {
    return '$p1 al mes';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, pago único para siempre';
  }

  @override
  String get premiumLoading => 'Cargando precio…';

  @override
  String get premiumStoreUnavailable =>
      'No se puede conectar con el App Store. Inténtalo más tarde.';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumLegal =>
      'La suscripción se renueva cada mes y puedes cancelarla cuando quieras en el App Store.';

  @override
  String get lockedWatchAd => 'Ver un anuncio y desbloquear 24 h';

  @override
  String get lockedGoPremium => 'Hazte Premium';

  @override
  String get rewardedUnavailable =>
      'No hay ningún anuncio disponible ahora mismo. Prueba dentro de un rato.';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get aboutDisclaimer =>
      'App independiente, sin relación con ningún organismo público.';
}
