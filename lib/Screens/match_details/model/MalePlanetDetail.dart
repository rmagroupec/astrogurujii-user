
class MalePlanetDetail {
    var fullDegree;
    var house;
    var id;
    var isRetro;
    var is_planet_set;
    var nakshatra;
    var nakshatraLord;
    var nakshatra_pad;
    var name;
    var normDegree;
    var planet_awastha;
    var sign;
    var signLord;
    var speed;

    MalePlanetDetail({this.fullDegree, this.house, this.id, this.isRetro, this.is_planet_set, this.nakshatra, this.nakshatraLord, this.nakshatra_pad, this.name, this.normDegree, this.planet_awastha, this.sign, this.signLord, this.speed});

    factory MalePlanetDetail.fromJson(Map<String, dynamic> json) {
        return MalePlanetDetail(
            fullDegree: json['fullDegree'], 
            house: json['house'], 
            id: json['id'], 
            isRetro: json['isRetro'], 
            is_planet_set: json['is_planet_set'], 
            nakshatra: json['nakshatra'], 
            nakshatraLord: json['nakshatraLord'], 
            nakshatra_pad: json['nakshatra_pad'], 
            name: json['name'], 
            normDegree: json['normDegree'], 
            planet_awastha: json['planet_awastha'], 
            sign: json['sign'], 
            signLord: json['signLord'], 
            speed: json['speed'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['fullDegree'] = this.fullDegree;
        data['house'] = this.house;
        data['id'] = this.id;
        data['isRetro'] = this.isRetro;
        data['is_planet_set'] = this.is_planet_set;
        data['nakshatra'] = this.nakshatra;
        data['nakshatraLord'] = this.nakshatraLord;
        data['nakshatra_pad'] = this.nakshatra_pad;
        data['name'] = this.name;
        data['normDegree'] = this.normDegree;
        data['planet_awastha'] = this.planet_awastha;
        data['sign'] = this.sign;
        data['signLord'] = this.signLord;
        data['speed'] = this.speed;
        return data;
    }
}