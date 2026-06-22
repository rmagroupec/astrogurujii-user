
import 'package:astro_gurujii/Screens/panchange/model/AbhijitMuhurta.dart';
import 'package:astro_gurujii/Screens/panchange/model/GuliKaal.dart';
import 'package:astro_gurujii/Screens/panchange/model/HinduMaah.dart';
import 'package:astro_gurujii/Screens/panchange/model/Karan.dart';
import 'package:astro_gurujii/Screens/panchange/model/NakShool.dart';
import 'package:astro_gurujii/Screens/panchange/model/Nakshatra.dart';
import 'package:astro_gurujii/Screens/panchange/model/Rahukaal.dart';
import 'package:astro_gurujii/Screens/panchange/model/Tithi.dart';
import 'package:astro_gurujii/Screens/panchange/model/YamghantKaal.dart';
import 'package:astro_gurujii/Screens/panchange/model/Yog.dart';

class AdvancedPanchang {
    AbhijitMuhurta? abhijit_muhurta;
    var ayana;
    var day;
    var disha_shool;
    var disha_shool_remedies;
    GuliKaal? guliKaal;
    HinduMaah? hindu_maah;
    Karan? karan;
    var moon_nivas;
    var moon_sign;
    var moonrise;
    var moonset;
    NakShool? nak_shool;
    Nakshatra? nakshatra;
    var paksha;
    var panchang_yog;
    Rahukaal? rahukaal;
    var ritu;
    var shaka_samvat;
    var shaka_samvat_name;
    var sun_sign;
    var sunrise;
    var sunset;
    Tithi? tithi;
    var vedic_sunrise;
    var vedic_sunset;
    var vikram_samvat;
    var vkram_samvat_name;
    YamghantKaal? yamghant_kaal;
    Yog? yog;

    AdvancedPanchang({this.abhijit_muhurta, this.ayana, this.day, this.disha_shool, this.disha_shool_remedies, this.guliKaal, this.hindu_maah, this.karan, this.moon_nivas, this.moon_sign, this.moonrise, this.moonset, this.nak_shool, this.nakshatra, this.paksha, this.panchang_yog, this.rahukaal, this.ritu, this.shaka_samvat, this.shaka_samvat_name, this.sun_sign, this.sunrise, this.sunset, this.tithi, this.vedic_sunrise, this.vedic_sunset, this.vikram_samvat, this.vkram_samvat_name, this.yamghant_kaal, this.yog});

    factory AdvancedPanchang.fromJson(Map<String, dynamic> json) {
        return AdvancedPanchang(
            abhijit_muhurta: json['abhijit_muhurta'] != null ? AbhijitMuhurta.fromJson(json['abhijit_muhurta']) : null, 
            ayana: json['ayana'], 
            day: json['day'], 
            disha_shool: json['disha_shool'], 
            disha_shool_remedies: json['disha_shool_remedies'], 
            guliKaal: json['guliKaal'] != null ? GuliKaal.fromJson(json['guliKaal']) : null, 
            hindu_maah: json['hindu_maah'] != null ? HinduMaah.fromJson(json['hindu_maah']) : null, 
            karan: json['karan'] != null ? Karan.fromJson(json['karan']) : null,
            moon_nivas: json['moon_nivas'], 
            moon_sign: json['moon_sign'], 
            moonrise: json['moonrise'], 
            moonset: json['moonset'], 
            nak_shool: json['nak_shool'] != null ? NakShool.fromJson(json['nak_shool']) : null, 
            nakshatra: json['nakshatra'] != null ? Nakshatra.fromJson(json['nakshatra']) : null, 
            paksha: json['paksha'], 
            panchang_yog: json['panchang_yog'], 
            rahukaal: json['rahukaal'] != null ? Rahukaal.fromJson(json['rahukaal']) : null, 
            ritu: json['ritu'], 
            shaka_samvat: json['shaka_samvat'], 
            shaka_samvat_name: json['shaka_samvat_name'], 
            sun_sign: json['sun_sign'], 
            sunrise: json['sunrise'], 
            sunset: json['sunset'], 
            tithi: json['tithi'] != null ? Tithi.fromJson(json['tithi']) : null, 
            vedic_sunrise: json['vedic_sunrise'], 
            vedic_sunset: json['vedic_sunset'], 
            vikram_samvat: json['vikram_samvat'], 
            vkram_samvat_name: json['vkram_samvat_name'], 
            yamghant_kaal: json['yamghant_kaal'] != null ? YamghantKaal.fromJson(json['yamghant_kaal']) : null, 
            yog: json['yog'] != null ? Yog.fromJson(json['yog']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ayana'] = this.ayana;
        data['day'] = this.day;
        data['disha_shool'] = this.disha_shool;
        data['disha_shool_remedies'] = this.disha_shool_remedies;
        data['moon_nivas'] = this.moon_nivas;
        data['moon_sign'] = this.moon_sign;
        data['moonrise'] = this.moonrise;
        data['moonset'] = this.moonset;
        data['paksha'] = this.paksha;
        data['panchang_yog'] = this.panchang_yog;
        data['ritu'] = this.ritu;
        data['shaka_samvat'] = this.shaka_samvat;
        data['shaka_samvat_name'] = this.shaka_samvat_name;
        data['sun_sign'] = this.sun_sign;
        data['sunrise'] = this.sunrise;
        data['sunset'] = this.sunset;
        data['vedic_sunrise'] = this.vedic_sunrise;
        data['vedic_sunset'] = this.vedic_sunset;
        data['vikram_samvat'] = this.vikram_samvat;
        data['vkram_samvat_name'] = this.vkram_samvat_name;
        if (this.abhijit_muhurta != null) {
            data['abhijit_muhurta'] = this.abhijit_muhurta!.toJson();
        }
        if (this.guliKaal != null) {
            data['guliKaal'] = this.guliKaal!.toJson();
        }
        if (this.hindu_maah != null) {
            data['hindu_maah'] = this.hindu_maah!.toJson();
        }
        if (this.karan != null) {
            data['karan'] = this.karan!.toJson();
        }
        if (this.nak_shool != null) {
            data['nak_shool'] = this.nak_shool!.toJson();
        }
        if (this.nakshatra != null) {
            data['nakshatra'] = this.nakshatra!.toJson();
        }
        if (this.rahukaal != null) {
            data['rahukaal'] = this.rahukaal!.toJson();
        }
        if (this.tithi != null) {
            data['tithi'] = this.tithi!.toJson();
        }
        if (this.yamghant_kaal != null) {
            data['yamghant_kaal'] = this.yamghant_kaal!.toJson();
        }
        if (this.yog != null) {
            data['yog'] = this.yog!.toJson();
        }
        return data;
    }
}