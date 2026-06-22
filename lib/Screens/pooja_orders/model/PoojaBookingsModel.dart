class PoojaBookingsModel {
  bool? status;
  String? message;
  List<Data>? data;

  PoojaBookingsModel({this.status, this.message, this.data});

  PoojaBookingsModel.fromJson(Map<String, dynamic> json) {
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
  bool? isActive;
  bool? is_live;
  // List<String>? members;
  String? endTime;
  String? sId;
  String? users;
  PujaId? pujaId;
  String? pujaDate;
  String? pujaAmount;
  String? pujaType;
  String? pujaBookingId;
  String? channelId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? astrologerId;
  String? astrologerName;
  String? startTime;

  Data(
      {this.isActive,
      this.is_live,
        // this.members,
        this.endTime,
        this.sId,
        this.users,
        this.pujaId,
        this.pujaDate,
        this.pujaAmount,
        this.pujaType,
        this.pujaBookingId,
        this.channelId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.astrologerId,
        this.astrologerName,
        this.startTime});

  Data.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    is_live = json['is_live'];
    // members = json['members'].cast<String>();
    endTime = json['endTime'];
    sId = json['_id'];
    users = json['users'];
    pujaId =
    json['puja_id'] != null ? new PujaId.fromJson(json['puja_id']) : null;
    pujaDate = json['puja_date'];
    pujaAmount = json['puja_amount'];
    pujaType = json['puja_type'];
    pujaBookingId = json['puja_booking_id'];
    channelId = json['channel_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    astrologerId = json['astrologer_id'];
    astrologerName = json['astrologer_name'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active'] = this.isActive;
    data['is_live'] = this.is_live;
    // data['members'] = this.members;
    data['endTime'] = this.endTime;
    data['_id'] = this.sId;
    data['users'] = this.users;
    if (this.pujaId != null) {
      data['puja_id'] = this.pujaId!.toJson();
    }
    data['puja_date'] = this.pujaDate;
    data['puja_amount'] = this.pujaAmount;
    data['puja_type'] = this.pujaType;
    data['puja_booking_id'] = this.pujaBookingId;
    data['channel_id'] = this.channelId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['astrologer_id'] = this.astrologerId;
    data['astrologer_name'] = this.astrologerName;
    data['startTime'] = this.startTime;
    return data;
  }
}

class PujaId {
  String? pujaImage;
  String? aboutPuja;
  String? sId;
  String? title;

  PujaId({this.pujaImage, this.aboutPuja, this.sId, this.title});

  PujaId.fromJson(Map<String, dynamic> json) {
    pujaImage = json['pujaImage'];
    aboutPuja = json['aboutPuja'];
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pujaImage'] = this.pujaImage;
    data['aboutPuja'] = this.aboutPuja;
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}
