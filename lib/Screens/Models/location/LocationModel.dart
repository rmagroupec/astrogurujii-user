
import 'package:astro_gurujii/Screens/Models/location/Geoname.dart';

class LocationModel {
    List<Error>? error;
    List<Geoname>? geonames;
    String? msg;
    bool? status;

    LocationModel({this.error, this.geonames, this.msg, this.status});

    factory LocationModel.fromJson(Map<String, dynamic> json) {
        return LocationModel(
            geonames: json['geonames'] != null ? (json['geonames'] as List).map((i) => Geoname.fromJson(i)).toList() : null,
            msg: json['msg'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['msg'] = this.msg;
        data['status'] = this.status;
        if (this.geonames != null) {
            data['geonames'] = this.geonames!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}