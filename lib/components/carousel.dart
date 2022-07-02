import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'carousel_page.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<String> imageUrls;
  const CarouselWithIndicator({required this.imageUrls});
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

//создает карусель для показа изображений автомобиля по списку картинкок, которые получают с интернета. Более подробно в документации carousel slider.
class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  late final List<String> imageUrls;

  @override
  void initState() {
    imageUrls = widget.imageUrls;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CarouselSlider(
              items: imageSliders(imageUrls),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.25,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrls.map((String url) {
                final int index = imageUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                        : const Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                CarouselPage(imageUrls: imageUrls),
          ),
        );
      },
    );
  }
}

//создает список с картинками для показа в карусели
List<Widget> imageSliders(List<String> iList) {
  return iList
      .map((String item) => Container(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      PhotoView(
                        imageProvider: NetworkImage(item),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();
}
