import 'package:flutter/material.dart';

class RouteConfiguration {
  final Page<dynamic> page;

  RouteConfiguration({
    required this.page,
  });

  @override
  String toString() {
    return 'RouteConfiguration for ${page.name}';
  }
}
