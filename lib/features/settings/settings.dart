import 'package:auto_app/features/settings/setup_notifications.dart';
import 'package:auto_app/utils/notifications.dart';
import 'package:core_ui/src/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //выбранная частота уведомлений
  int selectedRate = 0;
  //контроллеры для полей с текстом
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textControllerMail = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    _textControllerMail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //форма для введения имени пользователя
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Expanded(
                      flex: 75,
                      child: TextField(
                        decoration:
                            const InputDecoration(hintText: 'Имя пользователя'),
                        controller: _textController,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 30,
                      child: ElevatedButton(
                          //при нажатии сохраняем имя пользователя в SharedPreferences если что-то введено
                          onPressed: () async {
                            if (_textController.text == '') {
                              return;
                            }
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('username', _textController.text);
                            print(_textController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Имя пользователя сохранено')));
                          },
                          child: const Text('Сохранить')))
                ],
              ),
            ),
            //перевключение темы
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Темная тема'),
                    ChangeThemeButtonWidget(),
                  ],
                ),
              ),
            ),
            //выпадающий список с частотами уведомлений
            Container(
              child: Column(children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: DropdownButton<int>(
                      hint: const Text('Выберите частоту уведомлений'),
                      value: selectedRate,
                      //при выборе какого либо элемента сохраняет частоту в SharedPreferences и запускает уведомления с выбранной частотой
                      onChanged: (int? value) async {
                        setState(() {
                          selectedRate = value as int;
                        });
                        print(value);
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt('rate', value as int);
                        cancelAllNotifications();
                        if (value == 1) {
                          schedule45MinNotification();
                        }
                        if (value == 2) {
                          repeatNotificationHourly();
                        }
                        if (value == 3) {
                          scheduleDailyFourAMNotification();
                        }
                      },
                      //список частот уведомлений
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
                      ]),
                ),
                //кнопка для перехода на страницу с параметрами уведомлений
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: TextButton(
                    onPressed: () => <void>{
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => NotiChars(),
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
                        controller: _textControllerMail,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_textControllerMail.text == '') {
                          return;
                        }
                        final Email email = Email(
                            body: _textControllerMail.text,
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
    );
  }
}

//виджет с переключателем для темы
class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
      //начальное значение
      value: themeProvider.isDarkMode,
      //если белая, включаем темную, и наоборот
      onChanged: (bool value) {
        final ThemeProvider provider =
            Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}

//список со значениями частот. 0 - вообще нет, 1 - 45 минут, 2 - 1 час, 3 - ежедневно
List<int> values = <int>[0, 1, 2, 3];
