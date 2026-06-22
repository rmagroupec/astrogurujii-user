class CouponModel {
  final bool status;
  final String message;
  final List<CouponData> data;

  CouponModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      status: json['status'],
      message: json['message'],
      data: List<CouponData>.from(
        json['data'].map((item) => CouponData.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': List<dynamic>.from(data.map((item) => item.toJson())),
    };
  }
}

class CouponData {
    var startDate;
    var endDate;
    var minimumOrderPrice;
    var coupanDiscount;
    var discountType;
    var discountAmountUpTo;
    var perUserUse;
    var img;
    DateTime ?createdDate;
    DateTime ?updatedDate;
    var status;
    var isDelete;
    var coupanCode;
    var type;
    var currency;
    var text;
    var title;
    var id;
    var v;

  CouponData({
    this.startDate,
    this.endDate,
    this.minimumOrderPrice,
    this.coupanDiscount,
    this.discountType,
    this.discountAmountUpTo,
    this.perUserUse,
    this.img,
   this.createdDate,
   this.updatedDate,
   this.status,
   this.isDelete,
   this.coupanCode,
   this.type,
   this.currency,
   this.text,
   this.title,
   this.id,
   this.v,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      minimumOrderPrice: json['minimum_order_price'],
      coupanDiscount: json['coupan_discount'],
      discountType: json['discount_type'],
      discountAmountUpTo: json['discount_amount_up_to'],
      perUserUse: json['per_user_use'],
      img: json['img'] ?? '',
      createdDate: DateTime.parse(json['Created_date']),
      updatedDate: DateTime.parse(json['Updated_date']),
      status: json['status'],
      isDelete: json['is_delete'],
      coupanCode: json['coupan_code'],
      type: json['type'],
      currency: json['currency'],
      text: json['text'],
      title: json['title'],
      id: json['_id'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'minimum_order_price': minimumOrderPrice,
      'coupan_discount': coupanDiscount,
      'discount_type': discountType,
      'discount_amount_up_to': discountAmountUpTo,
      'per_user_use': perUserUse,
      'img': img,
      'Created_date': createdDate,
      'Updated_date': updatedDate,
      'status': status,
      'is_delete': isDelete,
      'coupan_code': coupanCode,
      'type': type,
      'currency': currency,
      'text': text,
      'title': title,
      '_id': id,
      '__v': v,
    };
  }
}
