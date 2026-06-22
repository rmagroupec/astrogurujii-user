
import '../../../WebServices/model/setting/Results.dart';

class SettingModel {
    String? message;
    Results? results;
    bool? status;

    SettingModel({this.message, this.results, this.status});

    factory SettingModel.fromJson(Map<String, dynamic> json) {
        return SettingModel(
            message: json['message'], 
            results: json['results'] != null ? Results.fromJson(json['results']) : null, 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.results != null) {
            data['results'] = this.results!.toJson();
        }
        return data;
    }
}