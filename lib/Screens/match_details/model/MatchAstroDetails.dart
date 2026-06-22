
import 'package:astro_gurujii/Screens/match_details/model/FemaleAstroDetailsX.dart';
import 'package:astro_gurujii/Screens/match_details/model/MaleAstroDetailsX.dart';

class MatchAstroDetails {
    FemaleAstroDetailsX? female_astro_details;
    MaleAstroDetailsX? male_astro_details;

    MatchAstroDetails({this.female_astro_details, this.male_astro_details});

    factory MatchAstroDetails.fromJson(Map<String, dynamic> json) {
        return MatchAstroDetails(
            female_astro_details: json['female_astro_details'] != null ? FemaleAstroDetailsX.fromJson(json['female_astro_details']) : null, 
            male_astro_details: json['male_astro_details'] != null ? MaleAstroDetailsX.fromJson(json['male_astro_details']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.female_astro_details != null) {
            data['female_astro_details'] = this.female_astro_details!.toJson();
        }
        if (this.male_astro_details != null) {
            data['male_astro_details'] = this.male_astro_details!.toJson();
        }
        return data;
    }
}