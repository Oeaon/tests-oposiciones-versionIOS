// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get loadError => 'The questions could not be loaded.';

  @override
  String mastery(int p1, int p2) {
    return 'You master $p1 of $p2 questions';
  }

  @override
  String get streakNone => 'Take a test today to start your streak.';

  @override
  String bestExam(String p1) {
    return 'Best mock exam score: $p1';
  }

  @override
  String quickTest(int p1) {
    return 'Quick test ($p1)';
  }

  @override
  String reviewFailed(int p1) {
    return 'Review mistakes ($p1)';
  }

  @override
  String get examTitle => 'Mock exam';

  @override
  String examLocked(int p1, int p2) {
    return 'A $p1-question exam in $p2 minutes, with a penalty for wrong answers as in Spanish civil service exams.';
  }

  @override
  String examDescription(int p1, int p2) {
    return '$p1 questions from every topic, $p2 minutes. Each wrong answer takes off a third of a right one.';
  }

  @override
  String get examStart => 'Start mock exam';

  @override
  String get topics => 'Topics';

  @override
  String topicStats(int p1, int p2) {
    return '$p1 questions · $p2% mastered';
  }

  @override
  String questionOf(int p1, int p2) {
    return 'Question $p1 of $p2';
  }

  @override
  String get quitTest => 'Leave the test';

  @override
  String get quitTestText => 'If you leave now this test will not be saved.';

  @override
  String get quit => 'Leave';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get answerRight => 'Correct!';

  @override
  String get answerWrong => 'Wrong';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get finishExamNow => 'Hand in exam';

  @override
  String finishExamText(int p1, int p2) {
    return 'You have answered $p1 of $p2 questions. Blank ones do not count against you.';
  }

  @override
  String get results => 'Result';

  @override
  String score(String p1) {
    return 'Score: $p1';
  }

  @override
  String resultCounts(int p1, int p2, int p3) {
    return '$p1 right · $p2 wrong · $p3 blank';
  }

  @override
  String resultPenalty(String p1) {
    return 'Net right answers after the penalty: $p1';
  }

  @override
  String get backHome => 'Back to start';

  @override
  String get yourMistakes => 'Your mistakes';

  @override
  String yourAnswer(String p1) {
    return 'Your answer: $p1';
  }

  @override
  String correctAnswer(String p1) {
    return 'Correct: $p1';
  }

  @override
  String get resetProgress => 'Reset my progress';

  @override
  String get resetProgressText =>
      'Your right and wrong answers, streak and best score will be deleted. This cannot be undone.';

  @override
  String get reset => 'Reset';

  @override
  String get premiumFeatureExam => 'Timed mock exams with penalty';

  @override
  String get premiumSettingsText => 'Remove the ads and unlock the mock exams.';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get privacyOptions => 'Ad privacy options';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutText =>
      'Multiple-choice questions on the Spanish Constitution and Laws 39/2015 and 40/2015 to prepare for civil service exams. Questions are in Spanish, as in the State General Administration exams.';

  @override
  String get sourceTitle => 'Official sources';

  @override
  String get source1 => 'Spanish Constitution (BOE)';

  @override
  String get source2 => 'Law 39/2015 (BOE)';

  @override
  String get source3 => 'Law 40/2015 (BOE)';

  @override
  String version(String p1) {
    return 'Version $p1';
  }

  @override
  String streak(int p1) {
    String _temp0 = intl.Intl.pluralLogic(
      p1,
      locale: localeName,
      other: '🔥 $p1 days in a row studying',
      one: '🔥 $p1 day in a row studying',
    );
    return '$_temp0';
  }

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumBack => 'Back';

  @override
  String get premiumHeadline => 'Go Premium';

  @override
  String get premiumActive => 'You are Premium. Thanks for your support!';

  @override
  String get premiumBenefitNoAds => 'No ads';

  @override
  String premiumMonthly(String p1) {
    return '$p1 per month';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, one-off payment forever';
  }

  @override
  String get premiumLoading => 'Loading price…';

  @override
  String get premiumStoreUnavailable =>
      'Cannot connect to the App Store. Try again later.';

  @override
  String get premiumRestore => 'Restore purchases';

  @override
  String get premiumLegal =>
      'The subscription renews every month and you can cancel it at any time in the App Store.';

  @override
  String get lockedWatchAd => 'Watch an ad to unlock for 24 h';

  @override
  String get lockedGoPremium => 'Go Premium';

  @override
  String get rewardedUnavailable =>
      'No ad is available right now. Try again in a while.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get aboutDisclaimer =>
      'Independent app, not affiliated with any public body.';
}
