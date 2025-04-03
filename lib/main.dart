import 'package:flutter/material.dart';
import 'package:my_expenses/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_expenses/screens/transaction_form_screen.dart';
import 'package:my_expenses/utils/app_routes.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MaterialApp(
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: const Color(0xFF1AD409),
          secondary: Color(0xFFEEA837),
          tertiary: const Color(0xFF4E71FF),
          surface: Color(0xFF9897A1),
        ),
        textTheme: theme.textTheme.copyWith(
          titleLarge: const TextStyle(
            fontSize: 23,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
          labelLarge: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          labelMedium: const TextStyle(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: const TextStyle(
            fontSize: 17,
            color: Color(0xFF656066),
            // fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            color: Color(0xFF656066),
          ),
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.HOME_SCREEN,
      routes: {
        AppRoutes.HOME_SCREEN: (ctx) => const HomeScreen(),
        AppRoutes.TRANSACTION_FORM_SCREEN: (ctx) =>
            const TransactionFormScreen(),
      },
    );
  }
}
