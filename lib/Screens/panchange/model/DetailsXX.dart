
class DetailsXX {
    var deity;
    var karan_name;
    var karan_number;
    var special;

    DetailsXX({this.deity, this.karan_name, this.karan_number, this.special});

    factory DetailsXX.fromJson(Map<String, dynamic> json) {
        return DetailsXX(
            deity: json['deity'], 
            karan_name: json['karan_name'], 
            karan_number: json['karan_number'], 
            special: json['special'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['deity'] = this.deity;
        data['karan_name'] = this.karan_name;
        data['karan_number'] = this.karan_number;
        data['special'] = this.special;
        return data;
    }
}