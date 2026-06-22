class UpdateprofileModel {
  bool? status;
  String? message;
  Results? results;

  UpdateprofileModel({this.status, this.message, this.results});

  UpdateprofileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  String? password;
  String? gender;
  int? wallet;
  String? profileImg;
  String? referralCode;
  String? referUserId;
  String? dob;
  String? tob;
  String? pob;
  String? rashi;
  String? createdDate;
  String? updatedDate;
  String? isDelete;
  String? deviceToken;
  String? deviceId;
  String? otp;
  String? sId;
  String? email;
  String? number;
  String? name;
  String? status;
  int? iV;

  Results(
      {this.password,
        this.gender,
        this.wallet,
        this.profileImg,
        this.referralCode,
        this.referUserId,
        this.dob,
        this.tob,
        this.pob,
        this.rashi,
        this.createdDate,
        this.updatedDate,
        this.isDelete,
        this.deviceToken,
        this.deviceId,
        this.otp,
        this.sId,
        this.email,
        this.number,
        this.name,
        this.status,
        this.iV});

  Results.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    gender = json['gender'];
    wallet = json['wallet'];
    profileImg = json['profile_img'];
    referralCode = json['referral_code'];
    referUserId = json['refer_user_id'];
    dob = json['dob'];
    tob = json['tob'];
    pob = json['pob'];
    rashi = json['rashi'];
    createdDate = json['Created_date'];
    updatedDate = json['Updated_date'];
    isDelete = json['is_delete'];
    deviceToken = json['deviceToken'];
    deviceId = json['deviceId'];
    otp = json['otp'];
    sId = json['_id'];
    email = json['email'];
    number = json['number'];
    name = json['name'];
    status = json['status'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['wallet'] = this.wallet;
    data['profile_img'] = this.profileImg;
    data['referral_code'] = this.referralCode;
    data['refer_user_id'] = this.referUserId;
    data['dob'] = this.dob;
    data['tob'] = this.tob;
    data['pob'] = this.pob;
    data['rashi'] = this.rashi;
    data['Created_date'] = this.createdDate;
    data['Updated_date'] = this.updatedDate;
    data['is_delete'] = this.isDelete;
    data['deviceToken'] = this.deviceToken;
    data['deviceId'] = this.deviceId;
    data['otp'] = this.otp;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['number'] = this.number;
    data['name'] = this.name;
    data['status'] = this.status;
    data['__v'] = this.iV;
    return data;
  }
}