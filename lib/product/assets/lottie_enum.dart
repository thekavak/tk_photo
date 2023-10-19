enum AssetLottieFile {
  empty('assets/lottie/empty.json'),
  error('assets/lottie/error.json'),
  loading('assets/lottie/loading.json'),
  success('assets/lottie/success.json'),

  licence('assets/lottie/licence.json'),
  no_Data('assets/lottie/no_data.json');

  final String path;
  const AssetLottieFile(this.path);

  String get getPath => path;
}
