
import 'package:astro_gurujii/Screens/panchange/model/DetailsXX.dart';
import 'package:astro_gurujii/Screens/panchange/model/EndTimeXX.dart';

class Karan {
    DetailsXX? details;
    EndTimeXX? end_time;
    var end_time_ms;

    Karan({this.details, this.end_time, this.end_time_ms});

    factory Karan.fromJson(Map<String, dynamic> json) {
        return Karan(
            details: json['details'] != null ? DetailsXX.fromJson(json['details']) : null, 
            end_time: json['end_time'] != null ? EndTimeXX.fromJson(json['end_time']) : null, 
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