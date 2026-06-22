class AstroStatusModel {
  bool? status;
  String? message;
  Data? data;

  AstroStatusModel({this.status, this.message, this.data});

  AstroStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? number;
  String? email;
  String? qulification;
  String? experience;
  String? status;
  String? sId;
  String? name;
  String? userId;
  int? iV;

  Data(
      {this.number,
        this.email,
        this.qulification,
        this.experience,
        this.status,
        this.sId,
        this.name,
        this.userId,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    email = json['email'];
    qulification = json['qulification'];
    experience = json['experience'];
    status = json['status'];
    sId = json['_id'];
    name = json['name'];
    userId = json['userId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['email'] = this.email;
    data['qulification'] = this.qulification;
    data['experience'] = this.experience;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    return data;
  }
}
