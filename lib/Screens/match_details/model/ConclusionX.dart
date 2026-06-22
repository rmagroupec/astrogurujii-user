
class ConclusionX {
    bool? match;
    var report;

    ConclusionX({this.match, this.report});

    factory ConclusionX.fromJson(Map<String, dynamic> json) {
        return ConclusionX(
            match: json['match'], 
            report: json['report'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['match'] = this.match;
        data['report'] = this.report;
        return data;
    }
}