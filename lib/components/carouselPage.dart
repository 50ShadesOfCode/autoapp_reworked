import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'carousel.dart';

class CarouselPage extends StatefulWidget {
  final List<String> imageUrls;
  CarouselPage({required List<String> imageUrls}) : this.imageUrls = imageUrls;
  @override
  _CarouselPageState createState() => _CarouselPageState(imageUrls);
}

class _CarouselPageState extends State<CarouselPage> {
  int _current = 0;
  final List<String> imageUrls;
  _CarouselPageState(this.imageUrls);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Галерея'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              items: imageSliders(this.imageUrls),
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.5,
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
          ],
        ),
      ),
    );
  }
}
