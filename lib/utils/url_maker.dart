///Create car url from data
String makeUrl(Map<String, dynamic> data) {
  String url = 'https://auto.ru/cars/';
  final String mark = data['mark']
      .toString()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  final String model = data['model']
      .toString()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  if (mark != 'null') {
    url += mark + '/';
    if (model != 'null') {
      url += model + '/';
    }
  }
  url += 'all/';
  final String body = data['body'].toString();
  final String transmission = data['transmission'].toString();
  final String yearFrom = data['year_from'].toString();
  final String yearTo = data['year_to'].toString();
  final String engineGroup = data['engine_group'].toString();
  final String gearType = data['gear_type'].toString();
  final String kmAgeFrom = data['km_age_from'].toString();
  final String kmAgeTo = data['km_age_to'].toString();
  final String displacementFrom = data['displacement_from'].toString();
  final String displacementTo = data['displacement_to'].toString();
  final String priceFrom = data['price_from'].toString();
  final String priceTo = data['price_to'].toString();
  if (url[url.length - 1] == '/') {
    url += '?';
  }
  if (body != 'null') {
    url = url + 'body_type_group=' + body + '&';
  }
  if (transmission != 'null') {
    url = url + 'transmission=' + transmission + '&';
  }
  if (yearFrom != 'null') {
    url = url + 'year_from=' + yearFrom + '&';
  }
  if (yearTo != 'null') {
    url = url + 'year_to=' + yearTo + '&';
  }
  if (engineGroup != 'null') {
    url = url + 'engine_group=' + engineGroup + '&';
  }
  if (gearType != 'null') {
    url = url + 'gear_type=' + gearType + '&';
  }
  if (kmAgeFrom != 'null') {
    url = url + 'km_age_from=' + kmAgeFrom + '&';
  }
  if (kmAgeTo != 'null') {
    url = url + 'km_age_to=' + kmAgeTo + '&';
  }
  if (displacementFrom != 'null') {
    url = url + 'displacement_from=' + displacementFrom + '&';
  }
  if (displacementTo != 'null') {
    url = url + 'displacement_to=' + displacementTo + '&';
  }
  if (priceFrom != 'null') {
    url = url + 'price_from=' + priceFrom + '&';
  }
  if (priceTo != 'null') {
    url = url + 'price_to=' + priceTo + '&';
  }
  return url;
}
