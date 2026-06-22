
import 'package:astro_gurujii/Screens/WebServices/model/transaction/Transactions.dart';

class TransactionModel {
    String? message;
    bool? result;
    Transactions? transactions;

    TransactionModel({this.message, this.result, this.transactions});

    factory TransactionModel.fromJson(Map<String, dynamic> json) {
        return TransactionModel(
            message: json['message'], 
            result: json['result'], 
            transactions: json['transactions'] != null ? Transactions.fromJson(json['transactions']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['result'] = this.result;
        if (this.transactions != null) {
            data['transactions'] = this.transactions!.toJson();
        }
        return data;
    }
}