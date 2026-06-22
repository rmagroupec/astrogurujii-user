
import 'package:astro_gurujii/Screens/match_details/model/MatchAshtakootPoints.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchAstroDetails.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchBirthDetails.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchDashakootPoints.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchManglikReport.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchPlanetDetails.dart';

class MatchingDetails {
    MatchAshtakootPoints? match_ashtakoot_points;
    MatchAstroDetails? match_astro_details;
    MatchBirthDetails? match_birth_details;
    MatchDashakootPoints? match_dashakoot_points;
    MatchManglikReport? match_manglik_report;
    MatchPlanetDetails? match_planet_details;
    String? message;
    bool? status;

    MatchingDetails({this.match_ashtakoot_points, this.match_astro_details, this.match_birth_details, this.match_dashakoot_points, this.match_manglik_report, this.match_planet_details, this.message, this.status});

    factory MatchingDetails.fromJson(Map<String, dynamic> json) {
        return MatchingDetails(
            match_ashtakoot_points: json['match_ashtakoot_points'] != null ? MatchAshtakootPoints.fromJson(json['match_ashtakoot_points']) : null, 
            match_astro_details: json['match_astro_details'] != null ? MatchAstroDetails.fromJson(json['match_astro_details']) : null, 
            match_birth_details: json['match_birth_details'] != null ? MatchBirthDetails.fromJson(json['match_birth_details']) : null, 
            match_dashakoot_points: json['match_dashakoot_points'] != null ? MatchDashakootPoints.fromJson(json['match_dashakoot_points']) : null, 
            match_manglik_report: json['match_manglik_report'] != null ? MatchManglikReport.fromJson(json['match_manglik_report']) : null, 
            match_planet_details: json['match_planet_details'] != null ? MatchPlanetDetails.fromJson(json['match_planet_details']) : null, 
            message: json['message'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.match_ashtakoot_points != null) {
            data['match_ashtakoot_points'] = this.match_ashtakoot_points!.toJson();
        }
        if (this.match_astro_details != null) {
            data['match_astro_details'] = this.match_astro_details!.toJson();
        }
        if (this.match_birth_details != null) {
            data['match_birth_details'] = this.match_birth_details!.toJson();
        }
        if (this.match_dashakoot_points != null) {
            data['match_dashakoot_points'] = this.match_dashakoot_points!.toJson();
        }
        if (this.match_manglik_report != null) {
            data['match_manglik_report'] = this.match_manglik_report!.toJson();
        }
        if (this.match_planet_details != null) {
            data['match_planet_details'] = this.match_planet_details!.toJson();
        }
        return data;
    }
}