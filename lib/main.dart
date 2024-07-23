import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/Home/home_screen.dart';
import 'package:to_do_app/providers/language_provider.dart';
import 'package:to_do_app/providers/theme_provider.dart';
import 'package:to_do_app/theme_app.dart';

import 'Home/to_do_list/change_detiles_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final String? savedLanguage = sharedPreferences.getString('appLanguage');
  final bool? theme = sharedPreferences.getBool('theme');
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(locale: savedLanguage ?? "en"),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(mode: theme ?? false),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Home.routeName,
      theme: ThemeApp.themeLight,
      themeMode: themeProvider.theme,
      darkTheme: ThemeApp.themeDark,
      locale: Locale(languageProvider.locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        Home.routeName: (context) => Home(),
        ChangeDetilesTaskScreen.routeName: (context) =>
            ChangeDetilesTaskScreen(),
      },
    );
  }
}


