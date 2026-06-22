
class DetailsXXX {
    var meaning;
    var special;
    var yog_name;
    var yog_number;

    DetailsXXX({this.meaning, this.special, this.yog_name, this.yog_number});

    factory DetailsXXX.fromJson(Map<String, dynamic> json) {
        return DetailsXXX(
            meaning: json['meaning'], 
            special: json['special'], 
            yog_name: json['yog_name'], 
            yog_number: json['yog_number'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['meaning'] = this.meaning;
        data['special'] = this.special;
        data['yog_name'] = this.yog_name;
        data['yog_number'] = this.yog_number;
        return data;
    }
}