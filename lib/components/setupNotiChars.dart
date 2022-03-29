import 'dart:convert';

import 'package:auto_app/utils/urlMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotiChars extends StatefulWidget {
  _NotiChars createState() => _NotiChars();
}

//Характеристики по которым отправляются уведомления. Код по большей части идентичен с кодом поиска, если только пару моментов.
class _NotiChars extends State<NotiChars> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Поиск"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Container(
                      child: FormBuilderTextField(
                        name: 'mark',
                        decoration: InputDecoration(
                          labelText: 'Марка автомобиля',
                        ),
                        // valueTransformer: (text) => num.tryParse(text),
                        //validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(context),
                        //FormBuilderValidators.max(context, 70),
                        //]),
                      ),
                    ),
                    Container(
                      child: FormBuilderTextField(
                        name: 'model',
                        decoration: InputDecoration(
                          labelText: 'Модель автомобиля',
                        ),
                        // valueTransformer: (text) => num.tryParse(text),
                        //validator: FormBuilderValidators.compose([
                        //FormBuilderValidators.required(context),
                        //FormBuilderValidators.max(context, 70),
                        //]),
                      ),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                          // autovalidate: true,
                          name: 'body',
                          decoration: InputDecoration(
                            labelText: 'Кузов',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: Text('Выберите кузов'),
                          /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
                          items: [
                            DropdownMenuItem(
                              value: "SEDAN",
                              child: Text('Седан'),
                            ),
                            DropdownMenuItem(
                              value: "HATCHBACK",
                              child: Text('Хэтчбек'),
                            ),
                            DropdownMenuItem(
                              value: "HATCHBACK_3_DOORS",
                              child: Text('Хэтчбек 3 дв.'),
                            ),
                            DropdownMenuItem(
                              value: "HATCHBACK_5_DOORS",
                              child: Text('Хэтчбек 5 дв.'),
                            ),
                            DropdownMenuItem(
                              value: "LIFTBACK",
                              child: Text('Лифтбек'),
                            ),
                            DropdownMenuItem(
                              value: "ALLROAD",
                              child: Text('Внедорожник'),
                            ),
                            DropdownMenuItem(
                              value: "ALLROAD_3_DOORS",
                              child: Text('Внедорожник 3 дв.'),
                            ),
                            DropdownMenuItem(
                              value: "ALLROAD_5_DOORS",
                              child: Text('Внедорожник 5 дв.'),
                            ),
                            DropdownMenuItem(
                              value: "WAGON",
                              child: Text('Универсал'),
                            ),
                            DropdownMenuItem(
                              value: "COUPE",
                              child: Text('Купе'),
                            ),
                            DropdownMenuItem(
                              value: "MINIVAN",
                              child: Text('Минивэн'),
                            ),
                            DropdownMenuItem(
                              value: "PICKUP",
                              child: Text('Пикап'),
                            ),
                            DropdownMenuItem(
                              value: "LIMOUSINE",
                              child: Text('Лимузин'),
                            ),
                            DropdownMenuItem(
                              value: "VAN",
                              child: Text('Фургон'),
                            ),
                            DropdownMenuItem(
                              value: "CABRIO",
                              child: Text('Кабриолет'),
                            ),
                          ],
                          onChanged: (val) {
                            print(val);
                          }),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                          // autovalidate: true,
                          name: 'transmission',
                          decoration: InputDecoration(
                            labelText: 'Коробка передач',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: Text('Выберите вид коробки'),
                          /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
                          items: [
                            DropdownMenuItem(
                              value: "AUTO",
                              child: Text('Автомат'),
                            ),
                            DropdownMenuItem(
                              value: "AUTOMATIC",
                              child: Text('Автоматическая'),
                            ),
                            DropdownMenuItem(
                              value: "ROBOT",
                              child: Text('Робот'),
                            ),
                            DropdownMenuItem(
                              value: "VARIATOR",
                              child: Text('Вариатор'),
                            ),
                            DropdownMenuItem(
                              value: "MECHANICAL",
                              child: Text('Механическая'),
                            ),
                          ],
                          onChanged: (val) {
                            print(val);
                          }),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'year_from',
                              decoration: InputDecoration(
                                labelText: 'Год от',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context)//FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'year_to',
                              decoration: InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                          // autovalidate: true,
                          name: 'engine_group',
                          decoration: InputDecoration(
                            labelText: 'Двигатель',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: Text('Выберите вид двигателя'),
                          /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
                          items: [
                            DropdownMenuItem(
                              value: "GASOLINE",
                              child: Text('Бензин'),
                            ),
                            DropdownMenuItem(
                              value: "DIESEL",
                              child: Text('Дизель'),
                            ),
                            DropdownMenuItem(
                              value: "HYBRID",
                              child: Text('Гибрид'),
                            ),
                            DropdownMenuItem(
                              value: "ELECTRO",
                              child: Text('Электро'),
                            ),
                            DropdownMenuItem(
                              value: "TURBO",
                              child: Text('Турбированный'),
                            ),
                            DropdownMenuItem(
                              value: "ATMO",
                              child: Text('Атмосферный'),
                            ),
                            DropdownMenuItem(
                              value: "LPG",
                              child: Text('Газобалонное оборудование'),
                            ),
                          ],
                          onChanged: (val) {
                            print(val);
                          }),
                    ),
                    Container(
                      child: FormBuilderDropdown<String?>(
                          // autovalidate: true,
                          name: 'gear_type',
                          decoration: InputDecoration(
                            labelText: 'Привод',
                          ),
                          // initialValue: 'Male',
                          allowClear: true,
                          hint: Text('Выберите вид привода'),
                          /*validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),*/
                          items: [
                            DropdownMenuItem(
                              value: "FORWARD_CONTROL",
                              child: Text('Передний'),
                            ),
                            DropdownMenuItem(
                              value: "REAR_DRIVE",
                              child: Text('Задний'),
                            ),
                            DropdownMenuItem(
                              value: "ALL_WHEEL_DRIVE",
                              child: Text('Полный'),
                            ),
                          ],
                          onChanged: (val) {
                            print(val);
                          }),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'km_age_from',
                              decoration: InputDecoration(
                                labelText: 'Пробег от',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'km_age_to',
                              decoration: InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'displacement_from',
                              decoration: InputDecoration(
                                labelText: 'Объем от',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'displacement_to',
                              decoration: InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'price_from',
                              decoration: InputDecoration(
                                labelText: 'Цена от',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                          Expanded(
                            flex: 50,
                            child: FormBuilderTextField(
                              name: 'price_to',
                              decoration: InputDecoration(
                                labelText: 'до',
                              ),
                              // valueTransformer: (text) => num.tryParse(text),
                              //validator: FormBuilderValidators.compose([
                              //FormBuilderValidators.required(context),
                              //FormBuilderValidators.max(context, 70),
                              //]),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    //при нажатии создает новую ссылку по заданным параметрам
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Сохранить",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        _formKey.currentState?.save();
                        if (_formKey.currentState?.validate() == true) {
                          print(_formKey.currentState?.value);
                          //создает
                          String url = makeUrl(_formKey.currentState?.value
                              as Map<String, dynamic>);
                          print(url);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          //сохраняет в SharedPreferences
                          prefs.setString("noturl", url);
                          //выполняет запрос на сервер для получения числа автомобилей
                          var res = await http.post(
                            Uri.parse(
                                'https://autoparseru.herokuapp.com/getNotUpdate'),
                            body: json.encode({"url": url}),
                            headers: headers,
                          );
                          //сохраняет число автомобилей в SharedPreferences
                          prefs.setString("carups", res.body);
                        } else {
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Сбросить",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

//Заголовки, есть в каждом файле с запросами
Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json; charset=UTF-8',
};
