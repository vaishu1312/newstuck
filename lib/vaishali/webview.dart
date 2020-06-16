import 'dart:async';
import 'package:flutter/material.dart';
import 'package:newstuck/vaishali/appBar.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_web_view/easy_web_view.dart';

class MyWebView extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final String selectedUrl;

  MyWebView(
    this.selectedUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: EasyWebView(
        src: selectedUrl,
        isHtml: false, // Use Html syntax
        isMarkdown: false, // Use markdown syntax
        convertToWidgets: false, // Try to convert to flutter widgets
        onLoaded: (){},
        // width: 100,
        // height: 100,
      ), /*WebView(
          initialUrl: selectedUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        )*/
    );
  }
}
