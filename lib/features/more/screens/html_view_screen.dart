import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mazzraati_vendor_app/utill/dimensions.dart';

class HtmlViewScreen extends StatelessWidget {
  final String? title;
  final String? url;
  const HtmlViewScreen({super.key, required this.url, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Html(
                  data: url,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
