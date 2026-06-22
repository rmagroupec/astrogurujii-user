
class NumeroReport {
    String? description;
    String? title;

    NumeroReport({this.description, this.title});

    factory NumeroReport.fromJson(Map<String?, dynamic> json) {
        return NumeroReport(
            description: json['description'], 
            title: json['title'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['description'] = this.description;
        data['title'] = this.title;
        return data;
    }
}