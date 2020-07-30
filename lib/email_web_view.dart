import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwebview/constant.dart';

class EmailWebView extends StatefulWidget {
  @override
  _EmailWebViewState createState() => _EmailWebViewState();
}

class _EmailWebViewState extends State<EmailWebView> {

  InAppWebViewController _webViewController;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Expanded(
          child: _configureInAppWebView(email),
        ),
      ),
    );
  }

  // Configure the WebView for email body section.
  Widget _configureInAppWebView(String body) {
    return InAppWebView(
      initialUrl: 'about:blank',
      initialData: InAppWebViewInitialData(
        data: body,
      ),
      initialHeaders: {},
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          preferredContentMode: UserPreferredContentMode.MOBILE,
          debuggingEnabled: true,
          transparentBackground: true,
          clearCache: true,
          verticalScrollBarEnabled: true,
          horizontalScrollBarEnabled: true,
          useShouldOverrideUrlLoading: true,
          disableContextMenu: true,
        ),
        ios: IOSInAppWebViewOptions(
          enableViewportScale: true,
        ),
        android: AndroidInAppWebViewOptions(
          useWideViewPort: false,
        ),
      ),
      onWebViewCreated: (InAppWebViewController controller) async {
        _webViewController = controller;
        print('onWebViewCreated');
      },
      onLoadStart: (InAppWebViewController controller, String url) async {
        await controller.clearCache();
        await controller.clearFocus();
        await controller.clearMatches();
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        await controller.clearCache();
        await controller.clearFocus();
        await controller.clearMatches();

        // Adding additional css to WebView for the Dark/Light Mode.
        await controller.injectCSSCode(
            source: _cssStyleForDarkMode());

      },

    );
  }

  String _cssStyleForDarkMode() {
    var width = MediaQuery.of(context).size.width - 30;

    return '''<style type="text/css">
:root {
    color-scheme: dark;
    supported-color-schemes: dark;
    overflow-wrap: break-word !important;
  }
  
   body {
    margin: 0; 
    padding: 0; 
    min-width: 100% !important;
   }
   
   table {
    width: 100% !important; 
  max-width: ${width}px !important;
   }
</style>''';
  }
}
