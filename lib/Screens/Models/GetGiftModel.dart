class GetGiftModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetGiftModel({this.status, this.message, this.data});

  GetGiftModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? image;
  String? status;
  String? sId; 
  int? price;
  int? iV; 

  Data({this.title, this.image, this.status, this.sId, this.price, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    status = json['status'];
    sId = json['_id'];
    price = json['price'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['price'] = this.price;
    data['__v'] = this.iV;
    return data;
  }
}
