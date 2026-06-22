
import 'package:astro_gurujii/Screens/mall/model/order_list/OrderItem.dart';

class Result {
    String? address;
    String? address_id;
    String? agentID;
    String? contact_name;
    String? coupon_code;
    String? coupon_discount;
    String? created_at;
    String? delivery_charges;
    String? delivery_date;
    String? delivery_slot;
    String? gst_amount;
    String? id;
    String? image;
    String? instruction;
    int? no_of_items;
    String? order_amount;
    List<OrderItem>? order_items;
    String? paying_amount;
    String? payment_method;
    String? phone;
    String? pincode;
    String? product_name;
    String? reffer_amount;
    String? reffer_id;
    String? status;
    String? total_amount;
    String? updated_at;
    String? user_id;

    Result({this.address, this.address_id, this.agentID, this.contact_name, this.coupon_code, this.coupon_discount, this.created_at, this.delivery_charges, this.delivery_date, this.delivery_slot, this.gst_amount, this.id, this.image, this.instruction, this.no_of_items, this.order_amount, this.order_items, this.paying_amount, this.payment_method, this.phone, this.pincode, this.product_name, this.reffer_amount, this.reffer_id, this.status, this.total_amount, this.updated_at, this.user_id});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            address: json['address'], 
            address_id: json['address_id'], 
            agentID: json['agentID'], 
            contact_name: json['contact_name'], 
            coupon_code: json['coupon_code'], 
            coupon_discount: json['coupon_discount'], 
            created_at: json['created_at'], 
            delivery_charges: json['delivery_charges'], 
            delivery_date: json['delivery_date'], 
            delivery_slot: json['delivery_slot'], 
            gst_amount: json['gst_amount'], 
            id: json['id'], 
            image: json['image'], 
            instruction: json['instruction'], 
            no_of_items: json['no_of_items'], 
            order_amount: json['order_amount'], 
            order_items: json['order_items'] != null ? (json['order_items'] as List).map((i) => OrderItem.fromJson(i)).toList() : null, 
            paying_amount: json['paying_amount'], 
            payment_method: json['payment_method'], 
            phone: json['phone'], 
            pincode: json['pincode'], 
            product_name: json['product_name'], 
            reffer_amount: json['reffer_amount'], 
            reffer_id: json['reffer_id'], 
            status: json['status'], 
            total_amount: json['total_amount'], 
            updated_at: json['updated_at'], 
            user_id: json['user_id'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['address'] = this.address;
        data['address_id'] = this.address_id;
        data['agentID'] = this.agentID;
        data['contact_name'] = this.contact_name;
        data['coupon_code'] = this.coupon_code;
        data['coupon_discount'] = this.coupon_discount;
        data['created_at'] = this.created_at;
        data['delivery_charges'] = this.delivery_charges;
        data['delivery_date'] = this.delivery_date;
        data['delivery_slot'] = this.delivery_slot;
        data['gst_amount'] = this.gst_amount;
        data['id'] = this.id;
        data['image'] = this.image;
        data['instruction'] = this.instruction;
        data['no_of_items'] = this.no_of_items;
        data['order_amount'] = this.order_amount;
        data['paying_amount'] = this.paying_amount;
        data['payment_method'] = this.payment_method;
        data['phone'] = this.phone;
        data['pincode'] = this.pincode;
        data['product_name'] = this.product_name;
        data['reffer_amount'] = this.reffer_amount;
        data['reffer_id'] = this.reffer_id;
        data['status'] = this.status;
        data['total_amount'] = this.total_amount;
        data['updated_at'] = this.updated_at;
        data['user_id'] = this.user_id;
        if (this.order_items != null) {
            data['order_items'] = this.order_items!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}