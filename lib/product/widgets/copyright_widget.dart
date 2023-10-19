import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CopyrightWidget extends StatelessWidget {
  const CopyrightWidget({
    Key? key,
  }) : super(key: key);

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchUrl(
          Uri.parse('https://mtsoft.com.tr'),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Copyright © MTSoft Yazılım ve Danışmanlık Hizmetleri',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
