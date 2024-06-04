import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplayPage extends StatelessWidget {
  final String url;

  const QRDisplayPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Qr ko'd"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: url,
              version: QrVersions.auto,
              size: 300.0,
            ),
          ],
        ),
      ),
    );
  }
}
