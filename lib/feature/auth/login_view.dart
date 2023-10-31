import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

import '../../product/widgets/button/app_elevated_button.dart';
import '../../product/widgets/forms/text_form_field.dart';
import 'login_provider.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    return Scaffold(
        backgroundColor: context.colorScheme.onBackground,
        body: SafeArea(
            child: Padding(
          padding: context.paddingNormal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/tk_logo.png',
                  width: context.dynamicWidth(0.6)),
              const SizedBox(height: 36),
              ThemeTextFormField(
                  controller: TextEditingController(text: loginForm.username),
                  onChanged: loginForm.setUsername,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Kullanıcı Adı',
                  prefixIcon: Icons.email),
              const SizedBox(height: 16),
              ThemeTextFormField(
                  controller: TextEditingController(text: loginForm.password),
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: loginForm.setPassword,
                  hintText: 'Parola',
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.password_outlined),
              const SizedBox(height: 24),
              AppElevatedButton(
                  isPaddingZero: false,
                  title: "Giriş Yap",
                  isShowIcon: true,
                  callback: () async {
                    var response = await loginForm.submitLoginForm();
                    print("resposne${response?.result}");
                    if (response?.result == true) {
                      // ignore: use_build_context_synchronously
                      await Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    } else {
                      print("else");
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response?.message ?? '')));
                    }
                  }),
              const SizedBox(height: 12),
              const Divider(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: context.paddingLow,
                ),
                onPressed: loginForm.setDemoLogin,
                child: Text("Demo Girişi",
                    style: context.textTheme.labelMedium!.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
              ),
            ],
          ),
        )));
  }
}
