
import 'package:astro_gurujii/Screens/WebServices/model/UserReportList/ReportIntakeForm.dart';

class UserReportListModel {
    String? message;
    List<ReportIntakeForm>? report_intake_form;
    bool? result;

    UserReportListModel({this.message, this.report_intake_form, this.result});

    factory UserReportListModel.fromJson(Map<String, dynamic> json) {
        return UserReportListModel(
            message: json['message'], 
            report_intake_form: json['report_intake_form'] != null ? (json['report_intake_form'] as List).map((i) => ReportIntakeForm.fromJson(i)).toList() : null, 
            result: json['result'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['result'] = this.result;
        if (this.report_intake_form != null) {
            data['report_intake_form'] = this.report_intake_form!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}