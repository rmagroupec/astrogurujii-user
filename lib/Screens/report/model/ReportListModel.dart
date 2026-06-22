
import '../../report/model/Result.dart';

class ReportListModel {
    String? message;
    List<Result>? results;
    bool? status;

    ReportListModel({this.message, this.results, this.status});

    factory ReportListModel.fromJson(Map<String, dynamic> json) {
        return ReportListModel(
            message: json['message'], 
            results: json['results'] != null ? (json['results'] as List).map((i) => Result.fromJson(i)).toList() : null, 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        if (this.results != null) {
            data['results'] = this.results!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}