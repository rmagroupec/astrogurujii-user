
import 'package:astro_gurujii/Screens/match_details/model/Dina.dart';
import 'package:astro_gurujii/Screens/match_details/model/Gana.dart';
import 'package:astro_gurujii/Screens/match_details/model/Mahendra.dart';
import 'package:astro_gurujii/Screens/match_details/model/Rajju.dart';
import 'package:astro_gurujii/Screens/match_details/model/Rashi.dart';
import 'package:astro_gurujii/Screens/match_details/model/Rasyadhipati.dart';
import 'package:astro_gurujii/Screens/match_details/model/StreeDeergha.dart';
import 'package:astro_gurujii/Screens/match_details/model/Total.dart';
import 'package:astro_gurujii/Screens/match_details/model/Vashya.dart';
import 'package:astro_gurujii/Screens/match_details/model/Vedha.dart';
import 'package:astro_gurujii/Screens/match_details/model/Yoni.dart';

class MatchDashakootPoints {
    Dina? dina;
    Gana? gana;
    Mahendra? mahendra;
    Rajju? rajju;
    Rashi? rashi;
    Rasyadhipati? rasyadhipati;
    StreeDeergha? streeDeergha;
    Total? total;
    Vashya? vashya;
    Vedha? vedha;
    Yoni? yoni;

    MatchDashakootPoints({this.dina, this.gana, this.mahendra, this.rajju, this.rashi, this.rasyadhipati, this.streeDeergha, this.total, this.vashya, this.vedha, this.yoni});

    factory MatchDashakootPoints.fromJson(Map<String, dynamic> json) {
        return MatchDashakootPoints(
            dina: json['dina'] != null ? Dina.fromJson(json['dina']) : null, 
            gana: json['gana'] != null ? Gana.fromJson(json['gana']) : null, 
            mahendra: json['mahendra'] != null ? Mahendra.fromJson(json['mahendra']) : null, 
            rajju: json['rajju'] != null ? Rajju.fromJson(json['rajju']) : null, 
            rashi: json['rashi'] != null ? Rashi.fromJson(json['rashi']) : null, 
            rasyadhipati: json['rasyadhipati'] != null ? Rasyadhipati.fromJson(json['rasyadhipati']) : null, 
            streeDeergha: json['streeDeergha'] != null ? StreeDeergha.fromJson(json['streeDeergha']) : null, 
            total: json['total'] != null ? Total.fromJson(json['total']) : null, 
            vashya: json['vashya'] != null ? Vashya.fromJson(json['vashya']) : null, 
            vedha: json['vedha'] != null ? Vedha.fromJson(json['vedha']) : null, 
            yoni: json['yoni'] != null ? Yoni.fromJson(json['yoni']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.dina != null) {
            data['dina'] = this.dina!.toJson();
        }
        if (this.gana != null) {
            data['gana'] = this.gana!.toJson();
        }
        if (this.mahendra != null) {
            data['mahendra'] = this.mahendra!.toJson();
        }
        if (this.rajju != null) {
            data['rajju'] = this.rajju!.toJson();
        }
        if (this.rashi != null) {
            data['rashi'] = this.rashi!.toJson();
        }
        if (this.rasyadhipati != null) {
            data['rasyadhipati'] = this.rasyadhipati!.toJson();
        }
        if (this.streeDeergha != null) {
            data['streeDeergha'] = this.streeDeergha!.toJson();
        }
        if (this.total != null) {
            data['total'] = this.total!.toJson();
        }
        if (this.vashya != null) {
            data['vashya'] = this.vashya!.toJson();
        }
        if (this.vedha != null) {
            data['vedha'] = this.vedha!.toJson();
        }
        if (this.yoni != null) {
            data['yoni'] = this.yoni!.toJson();
        }
        return data;
    }
}