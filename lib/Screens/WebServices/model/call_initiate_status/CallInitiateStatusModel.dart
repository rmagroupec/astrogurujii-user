
import 'package:astro_gurujii/Screens/WebServices/model/call_initiate_status/Results.dart';

class CallInitiateStatusModel {
    String? message;
    StatusResults? results;
    bool? status;

    CallInitiateStatusModel({this.message, this.results, this.status});

    factory CallInitiateStatusModel.fromJson(Map<String, dynamic> json) {
        return CallInitiateStatusModel(
            message: json['message'], 
            results: json['results'] != null ? StatusResults.fromJson(json['results']) : null,
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