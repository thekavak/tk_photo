class UploadedFile {
  String name;
  String path;
  String colorCode, itemCode;
  bool status;
  int size;
  bool loading;
  UploadedFile(
      {required this.name,
      required this.path,
      required this.colorCode,
      required this.itemCode,
      required this.status,
      required this.loading,
      required this.size});
}

class FileResponse {
  bool? status;
  String? message;
  String? url;

  FileResponse({this.status, this.message, this.url});

  FileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['url'] = url;
    return data;
  }
}
