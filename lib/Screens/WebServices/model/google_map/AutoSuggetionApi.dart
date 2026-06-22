
import 'package:astro_gurujii/Screens/WebServices/model/google_map/Prediction.dart';

class AutoSuggetionApi {
    List<Prediction>? predictions;
    String? status;

    AutoSuggetionApi({required this.predictions, required this.status});

    factory AutoSuggetionApi.fromJson(Map<String, dynamic> json) {
        return AutoSuggetionApi(
            predictions: json['predictions'] != null ? (json['predictions'] as List).map((i) => Prediction.fromJson(i)).toList() : null, 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
        if (this.predictions != null) {
            data['predictions'] = this.predictions!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}