class LoginModel {
  bool? status;
  String? message;
  LoginData? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  var phone;
  var otpExpiry;
  bool? newUser;
  var name;

  LoginData({this.phone, this.otpExpiry, this.newUser,this.name});

  LoginData.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    otpExpiry = json['otpExpiry'];
    newUser = json['newUser'];

    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['otpExpiry'] = this.otpExpiry;
    data['newUser'] = this.newUser;
    data['name']=this.name;
    return data;
  }
}
