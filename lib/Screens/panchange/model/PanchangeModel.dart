
import 'package:astro_gurujii/Screens/panchange/model/AdvancedPanchang.dart';

class PanchangeModel {
    AdvancedPanchang? advanced_panchang;
    String? message;
    bool? status;

    PanchangeModel({this.advanced_panchang, this.message, this.status});

    factory PanchangeModel.fromJson(Map<String, dynamic> json) {
        return PanchangeModel(
            advanced_panchang: json['advanced_panchang'] != null ? AdvancedPanchang.fromJson(json['advanced_panchang']) : null, 
            message: json['message'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.advanced_panchang != null) {
            data['advanced_panchang'] = this.advanced_panchang!.toJson();
        }
        return data;
    }
}