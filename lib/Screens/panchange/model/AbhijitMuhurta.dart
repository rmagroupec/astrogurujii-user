
class AbhijitMuhurta {
    var end;
    var start;

    AbhijitMuhurta({this.end, this.start});

    factory AbhijitMuhurta.fromJson(Map<String, dynamic> json) {
        return AbhijitMuhurta(
            end: json['end'], 
            start: json['start'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['end'] = this.end;
        data['start'] = this.start;
        return data;
    }
}