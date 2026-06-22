
import 'package:astro_gurujii/Screens/WebServices/model/get_daily_horoscope/Prediction.dart';

class Data {
    Prediction? prediction;
    String? sign;

    Data({this.prediction, this.sign});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            prediction: json['prediction'] != null ? Prediction.fromJson(json['prediction']) : null, 
            sign: json['sign'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['sign'] = this.sign;
        if (this.prediction != null) {
            data['prediction'] = this.prediction!.toJson();
        }
        return data;
    }
}