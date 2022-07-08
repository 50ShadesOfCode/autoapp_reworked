import 'package:flutter/material.dart';

@immutable
abstract class SplashEvent {}

class InitEvent extends SplashEvent {}

class AppStarted extends SplashEvent {}
