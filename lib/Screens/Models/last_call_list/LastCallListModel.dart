class LastCallListModel {
  bool? result;
  var message;
  Data2? data2;
  WattingUserData? watting_user_data;

  LastCallListModel({this.result, this.message, this.data2});

  LastCallListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data2 = json['data2'] != null ? new Data2.fromJson(json['data2']) : null;
    watting_user_data = json['watting_user_data'] != null ? new WattingUserData.fromJson(json['watting_user_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data2 != null) {
      data['data2'] = this.data2!.toJson();
    }
    return data;
  }
}

class Data2 {
  var id;
  var channelId;
  var fbChannelId;
  var astroId;
  var userId;
  var startTime;
  var endTime;
  var callDuracation;
  var status;
  var createdAt;
  var updatedAt;
  var callType;
  var remedy;
  var knowlarityCallId;
  var userName;
  var astroName;
  var astroProfileImg;
  var orderTime;
  var userImage;
  var ratings;
  var callRate;
  var totalAmount;
  var callMin;
  var call_duracation;
  var difference;

  Data2(
      {this.id,
        this.channelId,
        this.difference,
        this.fbChannelId,
        this.astroId,
        this.userId,
        this.startTime,
        this.endTime,
        this.callDuracation,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.callType,
        this.remedy,
        this.knowlarityCallId,
        this.userName,
        this.astroName,
        this.astroProfileImg,
        this.orderTime,
        this.userImage,
        this.ratings,
        this.callRate,
        this.totalAmount,
        this.call_duracation,
        this.callMin});

  Data2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    difference = json['difference'];
    call_duracation = json['call_duracation'];
    channelId = json['channel_id'];
    fbChannelId = json['fb_channel_id'];
    astroId = json['astro_id'];
    userId = json['user_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    callDuracation = json['call_duracation'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    callType = json['call_type'];
    remedy = json['remedy'];
    knowlarityCallId = json['knowlarity_call_id'];
    userName = json['user_name'];
    astroName = json['astro_name'];
    astroProfileImg = json['astro_profile_img'];
    orderTime = json['OrderTime'];
    userImage = json['user_image'];
    ratings = json['ratings'];
    callRate = json['call_rate'];
    totalAmount = json['total_amount'];
    callMin = json['call_min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['difference'] = this.difference;
    data['call_duracation'] = this.call_duracation;
    data['channel_id'] = this.channelId;
    data['fb_channel_id'] = this.fbChannelId;
    data['astro_id'] = this.astroId;
    data['user_id'] = this.userId;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['call_duracation'] = this.callDuracation;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['call_type'] = this.callType;
    data['remedy'] = this.remedy;
    data['knowlarity_call_id'] = this.knowlarityCallId;
    data['user_name'] = this.userName;
    data['astro_name'] = this.astroName;
    data['astro_profile_img'] = this.astroProfileImg;
    data['OrderTime'] = this.orderTime;
    data['user_image'] = this.userImage;
    data['ratings'] = this.ratings;
    data['call_rate'] = this.callRate;
    data['total_amount'] = this.totalAmount;
    data['call_min'] = this.callMin;
    return data;
  }
}

class WattingUserData {
  var userId;
  var astroId;
  var status;
  var wallet;
  var rate;
  var name;
  var profile;
  var astrologerId;

  WattingUserData(
      {this.userId,
        this.astroId,
        this.status,
        this.wallet,
        this.rate,
        this.name,
        this.profile,
        this.astrologerId});

  WattingUserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    astroId = json['astrologer_id'];
    status = json['status'];
    wallet = json['wallet'];
    rate = json['rate'];
    name = json['name'];
    profile = json['profile'];
    astrologerId = json['astrologer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['astrologer_id'] = this.astroId;
    data['status'] = this.status;
    data['wallet'] = this.wallet;
    data['rate'] = this.rate;
    data['name'] = this.name;
    data['profile'] = this.profile;
    data['astrologer_id'] = this.astrologerId;
    return data;
  }
}
