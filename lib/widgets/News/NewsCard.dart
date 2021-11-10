import 'package:covid/Screens/Webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import '../../http/NewsData.dart';

class NewsCard extends StatelessWidget {
  final News data;
  NewsCard(this.data);

  @override
  Widget build(BuildContext context) {
    return data.imageUrl != null
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => WebViewScreen(data),
                ),
              );
            },
            child: Card(
              elevation: 3,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                      image: DecorationImage(
                        image: NetworkImage(
                          data.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * .09,
                    width: 80,
                  ),
                  Expanded(
                    child: ListTile(
                      minVerticalPadding: 10,
                      title: SizedBox(
                        child: Text(
                          data.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        width: MediaQuery.of(context).size.width * .5,
                      ),
                      subtitle: SizedBox(
                        child: Text(
                          'Source: ${data.source}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.grey[600]),
                        ),
                        width: MediaQuery.of(context).size.width * .5,
                      ),
                      trailing: Icon(
                        Icons.share,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
