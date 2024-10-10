import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/home/home_provider.dart';

class ShowAttributesModal extends ConsumerStatefulWidget {
  const ShowAttributesModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowAttributesModalState();
}

class _ShowAttributesModalState extends ConsumerState<ShowAttributesModal> {
  @override
  Widget build(BuildContext context) {
    final attributesList = ref.read(homeProvider.notifier).attributesList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Özellikler'),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    top: 36.0, left: 16, right: 16, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: attributesList!
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.attributeTypeDescription.toString()),
                                const SizedBox(height: 10),
                                DropdownButtonFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      e.options?.forEach((element) {
                                        if (element.code == value) {
                                          element.isSelected = true;
                                          //print(element.name);
                                        } else {
                                          element.isSelected = false;
                                        }
                                      });
                                    });
                                  },
                                  items: e.options
                                          ?.map((ee) => DropdownMenuItem(
                                                value: ee.code,
                                                child: Text(ee.name
                                                    .toString()
                                                    .toUpperCase()),
                                              ))
                                          .toList() ??
                                      [],
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )),
          ],
        )),
      ),
    );
  }
}
