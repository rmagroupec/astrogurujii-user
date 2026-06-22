

import '../../torat/model/Result.dart';

class TarotModel {
    String? message;
    List<Result>? results;
    bool? status;

    TarotModel({this.message, this.results, this.status});

    factory TarotModel.fromJson(Map<String, dynamic> json) {
        return TarotModel(
            message: json['message'], 
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null, 
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