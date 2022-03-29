import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'carouselPage.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<String> imageUrls;
  CarouselWithIndicator({required List<String> imageUrls})
      : this.imageUrls = imageUrls;
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState(imageUrls);
  }
}

//создает карусель для показа изображений автомобиля по списку картинкок, которые получают с интернета. Более подробно в документации carousel slider.
class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final List<String> imageUrls;
  _CarouselWithIndicatorState(this.imageUrls);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Column(children: [
          CarouselSlider(
            items: imageSliders(this.imageUrls),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.25,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: this.imageUrls.map((url) {
              int index = this.imageUrls.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarouselPage(imageUrls: this.imageUrls),
          ),
        );
      },
    );
  }
}

//создает список с картинками для показа в карусели
List<Widget> imageSliders(List<String> iList) {
  return iList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
