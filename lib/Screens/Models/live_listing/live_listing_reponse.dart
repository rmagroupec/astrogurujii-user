class LiveListing {
  bool? status;
  String? message;
  List<Data>? data;

  LiveListing({this.status, this.message, this.data});

  LiveListing.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  List<String>? users;
  String? isLive;
  String? startTime;
  String? endTime;
  String? channelId;
  String? password;
  String? isDelete;
  String? createdDate;
  String? updatedAt;
  AstrologerId? astrologerId;
  String? liveDate;
  String? status;
  String? recurringDay;
  int? iV;
  String? title;

  Data(
      {this.sId,
        this.users,
        this.isLive,
        this.startTime,
        this.endTime,
        this.channelId,
        this.password,
        this.isDelete,
        this.createdDate,
        this.updatedAt,
        this.astrologerId,
        this.liveDate,
        this.status,
        this.recurringDay,
        this.iV,
        this.title});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    users = json['users'].cast<String>();
    isLive = json['is_live'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    channelId = json['channel_id'];
    password = json['password'];
    isDelete = json['is_delete'];
    createdDate = json['Created_date'];
    updatedAt = json['updated_at'];
    astrologerId = json['astrologer_id'] != null
        ? new AstrologerId.fromJson(json['astrologer_id'])
        : null;
    liveDate = json['live_date'];
    status = json['status'];
    recurringDay = json['recurringDay'];
    iV = json['__v'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['users'] = this.users;
    data['is_live'] = this.isLive;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['channel_id'] = this.channelId;
    data['password'] = this.password;
    data['is_delete'] = this.isDelete;
    data['Created_date'] = this.createdDate;
    data['updated_at'] = this.updatedAt;
    if (this.astrologerId != null) {
      data['astrologer_id'] = this.astrologerId!.toJson();
    }
    data['live_date'] = this.liveDate;
    data['status'] = this.status;
    data['recurringDay'] = this.recurringDay;
    data['__v'] = this.iV;
    data['title'] = this.title;
    return data;
  }
}

class AstrologerId {
  String? sId;
  String? profileImg;
  String? name;
  String? displayName;
  String? number;
  String? email;

  AstrologerId({this.sId, this.profileImg, this.name, this.number, this.email ,this.displayName});

  AstrologerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImg = json['profile_img'];
    name = json['name'];
    displayName = json['displayname'];
    number = json['number'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_img'] = this.profileImg;
    data['name'] = this.name;
    data['displayname'] = this.displayName;
    data['number'] = this.number;
    data['email'] = this.email;
    return data;
  }
}
