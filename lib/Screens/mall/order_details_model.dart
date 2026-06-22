class OrderDetailsModelN {
  bool? status;
  var message;
  List<OrdersResults>? results;

  OrderDetailsModelN({this.status, this.message, this.results});

  OrderDetailsModelN.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['results'] != null) {
      results = <OrdersResults>[];
      json['results'].forEach((v) {
        results!.add(new OrdersResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdersResults {
  var id;
  var userId;
  var addressId;
  var agentID;
  var payingAmount;
  var couponCode;
  var couponDiscount;
  var deliveryCharges;
  var orderAmount;
  var totalAmount;
  var gstAmount;
  var paymentMethod;
  var instruction;
  var deliveryDate;
  var deliverySlot;
  var status;
  var createdAt;
  var updatedAt;
  var refferId;
  var refferAmount;
  var noOfItems;
  var productName;
  var image;
  var phone;
  var address;
  var pincode;
  var contactName;
  List<OrderItemsN>? orderItems;

  OrdersResults(
      {this.id,
        this.userId,
        this.addressId,
        this.agentID,
        this.payingAmount,
        this.couponCode,
        this.couponDiscount,
        this.deliveryCharges,
        this.orderAmount,
        this.totalAmount,
        this.gstAmount,
        this.paymentMethod,
        this.instruction,
        this.deliveryDate,
        this.deliverySlot,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.refferId,
        this.refferAmount,
        this.noOfItems,
        this.productName,
        this.image,
        this.phone,
        this.address,
        this.pincode,
        this.contactName,
        this.orderItems});

  OrdersResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressId = json['address_id'];
    agentID = json['agentID'];
    payingAmount = json['paying_amount'];
    couponCode = json['coupon_code'];
    couponDiscount = json['coupon_discount'];
    deliveryCharges = json['delivery_charges'];
    orderAmount = json['order_amount'];
    totalAmount = json['total_amount'];
    gstAmount = json['gst_amount'];
    paymentMethod = json['payment_method'];
    instruction = json['instruction'];
    deliveryDate = json['delivery_date'];
    deliverySlot = json['delivery_slot'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    refferId = json['reffer_id'];
    refferAmount = json['reffer_amount'];
    noOfItems = json['no_of_items'];
    productName = json['product_name'];
    image = json['image'];
    phone = json['phone'];
    address = json['address'];
    pincode = json['pincode'];
    contactName = json['contact_name'];
    if (json['order_items'] != null) {
      orderItems = <OrderItemsN>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItemsN.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['agentID'] = this.agentID;
    data['paying_amount'] = this.payingAmount;
    data['coupon_code'] = this.couponCode;
    data['coupon_discount'] = this.couponDiscount;
    data['delivery_charges'] = this.deliveryCharges;
    data['order_amount'] = this.orderAmount;
    data['total_amount'] = this.totalAmount;
    data['gst_amount'] = this.gstAmount;
    data['payment_method'] = this.paymentMethod;
    data['instruction'] = this.instruction;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_slot'] = this.deliverySlot;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['reffer_id'] = this.refferId;
    data['reffer_amount'] = this.refferAmount;
    data['no_of_items'] = this.noOfItems;
    data['product_name'] = this.productName;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['contact_name'] = this.contactName;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItemsN {
  var itemID;
  var orderID;
  var productID;
  var qty;
  var price;
  var netPrice;
  var status;
  var createdAt;
  var updatedAt;
  var productName;
  var image;

  OrderItemsN(
      {this.itemID,
        this.orderID,
        this.productID,
        this.qty,
        this.price,
        this.netPrice,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.productName,
        this.image});

  OrderItemsN.fromJson(Map<String, dynamic> json) {
    itemID = json['itemID'];
    orderID = json['orderID'];
    productID = json['productID'];
    qty = json['qty'];
    price = json['price'];
    netPrice = json['net_price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productName = json['product_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemID'] = this.itemID;
    data['orderID'] = this.orderID;
    data['productID'] = this.productID;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['net_price'] = this.netPrice;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_name'] = this.productName;
    data['image'] = this.image;
    return data;
  }
}
