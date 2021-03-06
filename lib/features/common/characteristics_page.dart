import 'dart:convert';

import 'package:auto_app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CharsPage extends StatefulWidget {
  final String url;
  const CharsPage({required this.url});
  @override
  _CharsPageState createState() => _CharsPageState();
}

class _CharsPageState extends State<CharsPage> {
  late final String url;

  @override
  void initState() {
    url = widget.url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Характеристики'),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getParams(url),
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Scrollbar(
              child: ListView.builder(
                itemCount: snap.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  final String key =
                      (snap.data?.keys.elementAt(index)).toString();
                  print(snap.data);
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
                          child: Text((snap.data?[key]).toString()),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

//ответ с сервера приходит в виде название:характеристика, поэтому нужен обычный словарь
Future<Map<String, dynamic>> _getParams(String url) async {
  final http.Response res = await http.post(
    Uri.parse('https://fpmiautoparser.herokuapp.com/getCharsByUrl'),
    body: json.encode(<String, dynamic>{'url': url}),
    headers: headers,
  );
  if (res.statusCode == 200) {
    final Map<String, dynamic> vals =
        json.decode(res.body) as Map<String, dynamic>;
    return vals;
  }
  return <String, dynamic>{};
}
