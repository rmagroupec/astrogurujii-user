
class Details {
    var deity;
    var special;
    var summary;
    var tithi_name;
    var tithi_number;

    Details({this.deity, this.special, this.summary, this.tithi_name, this.tithi_number});

    factory Details.fromJson(Map<String, dynamic> json) {
        return Details(
            deity: json['deity'], 
            special: json['special'], 
            summary: json['summary'], 
            tithi_name: json['tithi_name'], 
            tithi_number: json['tithi_number'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['deity'] = this.deity;
        data['special'] = this.special;
        data['summary'] = this.summary;
        data['tithi_name'] = this.tithi_name;
        data['tithi_number'] = this.tithi_number;
        return data;
    }
}