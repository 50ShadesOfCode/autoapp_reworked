import 'package:auto_app/features/common/parameters_page.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return ParametersPage(
      child: Row(
        children: <Widget>[
          Expanded(
            //при нажатии создает новую ссылку по заданным параметрам
            child: MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                _formKey.currentState?.save();
                if (_formKey.currentState?.validate() == true) {
                  print(_formKey.currentState?.value);
                  //создает
                  final String url = makeUrl(
                      _formKey.currentState?.value as Map<String, dynamic>);
                  print(url);
                } else {
                  print('validation failed');
                }
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              child: const Text(
                'Сбросить',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _formKey.currentState?.reset();
              },
            ),
          ),
        ],
      ),
      title: 'Параметры уведомлений',
      formKey: _formKey,
    );
  }
}
