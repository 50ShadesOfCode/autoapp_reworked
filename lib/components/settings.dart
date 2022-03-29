import 'package:auto_app/components/setupNotiChars.dart';
import 'package:auto_app/components/themeProvider.dart';
import 'package:auto_app/utils/notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class Settings extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //выбранная частота уведомлений
  int selectedRate = 0;
  //контроллеры для полей с текстом
  final _textController = TextEditingController();
  final _textControllerMail = TextEditingController();
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
        title: Text('Настройки'),
      ),
      body: Center(
        child: Column(
          children: [
            //форма для введения имени пользователя
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  Container(
                    child: Expanded(
                      flex: 75,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Введите имя пользователя'),
                        controller: _textController,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 30,
                      child: ElevatedButton(
                          //при нажатии сохраняем имя пользователя в SharedPreferences если что-то введено
                          onPressed: () async {
                            if (_textController.text == "") {
                              return;
                            }
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString("username", _textController.text);
                            print(_textController.text);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Имя пользователя сохранено")));
                          },
                          child: Text("Сохранить")))
                ],
              ),
            ),
            //перевключение темы
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Сменить тему"),
                    ChangeThemeButtonWidget(),
                  ],
                ),
              ),
            ),
            //выпадающий список с частотами уведомлений
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: DropdownButton<int>(
                  hint: Text("Выберите частоту уведомлений"),
                  value: selectedRate,
                  //при выборе какого либо элемента сохраняет частоту в SharedPreferences и запускает уведомления с выбранной частотой
                  onChanged: (int? value) async {
                    setState(() {
                      selectedRate = value as int;
                    });
                    print(value);
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setInt("rate", value as int);
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
                  items: [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Не показывать уведомления",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Показывать каждые 45 минут",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Показывать каждый час",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Показывать ежедневно",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
            //кнопка для перехода на страницу с параметрами уведомлений
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotiChars()),
                  )
                },
                child: Text("Изменить параметры уведомлений"),
              ),
            ),
            //поле для ввода сообщения обратной связи. при нажатии на отправить открывается почта уже с введенной темой текстом и тд
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                children: [
                  Container(
                    child: Expanded(
                      flex: 75,
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Обратная связь'),
                        controller: _textControllerMail,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 30,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_textControllerMail.text == "") {
                              return;
                            }
                            final Email email = Email(
                                body: _textControllerMail.text,
                                subject: "Обратная связь в приложении",
                                recipients: ['kostya9907@mail.ru'],
                                isHTML: false);
                            await FlutterEmailSender.send(email);
                          },
                          child: Text("Отправить")))
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Switch.adaptive(
      //начальное значение
      value: themeProvider.isDarkMode,
      //если белая, включаем темную, и наоборот
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}

//список со значениями частот. 0 - вообще нет, 1 - 45 минут, 2 - 1 час, 3 - ежедневно
List<int> values = [0, 1, 2, 3];
