import 'package:auto_app/features/characteristics/bloc/characteristics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharsPage extends StatefulWidget {
  @override
  _CharsPageState createState() => _CharsPageState();
}

class _CharsPageState extends State<CharsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Характеристики'),
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<CharacteristicsBloc, CharacteristicsState>(
        builder: (BuildContext context, CharacteristicsState state) {
          if (state.isLoading) {
            return Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scrollbar(
            child: ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (BuildContext context, int index) {
                final String key =
                    (state.data.keys.elementAt(index)).toString();
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(key),
                        flex: 50,
                      ),
                      Expanded(
                        flex: 50,
                        child: Text((state.data[key]).toString()),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
