import 'dart:convert';

//Класс FavModel создан для того, чтобы удобно заносить в локальную базу данных sqlite записи о избранных автомобилях

//две функции, которые переделывают объект класса в json и обратно для хранения в БД
FavModel favmodelFromJson(String str) {
  final data = json.decode(str);
  return FavModel.fromMap(data);
}

String favmodelToJson(FavModel data) {
  final jsData = data.toMap();
  return json.encode(jsData);
}

class FavModel {
  //ссылка на автомобиль
  String url;

  FavModel({
    required this.url,
  });

  factory FavModel.fromMap(Map<String, dynamic> json) => new FavModel(
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}
