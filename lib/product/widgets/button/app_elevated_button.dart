import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class AppElevatedButton extends StatefulWidget {
  const AppElevatedButton(
      {super.key,
      required this.title,
      this.isShowIcon = false,
      required this.callback,
      this.isPaddingZero = false,
      this.fontSize = 16});

  final String? title;
  final bool isShowIcon;
  final double fontSize;
  final bool isPaddingZero;
  final Future<void> Function()? callback;

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton> {
  bool isLoading = false;

  changeLoading() {
    if (mounted) {
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          changeLoading();

          await widget.callback?.call();
          Future.delayed(const Duration(seconds: 1), () {
            changeLoading();
          });
        },
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: !widget.isPaddingZero ? context.paddingLow : EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: isLoading == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.title ?? '',
                        style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.background,
                            fontSize: widget.fontSize)),
                    SizedBox(
                      width: widget.isShowIcon ? 8 : 0,
                    ),
                    widget.isShowIcon
                        ? Icon(
                            Icons.arrow_forward_outlined,
                            color: context.colorScheme.background,
                          )
                        : const SizedBox()
                  ],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
        ));
  }
}
