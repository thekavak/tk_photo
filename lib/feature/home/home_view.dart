import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:tk_photo/product/constant/app_menu_list.dart';
import 'package:tk_photo/service/shared_preferences.dart';

import '../../core/model/general_list_model.dart';
import '../main/main_provider.dart';
import '../settings/save_ratio.dart';
import 'home_provider.dart';

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(homeProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    //Menu listesi
    final menuList = AppMenuList().menuList;
    return Scaffold(
        appBar: AppBar(
          title: const Text('TK Photo',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            //settting
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return const ChangeRatio();
                    },
                    fullscreenDialog: true));
              },
              icon: const Icon(Icons.settings),
            ),
            IconButton(
              onPressed: () {
                MySharedPreferences.instance.removeUserLogout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: context.paddingNormal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildMenu(menuList),
                const Divider(),
                const SizedBox(height: 15),
                Text('Fiyat Listesi', style: context.textTheme.labelMedium),
                const SizedBox(height: 10),
                buildPriceDropbox(),
                const SizedBox(height: 15),
                Text('Depo', style: context.textTheme.labelMedium),
                const SizedBox(height: 10),
                buildWarehouseDropbox(),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Fotoğraf Yükleme Modu'),
                  value: ref.watch(mainProvider).isPhotoUploadMode,
                  onChanged: (value) async {
                    EasyLoading.show(status: 'Lütfen Bekleyiniz...');
                    await Future.delayed(const Duration(milliseconds: 1500));
                    ref.read(mainProvider).changePhotoUploadMode();
                    EasyLoading.dismiss();
                  },
                ),
              ],
            ),
          ),
        ));
  }

  DropdownButtonFormField<Object?> buildWarehouseDropbox() {
    return DropdownButtonFormField(
      onChanged: (value) {
        //  ref.read(homeProvider.notifier).setWarehouseList(value.toString());
      },
      value: ref
          .watch(homeProvider)
          .warehouseList
          ?.firstWhere((e) => e.isSelected == true,
              orElse: () =>
                  ref.watch(homeProvider).warehouseList?.first ??
                  GeneralListType())
          .code,
      items: ref.watch(homeProvider).warehouseList?.map((e) {
            return DropdownMenuItem(
              value: e.code,
              child: Text(e.name ?? ''),
            );
          }).toList() ??
          [],
    );
  }

  DropdownButtonFormField<Object?> buildPriceDropbox() {
    return DropdownButtonFormField(
      onChanged: (value) {
        //ref.read(homeProvider.notifier).setPriceList(value.toString());
      },
      value: ref
          .watch(homeProvider)
          .priceList
          ?.firstWhere((e) => e.isSelected == true,
              orElse: () =>
                  ref.watch(homeProvider).priceList?.first ?? GeneralListType())
          .code,
      items: ref.watch(homeProvider).priceList?.map((e) {
            return DropdownMenuItem(
              value: e.code,
              child: Text(e.name ?? ''),
            );
          }).toList() ??
          [],
    );
  }

  ListView buildMenu(List<Map<String, dynamic>> menuList) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuList.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: const Icon(Icons.arrow_forward_ios),
          leading:
              Icon(menuList[index]['icon'], color: context.colorScheme.primary),
          title: Text(menuList[index]['title'],
              style: context.textTheme.labelLarge),
          onTap: () {
            ref
                .read(homeProvider.notifier)
                .gotoMenuPage(context, menuList[index]['type']);
          },
        );
      },
    );
  }
}
