
import 'package:astro_gurujii/Screens/WebServices/model/transaction/Data.dart';

class Transactions {
    List<Data>? data;

    Transactions({this.data});

    factory Transactions.fromJson(Map<String, dynamic> json) {
        return Transactions(
            data: json['data'] != null ? (json['data'] as List).map((i) => Data.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.data != null) {
            data['data'] = this.data!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}