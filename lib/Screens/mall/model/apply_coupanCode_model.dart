class ApplyCouponCodeModel {
  bool? status;
  var message;
  Data? data;

  ApplyCouponCodeModel({this.status, this.message, this.data});

  ApplyCouponCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  var startDate;
  var endDate;
  var minimumOrderPrice;
  var coupanDiscount;
  var discountType;
  var discountAmountUpTo;
  var perUserUse;
  var img;
  var createdDate;
  var updatedDate;
  var status;
  var isDelete;
  var coupanCode;
  var type;
  var currency;
  var text;
  var title;
  var sId;
  var iV;

  Data(
      {this.startDate,
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
        this.sId,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    minimumOrderPrice = json['minimum_order_price'];
    coupanDiscount = json['coupan_discount'];
    discountType = json['discount_type'];
    discountAmountUpTo = json['discount_amount_up_to'];
    perUserUse = json['per_user_use'];
    img = json['img'];
    createdDate = json['Created_date'];
    updatedDate = json['Updated_date'];
    status = json['status'];
    isDelete = json['is_delete'];
    coupanCode = json['coupan_code'];
    type = json['type'];
    currency = json['currency'];
    text = json['text'];
    title = json['title'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['minimum_order_price'] = this.minimumOrderPrice;
    data['coupan_discount'] = this.coupanDiscount;
    data['discount_type'] = this.discountType;
    data['discount_amount_up_to'] = this.discountAmountUpTo;
    data['per_user_use'] = this.perUserUse;
    data['img'] = this.img;
    data['Created_date'] = this.createdDate;
    data['Updated_date'] = this.updatedDate;
    data['status'] = this.status;
    data['is_delete'] = this.isDelete;
    data['coupan_code'] = this.coupanCode;
    data['type'] = this.type;
    data['currency'] = this.currency;
    data['text'] = this.text;
    data['title'] = this.title;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
