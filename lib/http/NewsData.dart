import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

class News {
  final source;
  final author;
  final title;
  final description;
  final imageUrl;
  final content;
  final publishedAt;
  final url;

  News(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.imageUrl,
      this.content,
      this.publishedAt,
      this.url});
}

class NewsData with ChangeNotifier {
  List<News> _articleList = [];

  List<News> get articles {
    return [..._articleList];
  }

  Future<void> fetchNewsData() async {
    try {
      final url = Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=in&q=covid&apiKey=95315aea1bcb458ab1b779ffd81bcd7c');
      final response = await http.get(url);

      final result = json.jsonDecode(response.body) as Map<String, dynamic>;

      if (result['status'] == 'ok') {
        _articleList.clear();
        final articles = result['articles'] as List;
        articles.forEach((article) {
          final data = article as Map;

          _articleList.add(News(
              source: data['source']['name'],
              author: data['author'],
              title: data['title'],
              description: data['description'],
              content: data['content'],
              imageUrl: data['urlToImage'],
              publishedAt: data['publishedAt'],
              url: data['url']));
        });

        notifyListeners();
      } else {
        throw Exception('Server not requested!');
      }
    } catch (error) {
      print(error);
    }
  }
}
