
import 'package:astro_gurujii/Screens/match_details/model/FemaleAstroDetails.dart';
import 'package:astro_gurujii/Screens/match_details/model/MaleAstroDetails.dart';

class MatchBirthDetails {
    FemaleAstroDetails? female_astro_details;
    MaleAstroDetails? male_astro_details;

    MatchBirthDetails({this.female_astro_details, this.male_astro_details});

    factory MatchBirthDetails.fromJson(Map<String, dynamic> json) {
        return MatchBirthDetails(
            female_astro_details: json['female_astro_details'] != null ? FemaleAstroDetails.fromJson(json['female_astro_details']) : null, 
            male_astro_details: json['male_astro_details'] != null ? MaleAstroDetails.fromJson(json['male_astro_details']) : null, 
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