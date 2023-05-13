import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/default_app_bar.dart';

class Confidentials extends StatefulWidget {
  const Confidentials({Key? key}) : super(key: key);

  @override
  State<Confidentials> createState() => _ConfidentialsState();
}

class _ConfidentialsState extends State<Confidentials> {

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://api.procouture.shop/confidential')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )..loadRequest(Uri.parse('https://api.procouture.shop/confidential'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myDefaultAppBar('Règles et confidentialités', context),
      body: WebViewWidget(controller: controller),
    );
  }
}
