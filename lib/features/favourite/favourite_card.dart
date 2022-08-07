import 'dart:io';

import 'package:auto_app/features/car_screen/car_page.dart';
import 'package:auto_app/features/common/card.dart' as card;
import 'package:auto_app/features/common/carousel_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//TODO: Use only one card
class FavouriteCard extends StatefulWidget {
  final String cardUrl;
  const FavouriteCard({required this.cardUrl});
  @override
  _CarCardState createState() => _CarCardState();
}

class _CarCardState extends State<FavouriteCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final String cardUrl;

  @override
  void initState() {
    super.initState();
    cardUrl = widget.cardUrl;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Map<String, dynamic>>(
      future: getCardParameters(cardUrl),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const card.Card(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data == null) {
          return const card.Card(
            Center(
              child: Text('Check your Internet connection!!'),
            ),
          );
        }
        final Map<String, dynamic> characteristics =
            snapshot.data as Map<String, dynamic>;
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
                      builder: (BuildContext context) =>
                          CarPage(carUrl: cardUrl)))
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
                        child: Text(!cardUrl.contains('/new/')
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
                  child: IconButton(
                    iconSize: 35,
                    icon: const Icon(
                      CupertinoIcons.clear,
                    ),
                    onPressed: () async {
                      final Directory docsPath =
                          await getApplicationDocumentsDirectory();
                      final Database db = await openDatabase(
                        docsPath.path + 'autofavs.db',
                        version: 1,
                        onCreate: (Database db, int version) async {
                          await db.execute('CREATE TABLE Favs ('
                              'url TEXT'
                              ')');
                        },
                      );
                      db.delete(
                        'Favs',
                        where: 'url = ?',
                        whereArgs: <String>[cardUrl],
                      );
                      print('del');
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
