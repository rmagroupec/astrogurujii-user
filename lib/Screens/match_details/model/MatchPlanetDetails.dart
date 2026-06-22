
import 'package:astro_gurujii/Screens/match_details/model/FemalePlanetDetail.dart';
import 'package:astro_gurujii/Screens/match_details/model/MalePlanetDetail.dart';

class MatchPlanetDetails {
    List<FemalePlanetDetail>? female_planet_details;
    List<MalePlanetDetail>? male_planet_details;

    MatchPlanetDetails({this.female_planet_details, this.male_planet_details});

    factory MatchPlanetDetails.fromJson(Map<String, dynamic> json) {
        return MatchPlanetDetails(
            female_planet_details: json['female_planet_details'] != null ? (json['female_planet_details'] as List).map((i) => FemalePlanetDetail.fromJson(i)).toList() : null, 
            male_planet_details: json['male_planet_details'] != null ? (json['male_planet_details'] as List).map((i) => MalePlanetDetail.fromJson(i)).toList() : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.female_planet_details != null) {
            data['female_planet_details'] = this.female_planet_details!.map((v) => v.toJson()).toList();
        }
        if (this.male_planet_details != null) {
            data['male_planet_details'] = this.male_planet_details!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}