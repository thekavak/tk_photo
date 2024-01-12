// Import Riverpod package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tk_photo/product/constant/app_color.dart';

import '../../service/shared_preferences.dart';

class ChangeRatio extends ConsumerStatefulWidget {
  const ChangeRatio({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangeRatioState();
}

class _ChangeRatioState extends ConsumerState<ChangeRatio> {
  double aspectRatio = 1 / 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      aspectRatio =
          await MySharedPreferences.instance.getAspectRatio() ?? 1 / 1;
      setState(() {});
    });
  }

  Widget buildAspectRatioBox(double ratio, String displayText) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          aspectRatio = ratio;
        });
        await MySharedPreferences.instance.setSAspectRatio(ratio);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: ratio,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.mtPrimary),
              color: aspectRatio == ratio
                  ? ColorConstants.mtPrimary.withOpacity(0.5)
                  : Colors.white,
            ),
            child: Center(child: Text(displayText)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Resim Oranı ',
        style: TextStyle(color: Colors.white),
      )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                buildAspectRatioBox(1 / 1, '1:1'),
                buildAspectRatioBox(2 / 3, '2:3'),
                buildAspectRatioBox(9 / 16, '9:16'),
                buildAspectRatioBox(3 / 4, '3:4'),
              ],
            ),
            // Add more widgets here if needed
          ],
        ),
      ),
    );
  }
}
