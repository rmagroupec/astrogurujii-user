
import 'package:astro_gurujii/Screens/mall/model/cart_list/Result.dart';

class CartListModel {
    String? delivery_charges;
    String? gst;
    String? item_total;
    String? message;
    String? mrp;
    String? paying_amount;
    List<Result>? results;
    String? saving;
    bool? status;

    CartListModel({this.delivery_charges, this.gst, this.item_total, this.message, this.mrp, this.paying_amount, this.results, this.saving, this.status});

    factory CartListModel.fromJson(Map<String?, dynamic> json) {
        return CartListModel(
            delivery_charges: json['delivery_charges'], 
            gst: json['gst'], 
            item_total: json['item_total'], 
            message: json['message'], 
            mrp: json['mrp'], 
            paying_amount: json['paying_amount'], 
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null, 
            saving: json['saving'], 
            status: json['status'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['delivery_charges'] = this.delivery_charges;
        data['gst'] = this.gst;
        data['item_total'] = this.item_total;
        data['message'] = this.message;
        data['mrp'] = this.mrp;
        data['paying_amount'] = this.paying_amount;
        data['saving'] = this.saving;
        data['status'] = this.status;
        if (this.results != null) {
            data['results'] = this.results!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}