// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class LCa extends L {
  LCa([String locale = 'ca']) : super(locale);

  @override
  String get settings => 'Configuració';

  @override
  String get loadError => 'No s\'han pogut carregar les preguntes.';

  @override
  String mastery(int p1, int p2) {
    return 'Domines $p1 de $p2 preguntes';
  }

  @override
  String get streakNone => 'Fes un test avui per començar la teva ratxa.';

  @override
  String bestExam(String p1) {
    return 'Millor nota en simulacre: $p1';
  }

  @override
  String quickTest(int p1) {
    return 'Test ràpid ($p1)';
  }

  @override
  String reviewFailed(int p1) {
    return 'Repassa errors ($p1)';
  }

  @override
  String get examTitle => 'Simulacre d\'examen';

  @override
  String examLocked(int p1, int p2) {
    return 'Examen de $p1 preguntes en $p2 minuts, amb penalització per error com a les oposicions de l\'Administració de l\'Estat.';
  }

  @override
  String examDescription(int p1, int p2) {
    return '$p1 preguntes de tots els temes, $p2 minuts. Cada error resta un terç d\'encert.';
  }

  @override
  String get examStart => 'Comença el simulacre';

  @override
  String get topics => 'Temes';

  @override
  String topicStats(int p1, int p2) {
    return '$p1 preguntes · $p2 % dominat';
  }

  @override
  String questionOf(int p1, int p2) {
    return 'Pregunta $p1 de $p2';
  }

  @override
  String get quitTest => 'Surt del test';

  @override
  String get quitTestText => 'Si surts ara no es desarà aquest test.';

  @override
  String get quit => 'Surt';

  @override
  String get keepGoing => 'Continua';

  @override
  String get answerRight => 'Correcte!';

  @override
  String get answerWrong => 'Incorrecte';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Següent';

  @override
  String get finish => 'Acaba';

  @override
  String get finishExamNow => 'Lliura l\'examen';

  @override
  String finishExamText(int p1, int p2) {
    return 'Has contestat $p1 de $p2 preguntes. Les que estiguin en blanc no resten.';
  }

  @override
  String get results => 'Resultat';

  @override
  String score(String p1) {
    return 'Nota: $p1';
  }

  @override
  String resultCounts(int p1, int p2, int p3) {
    return '$p1 encerts · $p2 errors · $p3 en blanc';
  }

  @override
  String resultPenalty(String p1) {
    return 'Encerts nets després de la penalització: $p1';
  }

  @override
  String get backHome => 'Torna a l\'inici';

  @override
  String get yourMistakes => 'Els teus errors';

  @override
  String yourAnswer(String p1) {
    return 'La teva resposta: $p1';
  }

  @override
  String correctAnswer(String p1) {
    return 'Correcta: $p1';
  }

  @override
  String get resetProgress => 'Esborra el meu progrés';

  @override
  String get resetProgressText =>
      'S\'esborraran els teus encerts, errors, ratxa i millor nota. No es pot desfer.';

  @override
  String get reset => 'Esborra';

  @override
  String get premiumFeatureExam =>
      'Simulacres d\'examen amb temps i penalització';

  @override
  String get premiumSettingsText =>
      'Treu els anuncis i desbloqueja els simulacres d\'examen.';

  @override
  String get removeAds => 'Treure els anuncis';

  @override
  String get privacyOptions => 'Opcions de privadesa dels anuncis';

  @override
  String get aboutTitle => 'Quant a';

  @override
  String get aboutText =>
      'Preguntes tipus test sobre la Constitució Espanyola i les lleis 39/2015 i 40/2015 per preparar oposicions. Les preguntes són en castellà, com als exàmens de l\'Administració General de l\'Estat.';

  @override
  String get sourceTitle => 'Fonts oficials';

  @override
  String get source1 => 'Constitució Espanyola (BOE)';

  @override
  String get source2 => 'Llei 39/2015 (BOE)';

  @override
  String get source3 => 'Llei 40/2015 (BOE)';

  @override
  String version(String p1) {
    return 'Versió $p1';
  }

  @override
  String streak(int p1) {
    String _temp0 = intl.Intl.pluralLogic(
      p1,
      locale: localeName,
      other: '🔥 $p1 dies seguits estudiant',
      one: '🔥 $p1 dia seguit estudiant',
    );
    return '$_temp0';
  }

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumBack => 'Tornar';

  @override
  String get premiumHeadline => 'Passa\'t a Premium';

  @override
  String get premiumActive => 'Ja ets Premium. Gràcies pel teu suport!';

  @override
  String get premiumBenefitNoAds => 'Sense anuncis';

  @override
  String premiumMonthly(String p1) {
    return '$p1 al mes';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, pagament únic per sempre';
  }

  @override
  String get premiumLoading => 'Carregant el preu…';

  @override
  String get premiumStoreUnavailable =>
      'No es pot connectar amb l\'App Store. Torna-ho a provar més tard.';

  @override
  String get premiumRestore => 'Restaura les compres';

  @override
  String get premiumLegal =>
      'La subscripció es renova cada mes i la pots cancel·lar quan vulguis a l\'App Store.';

  @override
  String get lockedWatchAd => 'Mira un anunci i desbloqueja-ho 24 h';

  @override
  String get lockedGoPremium => 'Fes-te Premium';

  @override
  String get rewardedUnavailable =>
      'Ara mateix no hi ha cap anunci disponible. Prova-ho d\'aquí a una estona.';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get termsOfUse => 'Termes d\'ús';

  @override
  String get aboutDisclaimer =>
      'App independent, sense relació amb cap organisme públic.';
}
