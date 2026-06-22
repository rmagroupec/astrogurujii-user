
class ProfileModel {
  bool? status;
  String? message;
  String? refer_amount;
  String? referral_code;
  var notifications_count;
  var tob;
  ProfileResults? results;

  ProfileModel({
    this.tob,
    this.notifications_count,
    this.referral_code,this.refer_amount,this.status, this.message, this.results});

  ProfileModel.fromJson(Map<String?, dynamic> json) {
    tob = json['tob'];
    referral_code = json['referral_code'];
    status = json['status'];
    notifications_count = json['notifications_count'];
    message = json['message'];
    refer_amount = json['refer_amount'];
    results =
    json['results'] != null ?  ProfileResults.fromJson(json['results']) : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data =  Map<String?, dynamic>();
    data['tob'] = this.tob;
    data['referral_code'] = this.referral_code;
    data['notifications_count'] = this.notifications_count;
    data['status'] = this.status;
    data['message'] = this.message;
    data['refer_amount'] = this.refer_amount;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class ProfileResults {
  String? password;
  String? gender;
  var wallet;
  var currency;
  var wallet_usd;
  String? profileImg;
  String? referralCode;
  String? referUserId;
  String? dob;
  String? tob;
  String? pob;
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

  ProfileResults(
      {this.password,
        this.gender,
        this.wallet,
        this.currency,
        this.wallet_usd,
        this.profileImg,
        this.referralCode,
        this.referUserId,
        this.dob,
        this.tob,
        this.pob,
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

  ProfileResults.fromJson(Map<String?, dynamic> json) {
    wallet_usd = json['wallet_usd'];
    password = json['password'];
    currency = json['currency'];
    gender = json['gender'];
    wallet = json['wallet'];
    profileImg = json['profile_img'];
    referralCode = json['referral_code'];
    referUserId = json['refer_user_id'];
    dob = json['dob'];
    tob = json['tob'];
    pob = json['pob'];
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

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['country'] = this.currency;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['wallet'] = this.wallet;
    data['profile_img'] = this.profileImg;
    data['referral_code'] = this.referralCode;
    data['refer_user_id'] = this.referUserId;
    data['dob'] = this.dob;
    data['tob'] = this.tob;
    data['pob'] = this.pob;
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