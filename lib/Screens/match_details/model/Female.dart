
import 'package:astro_gurujii/Screens/match_details/model/ManglikPresentRuleX.dart';

class Female {
    bool? is_mars_manglik_cancelled;
    bool? is_present;
    ManglikPresentRuleX? manglik_present_rule;
    var manglik_report;
    var manglik_status;
    var percentage_manglik_after_cancellation;
    var percentage_manglik_present;

    Female({this.is_mars_manglik_cancelled, this.is_present, this.manglik_present_rule, this.manglik_report, this.manglik_status, this.percentage_manglik_after_cancellation, this.percentage_manglik_present});

    factory Female.fromJson(Map<String, dynamic> json) {
        return Female(
            is_mars_manglik_cancelled: json['is_mars_manglik_cancelled'], 
            is_present: json['is_present'],
            manglik_present_rule: json['manglik_present_rule'] != null ? ManglikPresentRuleX.fromJson(json['manglik_present_rule']) : null, 
            manglik_report: json['manglik_report'], 
            manglik_status: json['manglik_status'], 
            percentage_manglik_after_cancellation: json['percentage_manglik_after_cancellation'], 
            percentage_manglik_present: json['percentage_manglik_present'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['is_mars_manglik_cancelled'] = this.is_mars_manglik_cancelled;
        data['is_present'] = this.is_present;
        data['manglik_report'] = this.manglik_report;
        data['manglik_status'] = this.manglik_status;
        data['percentage_manglik_after_cancellation'] = this.percentage_manglik_after_cancellation;
        data['percentage_manglik_present'] = this.percentage_manglik_present;

        if (this.manglik_present_rule != null) {
            data['manglik_present_rule'] = this.manglik_present_rule!.toJson();
        }
        return data;
    }
}