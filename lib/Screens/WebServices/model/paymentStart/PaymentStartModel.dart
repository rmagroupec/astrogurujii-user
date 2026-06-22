class PaymentStartModel {
  bool? status;
  var message;
  Results? results;

  PaymentStartModel({this.status, this.message, this.results});

  PaymentStartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  var walletAmount;
  var profitAmount;
  var coupanCode;
  var createdDate;
  var updatedDate;
  var isDelete;
  var status;
  var sId;
  var amount;
  var userId;
  var orderId;


  Results(
      {this.walletAmount,
        this.profitAmount,
        this.coupanCode,
        this.createdDate,
        this.updatedDate,
        this.isDelete,
        this.status,
        this.sId,
        this.amount,
        this.userId,
        this.orderId,
       });

  Results.fromJson(Map<String, dynamic> json) {
    walletAmount = json['wallet_amount'];
    profitAmount = json['profit_amount'];
    coupanCode = json['coupan_code'];
    createdDate = json['Created_date'];
    updatedDate = json['Updated_date'];
    isDelete = json['is_delete'];
    status = json['status'];
    sId = json['_id'];
    amount = json['amount'];
    userId = json['user_id'];
    orderId = json['order_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_amount'] = this.walletAmount;
    data['profit_amount'] = this.profitAmount;
    data['coupan_code'] = this.coupanCode;
    data['Created_date'] = this.createdDate;
    data['Updated_date'] = this.updatedDate;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['amount'] = this.amount;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;

    return data;
  }
}
