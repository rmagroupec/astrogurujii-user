
class Conclusion {
    var report;
    bool? status;

    Conclusion({this.report, this.status});

    factory Conclusion.fromJson(Map<String, dynamic> json) {
        return Conclusion(
            report: json['report'], 
            status: json['status'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['report'] = this.report;
        data['status'] = this.status;
        return data;
    }
}