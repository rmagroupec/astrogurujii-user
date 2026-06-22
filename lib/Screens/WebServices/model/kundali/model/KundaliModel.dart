

import 'AstroDetail.dart';
import 'BasicPanchang.dart';
import 'BirthData.dart';
import 'Planet.dart';

class KundaliModel {
    List<AstroDetail>? astro_details;
    List<BasicPanchang>? basic_panchang;
    List<BirthData>? birth_data;
    String? chalit;
    String? mOON;
    String? message;
    var id;
    List<Planet>? planets;
    String? sUN;
    bool? status;
    bool? result;

    KundaliModel({this.result,this.id,this.astro_details, this.basic_panchang, this.birth_data, this.chalit, this.mOON, this.message, this.planets, this.sUN, this.status});

    factory KundaliModel.fromJson(Map<String?, dynamic> json) {
        return KundaliModel(
            astro_details: json['astro_details'] != null ? (json['astro_details'] as List).map((i) => AstroDetail.fromJson(i)).toList() : null, 
            basic_panchang: json['basic_panchang'] != null ? (json['basic_panchang'] as List).map((i) => BasicPanchang.fromJson(i)).toList() : null, 
            birth_data: json['birth_data'] != null ? (json['birth_data'] as List).map((i) => BirthData.fromJson(i)).toList() : null, 
            chalit: json['chalit'], 
            mOON: json['MOON'],
            id: json['id'],
            message: json['message'],
            planets: json['planets'] != null ? (json['planets'] as List).map((i) => Planet.fromJson(i)).toList() : null, 
            sUN: json['SUN'],
            status: json['status'],
            result: json['result'],
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['result'] = this.result;
        data['chalit'] = this.chalit;
        data['MOON'] = this.mOON;
        data['message'] = this.message;
        data['id'] = this.id;
        data['SUN'] = this.sUN;
        data['status'] = this.status;
        if (this.astro_details != null) {
            data['astro_details'] = this.astro_details!.map((v) => v.toJson()).toList();
        }
        if (this.basic_panchang != null) {
            data['basic_panchang'] = this.basic_panchang!.map((v) => v.toJson()).toList();
        }
        if (this.birth_data != null) {
            data['birth_data'] = this.birth_data!.map((v) => v.toJson()).toList();
        }
        if (this.planets != null) {
            data['planets'] = this.planets!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}