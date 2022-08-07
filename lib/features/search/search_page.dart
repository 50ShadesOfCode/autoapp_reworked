import 'package:auto_app/features/car_list/bloc/car_list_bloc.dart';
import 'package:auto_app/features/car_list/car_list_page.dart';
import 'package:auto_app/features/common/parameters_page.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return ParametersPage(
      child: Row(
        children: <Widget>[
          //кнопка сбросить сбрасывает данные формы
          Expanded(
            child: ElevatedButton(
              child: const Text(
                'Сбросить',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _formKey.currentState?.reset();
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              child: const Text(
                'Найти!',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                //сохраняем и получаем данные о форме
                _formKey.currentState?.save();
                if (_formKey.currentState?.validate() == true) {
                  print(_formKey.currentState?.value);
                  //создаем ссылку на автомобили
                  final String url = makeUrl(
                      _formKey.currentState?.value as Map<String, dynamic>);
                  print(url);
                  //переходим на страницу со списком автомобилей
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          BlocProvider<CarListBloc>(
                        create: (BuildContext context) => CarListBloc(
                          apiProvider: appLocator.get<ApiProvider>(),
                        ),
                        child: CarListPage(url: url),
                      ),
                    ),
                  );
                } else {
                  print('validation failed');
                }
              },
            ),
          ),
        ],
      ),
      title: 'Поиск',
      formKey: _formKey,
    );
  }
}
