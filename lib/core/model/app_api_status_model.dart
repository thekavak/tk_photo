class AppApiStatusModel {
  bool? result;
  String? message;
  int? state;
  int? httpStatusCode;

  AppApiStatusModel(
      {this.result, this.message, this.state, this.httpStatusCode});

  AppApiStatusModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    state = json['state'];
    httpStatusCode = json['httpStatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    data['state'] = state;
    data['httpStatusCode'] = httpStatusCode;
    return data;
  }
}
