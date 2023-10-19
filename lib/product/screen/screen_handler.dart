import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../assets/lottie_enum.dart';
import '../constant/app_process_enum.dart';

class ScreenHandler {
  static Widget build(
      Widget child, ApppProcessStatus homeState, String? message,
      [Function()? onRefresh]) {
    switch (homeState) {
      case ApppProcessStatus.loading:
        return ScreenHandlerWidget(
          assetLottieFile: AssetLottieFile.loading,
          message: message,
        );

      case ApppProcessStatus.error:
        return ScreenHandlerWidget(
          assetLottieFile: AssetLottieFile.error,
          message: message,
          onRefresh: onRefresh,
        );
      case ApppProcessStatus.empty:
        return ScreenHandlerWidget(
          assetLottieFile: AssetLottieFile.empty,
          message: message,
          onRefresh: onRefresh,
        );
      case ApppProcessStatus.success:
        return ScreenHandlerWidget(
          assetLottieFile: AssetLottieFile.success,
          message: message,
          onRefresh: onRefresh,
        );
      case ApppProcessStatus.noLicence:
        return ScreenHandlerWidget(
          assetLottieFile: AssetLottieFile.licence,
          message: message,
          onRefresh: onRefresh,
        );
      default:
        return child;
    }
  }
}

class ScreenHandlerWidget extends StatelessWidget {
  const ScreenHandlerWidget(
      {super.key, required this.assetLottieFile, this.message, this.onRefresh});

  final AssetLottieFile assetLottieFile;
  final String? message;
  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset(
              assetLottieFile.getPath,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            message ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        onRefresh != null
            ? TextButton.icon(
                onPressed: () {
                  if (onRefresh != null) {
                    onRefresh!();
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Yeniden Dene"))
            : Container()
      ],
    );
  }
}
