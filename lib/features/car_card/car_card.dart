import 'package:auto_app/features/car_screen/bloc/car_bloc.dart';
import 'package:auto_app/features/car_screen/car_page.dart';
import 'package:auto_app/features/common/card.dart' as card;
import 'package:auto_app/features/common/carousel_page.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/card_bloc.dart';

class CarCard extends StatefulWidget {
  final Car car;
  const CarCard({required this.car});
  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  late Car car;
  @override
  void initState() {
    super.initState();
    car = widget.car;
  }

  @override
  Widget build(BuildContext context) {
    print(car.images[0]);
    return card.Card(
      InkWell(
        onTap: () => <void>{
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => BlocProvider<CarBloc>(
                create: (BuildContext context) =>
                    CarBloc(apiProvider: appLocator.get<ApiProvider>()),
                child: CarPage(car: car),
              ),
            ),
          )
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 25,
              child: InkWell(
                onTap: () => <void>{
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          CarouselPage(imageUrls: car.images),
                    ),
                  )
                },
                child: Container(
                  child: Image(
                    image: NetworkImage(car.images[0].toString()),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(car.characteristics['name'].toString()),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  ),
                  Container(
                    child: Text(car.used
                        ? car.characteristics['kmage'].toString()
                        : car.characteristics['complectation'].toString()),
                    margin: const EdgeInsets.only(top: 3, bottom: 3, left: 2),
                  ),
                  Container(
                    child: Text(car.characteristics['engine'].toString()),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Text(car.characteristics['price'].toString()),
                      margin: const EdgeInsets.symmetric(vertical: 3)),
                  Container(
                    child: Text(car.characteristics['color'].toString()),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  ),
                  Container(
                    child: Text(car.characteristics['drive'].toString()),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: StarButton(
                isStarred: car.isFavourite,
                iconSize: 45,
                valueChanged: (bool value) async {
                  if (value) {
                    BlocProvider.of<CardBloc>(context)
                        .add(AddToFavouriteEvent());
                  } else {
                    BlocProvider.of<CardBloc>(context)
                        .add(RemoveFromFavouriteEvent());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
