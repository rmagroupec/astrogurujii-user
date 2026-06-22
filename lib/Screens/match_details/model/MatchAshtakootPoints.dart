
import 'package:astro_gurujii/Screens/match_details/model/Bhakut.dart';
import 'package:astro_gurujii/Screens/match_details/model/Conclusion.dart';
import 'package:astro_gurujii/Screens/match_details/model/Gan.dart';
import 'package:astro_gurujii/Screens/match_details/model/Maitri.dart';
import 'package:astro_gurujii/Screens/match_details/model/Nadi.dart';
import 'package:astro_gurujii/Screens/match_details/model/Tara.dart';
import 'package:astro_gurujii/Screens/match_details/model/TotalX.dart';
import 'package:astro_gurujii/Screens/match_details/model/Varna.dart';
import 'package:astro_gurujii/Screens/match_details/model/VashyaX.dart';
import 'package:astro_gurujii/Screens/match_details/model/YoniX.dart';

class MatchAshtakootPoints {
    Bhakut? bhakut;
    Conclusion? conclusion;
    Gan? gan;
    Maitri? maitri;
    Nadi? nadi;
    Tara? tara;
    TotalX? total;
    Varna? varna;
    VashyaX? vashya;
    YoniX? yoni;

    MatchAshtakootPoints({this.bhakut, this.conclusion, this.gan, this.maitri, this.nadi, this.tara, this.total, this.varna, this.vashya, this.yoni});

    factory MatchAshtakootPoints.fromJson(Map<String, dynamic> json) {
        return MatchAshtakootPoints(
            bhakut: json['bhakut'] != null ? Bhakut.fromJson(json['bhakut']) : null, 
            conclusion: json['conclusion'] != null ? Conclusion.fromJson(json['conclusion']) : null, 
            gan: json['gan'] != null ? Gan.fromJson(json['gan']) : null, 
            maitri: json['maitri'] != null ? Maitri.fromJson(json['maitri']) : null, 
            nadi: json['nadi'] != null ? Nadi.fromJson(json['nadi']) : null, 
            tara: json['tara'] != null ? Tara.fromJson(json['tara']) : null, 
            total: json['total'] != null ? TotalX.fromJson(json['total']) : null, 
            varna: json['varna'] != null ? Varna.fromJson(json['varna']) : null, 
            vashya: json['vashya'] != null ? VashyaX.fromJson(json['vashya']) : null, 
            yoni: json['yoni'] != null ? YoniX.fromJson(json['yoni']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.bhakut != null) {
            data['bhakut'] = this.bhakut!.toJson();
        }
        if (this.conclusion != null) {
            data['conclusion'] = this.conclusion!.toJson();
        }
        if (this.gan != null) {
            data['gan'] = this.gan!.toJson();
        }
        if (this.maitri != null) {
            data['maitri'] = this.maitri!.toJson();
        }
        if (this.nadi != null) {
            data['nadi'] = this.nadi!.toJson();
        }
        if (this.tara != null) {
            data['tara'] = this.tara!.toJson();
        }
        if (this.total != null) {
            data['total'] = this.total!.toJson();
        }
        if (this.varna != null) {
            data['varna'] = this.varna!.toJson();
        }
        if (this.vashya != null) {
            data['vashya'] = this.vashya!.toJson();
        }
        if (this.yoni != null) {
            data['yoni'] = this.yoni!.toJson();
        }
        return data;
    }
}