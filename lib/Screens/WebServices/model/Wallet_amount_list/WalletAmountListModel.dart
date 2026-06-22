
import '../Wallet_amount_list/Result.dart';

class WalletAmountListModel {
    String? message;
    List<Resultss>? results;
    bool? status;

    WalletAmountListModel({this.message, this.results, this.status});

    factory WalletAmountListModel.fromJson(Map<String, dynamic> json) {
        return WalletAmountListModel(
            message: json['message'], 
            results: json['results'] != null ? (json['results'] as List).map((i) => Resultss.fromJson(i)).toList() : null,
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.results != null) {
            data['results'] = this.results!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}