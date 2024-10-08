import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/Home/login/login_screen.dart';

import '../../model/task_model.dart';
import '../../providers/getTaskProvider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_auth_provider.dart';
import '../../theme_and_color/color_app.dart';
import '../../widgets_and_functions/dialog_model.dart';

class ChangeDetilesTaskScreen extends StatefulWidget {
  static const String routeName = "changeDetiles";

  const ChangeDetilesTaskScreen({super.key});

  @override
  State<ChangeDetilesTaskScreen> createState() =>
      _ChangeDetilesTaskScreenState();
}

class _ChangeDetilesTaskScreenState extends State<ChangeDetilesTaskScreen> {
  final form = GlobalKey<FormState>();
  var selectDate = DateTime.now();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  late Task args;
  late GetTaskProvider getTaskProvider;
  late ThemeProvider themeProvider;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    themeProvider = Provider.of<ThemeProvider>(context);
    getTaskProvider = Provider.of<GetTaskProvider>(context);
    args = ModalRoute.of(context)?.settings.arguments as Task;
    if (title.text.isEmpty || description.text.isEmpty) {
      title.text = args.title;
      description.text = args.description;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.to_do_list,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: ColorApp.primaryColor,
            width: double.infinity,
            height: height / 3,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: height / 10, horizontal: width / 50),
            padding: const EdgeInsets.all(10),
            height: height / 1.5,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: themeProvider.theme == ThemeMode.light
                  ? ColorApp.whiteColor
                  : ColorApp.itemsDarkColor,
            ),
            child: Form(
              key: form,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.edit_task,
                      textAlign: TextAlign.center,
                      style: themeProvider.theme == ThemeMode.light
                          ? Theme.of(context).textTheme.bodyMedium
                          : Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: ColorApp.whiteColor, fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            validator: (String? text) {
                              if (text == null || text.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .please_enter_tilte;
                              }
                              return null;
                            },
                            controller: title,
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 12),
                                hintText:
                                    AppLocalizations.of(context)!.change_title,
                                hintStyle:
                                    Theme.of(context).textTheme.bodySmall),
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          TextFormField(
                            validator: (String? text) {
                              if (text == null || text.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .please_enter_description;
                              }
                              return null;
                            },
                            controller: description,
                            maxLines: 4,
                            style: Theme.of(context).textTheme.bodySmall,
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 12),
                                hintText: AppLocalizations.of(context)!
                                    .change_Description,
                                hintStyle:
                                    Theme.of(context).textTheme.bodySmall),
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          // InkWell(
                          //   onTap: (){
                          //     openDateSheet();
                          //   },
                          //   child: Text(
                          //     AppLocalizations.of(context)!.select_time,
                          //
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodySmall!
                          //         .copyWith(color: ColorApp.grayColor),
                          //   ),
                          // ),
                          SizedBox(
                            height: height / 200,
                          ),
                          InkWell(
                            onTap: () {
                              openDateSheet();
                            },
                            child: Text(
                              "${args.dateTime.day}/${args.dateTime.month}/${args.dateTime.year}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()async {
                        if (form.currentState!.validate()) {
                          final List<ConnectivityResult> connectivityResult =
                          await (Connectivity().checkConnectivity());
                          if (connectivityResult.contains(
                              ConnectivityResult.mobile) ||
                              connectivityResult.contains(
                                  ConnectivityResult.wifi)) {
                            editTask();
                          }else{
                            DailogUtils.showMessage(
                                color: themeProvider.theme == ThemeMode.light
                                    ? ColorApp.whiteColor
                                    : ColorApp.itemsDarkColor,
                                context: context,
                                title: AppLocalizations.of(context)!.faild,
                                content: AppLocalizations.of(context)!.network_request_failed,
                                button1Name: AppLocalizations.of(context)!.ok,
                                button1Function: (){
                                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName,
                                        (route) => false,
                                  );
                                }
                            );
                          }
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.save_changes,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorApp.whiteColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void openDateSheet() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: args.dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: ColorApp.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor:
                Colors.white, // Background color of the dialog
          ),
          child: child!,
        );
      },
    );

    selectDate = chosenDate ?? selectDate;
    args.dateTime = selectDate;
    setState(() {});
  }

  editTask() {
    DailogUtils.showLoading(
      context,
      themeProvider.theme == ThemeMode.light
          ? ColorApp.whiteColor
          : ColorApp.itemsDarkColor,
    );
    var authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    getTaskProvider
        .editTask(args.id, title.text, description.text,
            authProvider.currentUser?.id ?? "", selectDate)
        .then(
      (value) {
        Navigator.pop(context);
        getTaskProvider
            .getTaskFromFireStore(authProvider.currentUser?.id ?? "");
        DailogUtils.hideLoading(context);
      DailogUtils.showMessage(
        color: themeProvider.theme == ThemeMode.light
            ? ColorApp.whiteColor
            : ColorApp.itemsDarkColor,
        title: AppLocalizations.of(context)!.success,
        content: AppLocalizations.of(context)!.update_successfully,
        context: context,
        button1Name: AppLocalizations.of(context)!.ok,
      );
      },
    );
  }
}
