class Car {
  final String url;
  final bool used;
  final List<String> images;
  final Map<String, dynamic> characteristics;
  final bool isFavourite;

  Car({
    required this.isFavourite,
    required this.characteristics,
    required this.images,
    required this.url,
    required this.used,
  });
}
