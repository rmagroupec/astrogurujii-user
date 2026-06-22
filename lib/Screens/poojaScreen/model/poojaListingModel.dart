class PoojaModel {
  bool? status;
  List<PromotionalBanner>? promotionalBanner;
  List<Data>? data;
  String? message;


  PoojaModel({this.status,this.promotionalBanner, this.data, this.message});

  PoojaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['promotionalBanner'] != null) {
      promotionalBanner = <PromotionalBanner>[];
      json['promotionalBanner'].forEach((v) {
        promotionalBanner!.add(new PromotionalBanner.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.promotionalBanner != null) {
      data['promotionalBanner'] =
          this.promotionalBanner!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class PromotionalBanner {
  String? title;
  String? sId;
  String? type;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PromotionalBanner(
      {this.title,
        this.sId,
        this.type,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PromotionalBanner.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    sId = json['_id'];
    type = json['type'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Data {
  String? sId;
  List<ResultForPooja>? result;

  Data({this.sId, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['result'] != null) {
      result = <ResultForPooja>[];
      json['result'].forEach((v) {
        result!.add(new ResultForPooja.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultForPooja {
  String? sId;
  String? pujaImage;
  String? mandirName;
  String? aboutPuja;
  String? colorStatus;
  String? title;
  String? pujaDatetime;
  var purposeOfPooja;

  ResultForPooja(
      {this.sId,
        this.pujaImage,
        this.mandirName,
        this.aboutPuja,
        this.purposeOfPooja,
        this.colorStatus,
        this.title,
        this.pujaDatetime});

  ResultForPooja.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    pujaImage = json['pujaImage'];
    mandirName = json['mandirName'];
    aboutPuja = json['aboutPuja'];
    colorStatus = json['colorStatus'];
    title = json['title'];
    pujaDatetime = json['pujaDatetime'];
    purposeOfPooja = json['purposeOfPooja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['pujaImage'] = this.pujaImage;
    data['mandirName'] = this.mandirName;
    data['aboutPuja'] = this.aboutPuja;
    data['colorStatus'] = this.colorStatus;
    data['title'] = this.title;
    data['pujaDatetime'] = this.pujaDatetime;
    data['purposeOfPooja'] = this.purposeOfPooja;
    return data;
  }
}
