import 'package:auto_app/features/car_screen/bloc/car_bloc.dart';
import 'package:auto_app/features/car_screen/car_page.dart';
import 'package:auto_app/features/common/card.dart' as card;
import 'package:auto_app/features/common/carousel_page.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/card_bloc.dart';

class CarCard extends StatefulWidget {
  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CardBloc, CardState>(
      builder: (BuildContext context, CardState state) {
        if (state.isLoading) {
          return const card.Card(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final Map<String, dynamic> characteristics = state.data;
          final List<String> urls = <String>[];
          for (int i = 0;
              i < (characteristics['images_urls'].length as int);
              i++) {
            urls.add('http://' + characteristics['images_urls'][i].toString());
          }
          return card.Card(
            InkWell(
              onTap: () => <void>{
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => BlocProvider<CarBloc>(
                      create: (BuildContext context) =>
                          CarBloc(apiProvider: appLocator.get<ApiProvider>()),
                      child: CarPage(carUrl: state.url),
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
                                CarouselPage(imageUrls: urls),
                          ),
                        )
                      },
                      child: Container(
                        child: Image(
                          image: NetworkImage('http://' +
                              characteristics['images_urls'][0].toString()),
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
                          child: Text(characteristics['name'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(!state.url.contains('/new/')
                              ? characteristics['kmage'].toString()
                              : characteristics['complectation'].toString()),
                          margin:
                              const EdgeInsets.only(top: 3, bottom: 3, left: 2),
                        ),
                        Container(
                          child: Text(characteristics['engine'].toString()),
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
                            child: Text(characteristics['price'].toString()),
                            margin: const EdgeInsets.symmetric(vertical: 3)),
                        Container(
                          child: Text(characteristics['color'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                        Container(
                          child: Text(characteristics['drive'].toString()),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: StarButton(
                      isStarred: state.isFavourite,
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
      },
    );
  }
}
