
import 'package:astro_gurujii/Screens/WebServices/model/major_vdasha/Vdasha.dart';

class MajorDashaModel {
    String? message;
    bool? status;
    List<Vdasha>? vdasha;

    MajorDashaModel({this.message, this.status, this.vdasha});

    factory MajorDashaModel.fromJson(Map<String, dynamic> json) {
        return MajorDashaModel(
            message: json['message'], 
            status: json['status'], 
            vdasha: json['vdasha'] != null ? (json['vdasha'] as List).map((i) => Vdasha.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.vdasha != null) {
            data['vdasha'] = this.vdasha!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}