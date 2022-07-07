import 'dart:async';

import 'package:auto_app/features/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Виджет, отвечающий за приветствие в приложении, то что мы видим в начале
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

///получает имя пользователя из SharedPreferences
Future<String?> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

///реализация состояния класса экрана приветствия
class _SplashScreenState extends State<SplashScreen> {
  ///время экрана приветствия
  final int splashDelay = 3;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  ///по прошествии экрана приветствия, переходит на другую страницу
  Future<Timer> _loadWidget() async {
    final Duration _duration = Duration(seconds: splashDelay);
    return Timer(
      _duration,
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => HomePage())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getUsername(),
        builder: (BuildContext context, AsyncSnapshot<String?> snap) {
          return Scaffold(
            body: InkWell(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/app_icon.png',
                              height: 300,
                              width: 300,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                          ],
                        )),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                if (snap.hasData)
                                  Text('Привет, ' + snap.data.toString() + '!')
                                else
                                  const Text('Привет!'),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
