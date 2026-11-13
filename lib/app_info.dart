/// Datos propios de esta app: nombre, web, textos legales y fuentes oficiales.
class AppInfo {
  AppInfo._();

  static const name = 'Tests Oposiciones';
  static const privacyUrl = 'https://oeaon.github.io/tests-oposiciones/privacy.html';
  static const termsUrl = 'https://oeaon.github.io/tests-oposiciones/terms.html';

  /// Fuentes oficiales que se enlazan en Ajustes (lo exigen las tiendas para información de organismos públicos).
  static const officialSources = [
    'https://www.boe.es/buscar/act.php?id=BOE-A-1978-31229',
    'https://www.boe.es/buscar/act.php?id=BOE-A-2015-10565',
    'https://www.boe.es/buscar/act.php?id=BOE-A-2015-10566',
  ];
}
