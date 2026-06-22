
import 'package:astro_gurujii/Screens/panchange/model/DetailsXXX.dart';
import 'package:astro_gurujii/Screens/panchange/model/EndTimeXXX.dart';

class Yog {
    DetailsXXX? details;
    EndTimeXXX? end_time;
    var end_time_ms;

    Yog({this.details, this.end_time, this.end_time_ms});

    factory Yog.fromJson(Map<String, dynamic> json) {
        return Yog(
            details: json['details'] != null ? DetailsXXX.fromJson(json['details']) : null, 
            end_time: json['end_time'] != null ? EndTimeXXX.fromJson(json['end_time']) : null, 
            end_time_ms: json['end_time_ms'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['end_time_ms'] = this.end_time_ms;
        if (this.details != null) {
            data['details'] = this.details!.toJson();
        }
        if (this.end_time != null) {
            data['end_time'] = this.end_time!.toJson();
        }
        return data;
    }
}