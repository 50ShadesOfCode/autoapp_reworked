import 'package:auto_app/components/carListPage.dart';
import 'package:auto_app/utils/urlMaker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Search extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

//форма поиска сделана при помощи библиотеки flutter_form_builder
class _SearchState extends State<Search> {
  //ключ для обращения к форме
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
                    ),
                  ),
                  Container(
                    child: FormBuilderTextField(
                      name: 'model',
                      decoration: InputDecoration(
                        labelText: 'Модель автомобиля',
                      ),
                    ),
                  ),
                  Container(
                    child: FormBuilderDropdown<String?>(
                        name: 'body',
                        decoration: InputDecoration(
                          labelText: 'Кузов',
                        ),
                        allowClear: true,
                        hint: Text('Выберите кузов'),
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
                        allowClear: true,
                        hint: Text('Выберите вид коробки'),
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
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'year_to',
                            decoration: InputDecoration(
                              labelText: 'до',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: FormBuilderDropdown<String?>(
                        name: 'engine_group',
                        decoration: InputDecoration(
                          labelText: 'Двигатель',
                        ),
                        // initialValue: 'Male',
                        allowClear: true,
                        hint: Text('Выберите вид двигателя'),
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
                        name: 'gear_type',
                        decoration: InputDecoration(
                          labelText: 'Привод',
                        ),
                        allowClear: true,
                        hint: Text('Выберите вид привода'),
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
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'km_age_to',
                            decoration: InputDecoration(
                              labelText: 'до',
                            ),
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
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'displacement_to',
                            decoration: InputDecoration(
                              labelText: 'до',
                            ),
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
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: FormBuilderTextField(
                            name: 'price_to',
                            decoration: InputDecoration(
                              labelText: 'до',
                            ),
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
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Найти!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      //сохраняем и получаем данные о форме
                      _formKey.currentState?.save();
                      if (_formKey.currentState?.validate() == true) {
                        print(_formKey.currentState?.value);
                        //создаем ссылку на автомобили
                        String url = makeUrl(_formKey.currentState?.value
                            as Map<String, dynamic>);
                        print(url);
                        //переходим на страницу со списком автомобилей
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarListPage(url: url),
                            ));
                      } else {
                        print("validation failed");
                      }
                    },
                  ),
                ),
                SizedBox(width: 20),
                //кнопка сбросить сбрасывает данные формы
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
      ),
    );
  }
}
