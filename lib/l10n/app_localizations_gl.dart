// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class LGl extends L {
  LGl([String locale = 'gl']) : super(locale);

  @override
  String get settings => 'Axustes';

  @override
  String get loadError => 'Non se puideron cargar as preguntas.';

  @override
  String mastery(int p1, int p2) {
    return 'Dominas $p1 de $p2 preguntas';
  }

  @override
  String get streakNone => 'Fai un test hoxe para comezar a túa racha.';

  @override
  String bestExam(String p1) {
    return 'Mellor nota en simulacro: $p1';
  }

  @override
  String quickTest(int p1) {
    return 'Test rápido ($p1)';
  }

  @override
  String reviewFailed(int p1) {
    return 'Repasar erros ($p1)';
  }

  @override
  String get examTitle => 'Simulacro de exame';

  @override
  String examLocked(int p1, int p2) {
    return 'Exame de $p1 preguntas en $p2 minutos, con penalización por erro como nas oposicións da Administración do Estado.';
  }

  @override
  String examDescription(int p1, int p2) {
    return '$p1 preguntas de todos os temas, $p2 minutos. Cada erro resta un terzo de acerto.';
  }

  @override
  String get examStart => 'Comezar simulacro';

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
  String get quitTest => 'Saír do test';

  @override
  String get quitTestText => 'Se saes agora non se gardará este test.';

  @override
  String get quit => 'Saír';

  @override
  String get keepGoing => 'Seguir';

  @override
  String get answerRight => 'Correcto!';

  @override
  String get answerWrong => 'Incorrecto';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Seguinte';

  @override
  String get finish => 'Rematar';

  @override
  String get finishExamNow => 'Entregar exame';

  @override
  String finishExamText(int p1, int p2) {
    return 'Contestaches $p1 de $p2 preguntas. As que estean en branco non restan.';
  }

  @override
  String get results => 'Resultado';

  @override
  String score(String p1) {
    return 'Nota: $p1';
  }

  @override
  String resultCounts(int p1, int p2, int p3) {
    return '$p1 acertos · $p2 erros · $p3 en branco';
  }

  @override
  String resultPenalty(String p1) {
    return 'Acertos netos tras a penalización: $p1';
  }

  @override
  String get backHome => 'Volver ao inicio';

  @override
  String get yourMistakes => 'Os teus erros';

  @override
  String yourAnswer(String p1) {
    return 'A túa resposta: $p1';
  }

  @override
  String correctAnswer(String p1) {
    return 'Correcta: $p1';
  }

  @override
  String get resetProgress => 'Borrar o meu progreso';

  @override
  String get resetProgressText =>
      'Borraranse os teus acertos, erros, racha e mellor nota. Non se pode desfacer.';

  @override
  String get reset => 'Borrar';

  @override
  String get premiumFeatureExam =>
      'Simulacros de exame con tempo e penalización';

  @override
  String get premiumSettingsText =>
      'Quita os anuncios e desbloquea os simulacros de exame.';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get privacyOptions => 'Opcións de privacidade dos anuncios';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutText =>
      'Preguntas tipo test sobre a Constitución Española e as leis 39/2015 e 40/2015 para preparar oposicións. As preguntas están en castelán, como nos exames da Administración Xeral do Estado.';

  @override
  String get sourceTitle => 'Fontes oficiais';

  @override
  String get source1 => 'Constitución Española (BOE)';

  @override
  String get source2 => 'Lei 39/2015 (BOE)';

  @override
  String get source3 => 'Lei 40/2015 (BOE)';

  @override
  String version(String p1) {
    return 'Versión $p1';
  }

  @override
  String streak(int p1) {
    String _temp0 = intl.Intl.pluralLogic(
      p1,
      locale: localeName,
      other: '🔥 $p1 días seguidos estudando',
      one: '🔥 $p1 día seguido estudando',
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
  String get premiumActive => 'Xa es Premium. Grazas polo teu apoio!';

  @override
  String get premiumBenefitNoAds => 'Sen anuncios';

  @override
  String premiumMonthly(String p1) {
    return '$p1 ao mes';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, pagamento único para sempre';
  }

  @override
  String get premiumLoading => 'Cargando o prezo…';

  @override
  String get premiumStoreUnavailable =>
      'Non se pode conectar coa App Store. Téntao máis tarde.';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumLegal =>
      'A subscrición renóvase cada mes e podes cancelala cando queiras na App Store.';

  @override
  String get lockedWatchAd => 'Ver un anuncio e desbloquear 24 h';

  @override
  String get lockedGoPremium => 'Faite Premium';

  @override
  String get rewardedUnavailable =>
      'Agora mesmo non hai ningún anuncio dispoñible. Proba dentro dun anaco.';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get termsOfUse => 'Termos de uso';

  @override
  String get aboutDisclaimer =>
      'App independente, sen relación con ningún organismo público.';
}
