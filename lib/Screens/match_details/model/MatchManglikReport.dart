
import 'package:astro_gurujii/Screens/match_details/model/ConclusionX.dart';
import 'package:astro_gurujii/Screens/match_details/model/Female.dart';
import 'package:astro_gurujii/Screens/match_details/model/Male.dart';

class MatchManglikReport {
    ConclusionX? conclusion;
    Female? female;
    Male? male;

    MatchManglikReport({this.conclusion, this.female, this.male});

    factory MatchManglikReport.fromJson(Map<String, dynamic> json) {
        return MatchManglikReport(
            conclusion: json['conclusion'] != null ? ConclusionX.fromJson(json['conclusion']) : null, 
            female: json['female'] != null ? Female.fromJson(json['female']) : null, 
            male: json['male'] != null ? Male.fromJson(json['male']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.conclusion != null) {
            data['conclusion'] = this.conclusion!.toJson();
        }
        if (this.female != null) {
            data['female'] = this.female!.toJson();
        }
        if (this.male != null) {
            data['male'] = this.male!.toJson();
        }
        return data;
    }
}