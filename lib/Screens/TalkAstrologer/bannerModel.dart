class BannerModel {
  bool? status;
  String? message;
  List<BannerData>? data;

  BannerModel({this.status, this.message, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(new BannerData.fromJson(v));
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

class BannerData {
  String? link;
  String? type;
  String? img;
  String? isDelete;
  String? createdDate;
  String? updatedAt;
  String? sId;
  String? status;
  int? iV;
  String? callType;

  BannerData(
      {this.link,
        this.type,
        this.img,
        this.isDelete,
        this.createdDate,
        this.updatedAt,
        this.sId,
        this.status,
        this.iV,
        this.callType});

  BannerData.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    type = json['type'];
    img = json['img'];
    isDelete = json['is_delete'];
    createdDate = json['Created_date'];
    updatedAt = json['updated_at'];
    sId = json['_id'];
    status = json['status'];
    iV = json['__v'];
    callType = json['callType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['type'] = this.type;
    data['img'] = this.img;
    data['is_delete'] = this.isDelete;
    data['Created_date'] = this.createdDate;
    data['updated_at'] = this.updatedAt;
    data['_id'] = this.sId;
    data['status'] = this.status;
    data['__v'] = this.iV;
    data['callType'] = this.callType;
    return data;
  }
}
