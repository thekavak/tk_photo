class LoginModel {
  List<LoginModelData>? data;
  bool? state;
  String? message;

  LoginModel({this.data, this.state, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LoginModelData>[];
      json['data'].forEach((v) {
        data!.add(LoginModelData.fromJson(v));
      });
    }
    state = json['state'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['state'] = state;
    data['message'] = message;
    return data;
  }
}

class LoginModelData {
  String? rowGuid;
  String? userName;
  String? password;
  String? companyName;
  String? firstName;
  String? lastName;
  String? serviceURL;
  String? companyLogo;
  int? isActive;
  String? errorMSG;
  int? licenceCheckIntervalDay;
  int? isSingleLicence;
  String? deviceMacId;
  RecordDate? recordDate;
  RecordDate? lastLoginDate;
  RecordDate? licenceEndDate;

  LoginModelData(
      {this.rowGuid,
      this.userName,
      this.password,
      this.companyName,
      this.firstName,
      this.lastName,
      this.serviceURL,
      this.companyLogo,
      this.isActive,
      this.errorMSG,
      this.licenceCheckIntervalDay,
      this.isSingleLicence,
      this.deviceMacId,
      this.recordDate,
      this.lastLoginDate,
      this.licenceEndDate});

  LoginModelData.fromJson(Map<String, dynamic> json) {
    rowGuid = json['RowGuid'];
    userName = json['UserName'];
    password = json['Password'];
    companyName = json['CompanyName'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    serviceURL = json['ServiceURL'];
    companyLogo = json['CompanyLogo'];
    isActive = json['IsActive'];
    errorMSG = json['ErrorMSG'];
    licenceCheckIntervalDay = json['LicenceCheckIntervalDay'];
    isSingleLicence = json['isSingleLicence'];
    deviceMacId = json['DeviceMacId'];
    recordDate = json['RecordDate'] != null
        ? RecordDate.fromJson(json['RecordDate'])
        : null;
    lastLoginDate = json['LastLoginDate'] != null
        ? RecordDate.fromJson(json['LastLoginDate'])
        : null;
    licenceEndDate = json['LicenceEndDate'] != null
        ? RecordDate.fromJson(json['LicenceEndDate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RowGuid'] = rowGuid;
    data['UserName'] = userName;
    data['Password'] = password;
    data['CompanyName'] = companyName;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['ServiceURL'] = serviceURL;
    data['CompanyLogo'] = companyLogo;
    data['IsActive'] = isActive;
    data['ErrorMSG'] = errorMSG;
    data['LicenceCheckIntervalDay'] = licenceCheckIntervalDay;
    data['isSingleLicence'] = isSingleLicence;
    data['DeviceMacId'] = deviceMacId;
    if (recordDate != null) {
      data['RecordDate'] = recordDate!.toJson();
    }
    if (lastLoginDate != null) {
      data['LastLoginDate'] = lastLoginDate!.toJson();
    }
    if (licenceEndDate != null) {
      data['LicenceEndDate'] = licenceEndDate!.toJson();
    }
    return data;
  }
}

class RecordDate {
  String? date;
  int? timezoneType;
  String? timezone;

  RecordDate({this.date, this.timezoneType, this.timezone});

  RecordDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timezone_type'] = timezoneType;
    data['timezone'] = timezone;
    return data;
  }
}
