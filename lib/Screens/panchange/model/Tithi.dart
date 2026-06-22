
import 'package:astro_gurujii/Screens/panchange/model/Details.dart';
import 'package:astro_gurujii/Screens/panchange/model/EndTime.dart';

class Tithi {
    Details? details;
    EndTime? end_time;
    var end_time_ms;

    Tithi({this.details, this.end_time, this.end_time_ms});

    factory Tithi.fromJson(Map<String, dynamic> json) {
        return Tithi(
            details: json['details'] != null ? Details.fromJson(json['details']) : null, 
            end_time: json['end_time'] != null ? EndTime.fromJson(json['end_time']) : null, 
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