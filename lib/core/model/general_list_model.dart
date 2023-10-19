class GeneralListType {
  String? code;
  String? name;
  bool? isSelected;

  GeneralListType({this.code, this.name, this.isSelected = false});

  GeneralListType.fromJson(Map<String, dynamic> json) {
    code = json['Code'].toString();
    name = json['Name'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Name'] = name;
    data['isSelected'] = isSelected;
    return data;
  }
}
