class OrderNowModel {
  bool? status;
  var message;
  Results? results;

  OrderNowModel({this.status, this.message, this.results});

  OrderNowModel.fromJson(Map<String, dynamic> json) {
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
  var razorpayOrderId;

  Results({this.razorpayOrderId});

  Results.fromJson(Map<String, dynamic> json) {
    razorpayOrderId = json['razorpay_order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['razorpay_order_id'] = this.razorpayOrderId;
    return data;
  }
}
