class AllTestimonialsModel {
  bool? status;
  List<Data>? data;

  AllTestimonialsModel({this.status, this.data});

  AllTestimonialsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? title;
  String? description;
  String? color;
  String? img;
  String? isDelete;
  String? createdDate;
  String? updatedAt;
  String? sId;
  String? status;
  int? iV;

  Data(
      {this.title,
        this.description,
        this.color,
        this.img,
        this.isDelete,
        this.createdDate,
        this.updatedAt,
        this.sId,
        this.status,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    color = json['color'];
    img = json['img'];
    isDelete = json['is_delete'];
    createdDate = json['Created_date'];
    updatedAt = json['updated_at'];
    sId = json['_id'];
    status = json['status'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['color'] = this.color;
    data['img'] = this.img;
    data['is_delete'] = this.isDelete;
    data['Created_date'] = this.createdDate;
    data['updated_at'] = this.updatedAt;
    data['_id'] = this.sId;
    data['status'] = this.status;
    data['__v'] = this.iV;
    return data;
  }
}
