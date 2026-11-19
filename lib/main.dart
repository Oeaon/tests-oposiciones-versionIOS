import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_info.dart';
import 'core/question_bank.dart';
import 'core/quiz.dart';
import 'data/progress_store.dart';
import 'data/question_repository.dart';
import 'l10n/app_localizations.dart';
import 'monetization/monetization.dart';
import 'monetization/monetization_ui.dart';
import 'ui/home_screen.dart';
import 'ui/quiz_screen.dart';
import 'ui/result_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/study.dart';

const _seed = Color(0xFF00695C);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final monetization = await Monetization.create();
  final store = await ProgressStore.open();
  runApp(App(monetization: monetization, store: store, questions: QuestionRepository()));
}

class App extends StatelessWidget {
  const App({super.key, required this.monetization, required this.store, required this.questions});

  final Monetization monetization;
  final ProgressStore store;
  final QuestionRepository questions;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppInfo.name,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _seed)),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark)),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: Root(monetization: monetization, store: store, questions: questions),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key, required this.monetization, required this.store, required this.questions});

  final Monetization monetization;
  final ProgressStore store;
  final QuestionRepository questions;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late final Future<List<QuestionBank>> _banks = widget.questions.banks();

  @override
  void initState() {
    super.initState();
    // El consentimiento se pide con la primera pantalla ya dibujada.
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.monetization.gatherConsent());
  }

  void _startQuiz(QuizStart start) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => QuizScreen(start: start, onFinish: (session) => _finishQuiz(context, start, session)),
    ));
  }

  void _finishQuiz(BuildContext quizContext, QuizStart start, QuizSession session) {
    final result = session.result();
    widget.store.record(
      outcomes: session.outcomes(),
      bankId: start.bank.id,
      examScore: session.mode == QuizMode.exam ? result.score : null,
      today: DateTime.now(),
    );
    Navigator.of(quizContext).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => ResultScreen(bank: start.bank, session: session, monetization: widget.monetization),
    ));
    // Terminar un test es la pausa natural para un intersticial (con límite de frecuencia).
    widget.monetization.maybeShowInterstitial();
  }

  void _openPremium() {
    final l = L.of(context);
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => PremiumScreen(
        monetization: widget.monetization,
        features: [l.premiumFeatureExam],
        privacyUrl: AppInfo.privacyUrl,
        termsUrl: AppInfo.termsUrl,
      ),
    ));
  }

  void _openSettings() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final l = L.of(context);
      return SettingsScreen(
        monetization: widget.monetization,
        onOpenPremium: _openPremium,
        sourceLabels: [l.source1, l.source2, l.source3],
        appSection: [_ResetProgress(store: widget.store)],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _banks,
      builder: (context, snapshot) => HomeScreen(
        banks: snapshot,
        store: widget.store,
        monetization: widget.monetization,
        onStart: _startQuiz,
        onOpenSettings: _openSettings,
        onOpenPremium: _openPremium,
      ),
    );
  }
}

class _ResetProgress extends StatelessWidget {
  const _ResetProgress({required this.store});

  final ProgressStore store;

  Future<void> _confirm(BuildContext context) async {
    final l = L.of(context);
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.resetProgress),
        content: Text(l.resetProgressText),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.keepGoing)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(l.reset)),
        ],
      ),
    );
    if (reset == true) await store.reset();
  }

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton(onPressed: () => _confirm(context), child: Text(L.of(context).resetProgress)),
      );
}
