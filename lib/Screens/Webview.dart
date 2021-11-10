import 'dart:io';

import 'package:covid/http/NewsData.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final News data;
  WebViewScreen(this.data);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.data.url}',
          style: Theme.of(context).textTheme.headline3,
        ),
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
            iconSize: 20,
          )
        ],
      ),
      body: WebView(
        initialUrl: widget.data.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
