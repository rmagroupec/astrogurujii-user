
import 'package:astro_gurujii/Screens/WebServices/model/get_daily_horoscope/Prediction.dart';

class GetDailyHoroscopeModel {
  Prediction? prediction;
  String? message;
  var status;

  GetDailyHoroscopeModel({this.prediction, this.message, this.status});

  factory GetDailyHoroscopeModel.fromJson(Map<String, dynamic> json) {
    return GetDailyHoroscopeModel(
      prediction: json['prediction'] != null
          ? Prediction.fromJson(json['prediction'])
          : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.prediction != null) {
      data['prediction'] = this.prediction!.toJson();
    }
    return data;
  }
}
