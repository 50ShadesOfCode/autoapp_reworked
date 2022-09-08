import 'dart:async';

import 'package:auto_app/features/splashcreen/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int splashDelay = 2;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashBloc>(context).add(InitEvent());
    _loadWidget();
  }

  Future<Timer> _loadWidget() async {
    final Duration _duration = Duration(seconds: splashDelay);
    return Timer(
      _duration,
      () => BlocProvider.of<SplashBloc>(context).add(AppStarted()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (BuildContext context, SplashState state) => Scaffold(
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
                          'assets/images/car_logo_new.png',
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
                            if (state.username != '')
                              Text('Привет, ' + state.username + '!')
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
      ),
    );
  }
}
