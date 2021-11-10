import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import '../http/NewsData.dart';
import 'package:provider/provider.dart';
import '../widgets/News/NewsCarousel.dart';
import '../widgets/News/NewsCard.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with AutomaticKeepAliveClientMixin<NewsScreen> {
  Future<void> future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    future = Provider.of<NewsData>(context, listen: false).fetchNewsData();
    super.initState();
    print('called');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Updates'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = [];
          data = Provider.of<NewsData>(context).articles;
          List<News> imageData = [];

          int len = data.length > 3 ? 3 : data.length;
          for (int i = 0; i < len; i++) {
            if (data.elementAt(i).imageUrl != null) {
              imageData.add(data.elementAt(i));
            }
          }

          return Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Know what\'s happening in India',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Get latest update regarding covid-19 crises in India',
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 15),
                Text(
                  'Top Headlines',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                NewsCarousel(imageData),
                Text(
                  'Today\'s Update',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => NewsCard(
                            data.elementAt(index),
                          )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
