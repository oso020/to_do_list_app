import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/theme_provider.dart';

import '../../color_app.dart';
import '../../providers/language_provider.dart';
import 'modal_sheet_language.dart';
import 'modal_sheet_theme.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var languageProvider = Provider.of<LanguageProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: ColorApp.primaryColor,
          width: double.infinity,
          height: height / 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.language,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          child: InkWell(
            onTap: () {
              showBottomModelLanguage();
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width / 100, vertical: height / 200),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: themeProvider.theme == ThemeMode.light
                      ? ColorApp.whiteColor
                      : ColorApp.itemsDarkColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorApp.primaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    languageProvider.locale == "en"
                        ? AppLocalizations.of(context)!.english
                        : AppLocalizations.of(context)!.arabic,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: themeProvider.theme == ThemeMode.light
                        ? ColorApp.blackColor
                        : ColorApp.whiteColor,
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Text(
            AppLocalizations.of(context)!.theme,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          child: InkWell(
            onTap: () {
              showBottomModelTheme();
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: width / 100, vertical: height / 200),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: themeProvider.theme == ThemeMode.light
                      ? ColorApp.whiteColor
                      : ColorApp.itemsDarkColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorApp.primaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.dark,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: themeProvider.theme == ThemeMode.light
                        ? ColorApp.blackColor
                        : ColorApp.whiteColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showBottomModelLanguage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ModalSheet(),
    );
  }

  void showBottomModelTheme() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ModalSheetTheme(),
    );
  }
}
