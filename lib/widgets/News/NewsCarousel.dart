import 'package:covid/Screens/Webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import '../../http/NewsData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsCarousel extends StatelessWidget {
  final List<News> newsData;
  NewsCarousel(this.newsData);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 900),
      ),
      items: newsData.map((data) {
        if (data.imageUrl == null) {
          return null;
        }

        return Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => WebViewScreen(data),
                ),
              );
            },
            child: Stack(children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      data.imageUrl,
                    ),
                    repeat: ImageRepeat.noRepeat,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.3, 0.7],
                      colors: [Colors.transparent, Colors.black54]),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: ListTile(
                    title: Text(
                      data.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data.publishedAt,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ]),
          );
        });
      }).toList(),
    );
  }
}
