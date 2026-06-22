
class Gan {
    var description;
    var female_koot_attribute;
    var male_koot_attribute;
    var received_points;
    var total_points;

    Gan({this.description, this.female_koot_attribute, this.male_koot_attribute, this.received_points, this.total_points});

    factory Gan.fromJson(Map<String, dynamic> json) {
        return Gan(
            description: json['description'], 
            female_koot_attribute: json['female_koot_attribute'], 
            male_koot_attribute: json['male_koot_attribute'], 
            received_points: json['received_points'], 
            total_points: json['total_points'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['description'] = this.description;
        data['female_koot_attribute'] = this.female_koot_attribute;
        data['male_koot_attribute'] = this.male_koot_attribute;
        data['received_points'] = this.received_points;
        data['total_points'] = this.total_points;
        return data;
    }
}