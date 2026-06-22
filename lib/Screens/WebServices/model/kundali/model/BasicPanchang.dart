
class BasicPanchang {
    String? day;
    String? karan;
    String? nakshatra;
    String? sunrise;
    String? sunset;
    String? tithi;
    String? vedic_sunrise;
    String? vedic_sunset;
    String? yog;

    BasicPanchang({this.day, this.karan, this.nakshatra, this.sunrise, this.sunset, this.tithi, this.vedic_sunrise, this.vedic_sunset, this.yog});

    factory BasicPanchang.fromJson(Map<String?, dynamic> json) {
        return BasicPanchang(
            day: json['day'], 
            karan: json['karan'], 
            nakshatra: json['nakshatra'], 
            sunrise: json['sunrise'], 
            sunset: json['sunset'], 
            tithi: json['tithi'], 
            vedic_sunrise: json['vedic_sunrise'], 
            vedic_sunset: json['vedic_sunset'], 
            yog: json['yog'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['day'] = this.day;
        data['karan'] = this.karan;
        data['nakshatra'] = this.nakshatra;
        data['sunrise'] = this.sunrise;
        data['sunset'] = this.sunset;
        data['tithi'] = this.tithi;
        data['vedic_sunrise'] = this.vedic_sunrise;
        data['vedic_sunset'] = this.vedic_sunset;
        data['yog'] = this.yog;
        return data;
    }
}