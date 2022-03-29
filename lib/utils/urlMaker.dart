//эта функция из словаря создает ссылку на автомобили по заданным параметрам
String makeUrl(Map<String, dynamic> data) {
  String url = "https://auto.ru/cars/";
  String mark = data["mark"]
      .toString()
      .toLowerCase()
      .replaceAll("-", "_")
      .replaceAll(" ", "_");
  String model = data["model"]
      .toString()
      .toLowerCase()
      .replaceAll("-", "_")
      .replaceAll(" ", "_");

  if (mark != "null") {
    url += mark + "/";
    if (model != "null") {
      url += model + "/";
    }
  }
  url += "all/";
  String body = data["body"].toString();
  String transmission = data["transmission"].toString();
  String year_from = data["year_from"].toString();
  String year_to = data["year_to"].toString();
  String engine_group = data["engine_group"].toString();
  String gear_type = data["gear_type"].toString();
  String km_age_from = data["km_age_from"].toString();
  String km_age_to = data["km_age_to"].toString();
  String displacement_from = data["displacement_from"].toString();
  String displacement_to = data["displacement_to"].toString();
  String price_from = data["price_from"].toString();
  String price_to = data["price_to"].toString();
  if (url[url.length - 1] == "/") {
    url += "?";
  }
  if (body != "null") {
    url = url + 'body_type_group=' + body + '&';
  }
  if (transmission != "null") {
    url = url + 'transmission=' + transmission + '&';
  }
  if (year_from != "null") {
    url = url + 'year_from=' + year_from + '&';
  }
  if (year_to != "null") {
    url = url + 'year_to=' + year_to + '&';
  }
  if (engine_group != "null") {
    url = url + 'engine_group=' + engine_group + '&';
  }
  if (gear_type != "null") {
    url = url + 'gear_type=' + gear_type + '&';
  }
  if (km_age_from != "null") {
    url = url + 'km_age_from=' + km_age_from + '&';
  }
  if (km_age_to != "null") {
    url = url + 'km_age_to=' + km_age_to + '&';
  }
  if (displacement_from != "null") {
    url = url + 'displacement_from=' + displacement_from + '&';
  }
  if (displacement_to != "null") {
    url = url + 'displacement_to=' + displacement_to + '&';
  }
  if (price_from != "null") {
    url = url + 'price_from=' + price_from + '&';
  }
  if (price_to != "null") {
    url = url + 'price_to=' + price_to + '&';
  }
  return url;
}
