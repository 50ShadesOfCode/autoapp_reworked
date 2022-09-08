import 'package:auto_app/features/car_card/bloc/card_bloc.dart';
import 'package:auto_app/features/car_card/car_card.dart';
import 'package:auto_app/features/favourite/bloc/favourite_bloc.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: const Icon(
                CupertinoIcons.arrow_counterclockwise,
                size: 26.0,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<FavouriteBloc, FavouriteState>(
        builder: (BuildContext context, FavouriteState state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.data.isEmpty && !state.isLoading) {
            return const Center(
              child: Text('Пока еще ничего нет!'),
            );
          }
          return Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BlocProvider<CardBloc>(
                          create: (BuildContext context) => CardBloc(
                            apiProvider: appLocator.get<ApiProvider>(),
                          ),
                          //child: CarCard(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
