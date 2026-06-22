class VerifyOtpModel {
  var status;
  var message;
  VerifyData? data;

  VerifyOtpModel({this.status, this.message, this.data});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  VerifyData.fromJson(json['data']) : null;
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

class VerifyData {
  var accessToken;
  var id;
  var userName;
  var email;
  var phone;
  var dob;
  var otp;
  var otpExpiry;
  var gender;
  var stateId;
  var cityId;
  var referralCode;
  var wallet;
  var referUserId;
  var profileImage;
  var createdDate;
  var updatedDate;
  var timeOfBirth;
  var placeOfBirth;
  var socialId;
  var socialType;
  var currency;
  var countryCode;
  var deviceId;
  var deviceToken;
  var isDelete;
  var status;

  VerifyData(
      {this.accessToken,
        this.id,
        this.userName,
        this.email,
        this.phone,
        this.dob,
        this.otp,
        this.otpExpiry,
        this.gender,
        this.stateId,
        this.cityId,
        this.referralCode,
        this.wallet,
        this.referUserId,
        this.profileImage,
        this.createdDate,
        this.updatedDate,
        this.timeOfBirth,
        this.placeOfBirth,
        this.socialId,
        this.socialType,
        this.currency,
        this.countryCode,
        this.deviceId,
        this.deviceToken,
        this.isDelete,
        this.status});

  VerifyData.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    id = json['id'];
    userName = json['user_name'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    otp = json['otp'];
    otpExpiry = json['otp_expiry'];
    gender = json['gender'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    referralCode = json['referral_code'];
    wallet = json['wallet'];
    referUserId = json['refer_user_id'];
    profileImage = json['profile_image'];
    createdDate = json['created_date'];
    updatedDate = json['updated_date'];
    timeOfBirth = json['time_of_birth'];
    placeOfBirth = json['place_of_birth'];
    socialId = json['social_id'];
    socialType = json['social_type'];
    currency = json['currency'];
    countryCode = json['country_code'];
    //deviceId = json['device_id'];
    //deviceToken = json['device_token'];
    isDelete = json['is_delete'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['dob'] = this.dob;
    data['otp'] = this.otp;
    data['otp_expiry'] = this.otpExpiry;
    data['gender'] = this.gender;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['referral_code'] = this.referralCode;
    data['wallet'] = this.wallet;
    data['refer_user_id'] = this.referUserId;
    data['profile_image'] = this.profileImage;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    data['time_of_birth'] = this.timeOfBirth;
    data['place_of_birth'] = this.placeOfBirth;
    data['social_id'] = this.socialId;
    data['social_type'] = this.socialType;
    data['currency'] = this.currency;
    data['country_code'] = this.countryCode;
    data['device_id'] = this.deviceId;
    data['device_token'] = this.deviceToken;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    return data;
  }
}
