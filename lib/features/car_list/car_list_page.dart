import 'package:auto_app/features/car_card/bloc/card_bloc.dart';
import 'package:auto_app/features/car_card/car_card.dart';
import 'package:auto_app/features/car_list/bloc/car_list_bloc.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: Пизда нихуя не работает

class CarListPage extends StatefulWidget {
  final String url;
  const CarListPage({required this.url});
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  late final String url;

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты'),
      ),
      body: BlocBuilder<CarListBloc, CarListState>(
        builder: (BuildContext context, CarListState state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
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
                      //addAutomaticKeepAlives: true,
                      itemCount: state.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CarCard(car: state.cars[index]);
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
