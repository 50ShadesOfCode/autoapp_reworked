import 'package:auto_app/features/settings/bloc/settings_bloc.dart';
import 'package:auto_app/features/settings/notifications_page/bloc/notifications_bloc.dart';
import 'package:auto_app/features/settings/notifications_page/notifications_page.dart';
import 'package:core/core.dart';
import 'package:core_ui/src/theme_provider.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext context, SettingsState state) => Scaffold(
        appBar: AppBar(
          title: const Text('Настройки'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                        flex: 75,
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: 'Имя пользователя'),
                          controller: _usernameController,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_usernameController.text == '') {
                            return;
                          }
                          BlocProvider.of<SettingsBloc>(context).add(
                              SetUsernameEvent(
                                  username: _usernameController.text));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Имя пользователя сохранено'),
                          ));
                        },
                        child: const Text('Сохранить'),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Темная тема'),
                      Switch.adaptive(
                        value: themeProvider.isDarkMode,
                        onChanged: (bool value) {
                          final ThemeProvider provider =
                              Provider.of<ThemeProvider>(context,
                                  listen: false);
                          provider.toggleTheme(value);
                          BlocProvider.of<SettingsBloc>(context)
                              .add(SwitchThemeEvent());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: DropdownButton<int>(
                      hint: const Text('Выберите частоту уведомлений'),
                      value: state.selectedRate,
                      onChanged: (int? value) async {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SelectRateEvent(selectedRate: value));
                      },
                      items: <DropdownMenuItem<int>>[
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: const <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Не показывать уведомления',
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: const <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Показывать каждые 45 минут',
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Row(
                            children: const <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Показывать каждый час',
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Row(
                            children: const <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Показывать ежедневно',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: TextButton(
                      onPressed: () => <void>{
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                BlocProvider<NotificationsBloc>(
                              create: (BuildContext context) =>
                                  NotificationsBloc(
                                apiProvider: appLocator.get<ApiProvider>(),
                                prefsProvider: appLocator.get<PrefsProvider>(),
                              ),
                              child: NotificationsPage(),
                            ),
                          ),
                        )
                      },
                      child: const Text('Изменить параметры уведомлений'),
                    ),
                  ),
                ]),
              ),

              //поле для ввода сообщения обратной связи. при нажатии на отправить открывается почта уже с введенной темой текстом и тд
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                        flex: 75,
                        child: TextField(
                          decoration:
                              const InputDecoration(hintText: 'Обратная связь'),
                          controller: _mailController,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      //TODO: Move to bloc
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_mailController.text == '') {
                            return;
                          }
                          final Email email = Email(
                              body: _mailController.text,
                              subject: 'Обратная связь в приложении',
                              recipients: <String>['kaktymail@gmail.com'],
                              isHTML: false);
                          await FlutterEmailSender.send(email);
                        },
                        child: const Text('Отправить'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
