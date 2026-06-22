
class DetailsX {
    var deity;
    var nak_name;
    var nak_number;
    var ruler;
    var special;
    var summary;

    DetailsX({this.deity, this.nak_name, this.nak_number, this.ruler, this.special, this.summary});

    factory DetailsX.fromJson(Map<String, dynamic> json) {
        return DetailsX(
            deity: json['deity'], 
            nak_name: json['nak_name'], 
            nak_number: json['nak_number'], 
            ruler: json['ruler'], 
            special: json['special'], 
            summary: json['summary'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['deity'] = this.deity;
        data['nak_name'] = this.nak_name;
        data['nak_number'] = this.nak_number;
        data['ruler'] = this.ruler;
        data['special'] = this.special;
        data['summary'] = this.summary;
        return data;
    }
}