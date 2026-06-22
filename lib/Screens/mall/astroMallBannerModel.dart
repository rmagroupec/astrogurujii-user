class AstroMallBannerModel {
  bool? status;
  String? message;
  List<AstoBannerData>? data;

  AstroMallBannerModel({this.status, this.message, this.data});

  AstroMallBannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AstoBannerData>[];
      json['data'].forEach((v) {
        data!.add(new AstoBannerData.fromJson(v));
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

class AstoBannerData {
  String? name;
  String? type;
  String? img;
  String? createdDate;
  String? updatedAt;
  String? status;
  String? sId;
  int? iV;

  AstoBannerData(
      {this.name,
        this.type,
        this.img,
        this.createdDate,
        this.updatedAt,
        this.status,
        this.sId,
        this.iV});

  AstoBannerData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    img = json['img'];
    createdDate = json['Created_date'];
    updatedAt = json['updated_at'];
    status = json['status'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['img'] = this.img;
    data['Created_date'] = this.createdDate;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
