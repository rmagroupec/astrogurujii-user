
class FemaleAstroDetails {
    var ayanamsha;
    var day;
    var gender;
    var hour;
    var latitude;
    var longitude;
    var minute;
    var month;
    var sunrise;
    var sunset;
    var timezone;
    var year;

    FemaleAstroDetails({this.ayanamsha, this.day, this.gender, this.hour, this.latitude, this.longitude, this.minute, this.month, this.sunrise, this.sunset, this.timezone, this.year});

    factory FemaleAstroDetails.fromJson(Map<String, dynamic> json) {
        return FemaleAstroDetails(
            ayanamsha: json['ayanamsha'], 
            day: json['day'], 
            gender: json['gender'], 
            hour: json['hour'], 
            latitude: json['latitude'], 
            longitude: json['longitude'], 
            minute: json['minute'], 
            month: json['month'], 
            sunrise: json['sunrise'], 
            sunset: json['sunset'], 
            timezone: json['timezone'], 
            year: json['year'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ayanamsha'] = this.ayanamsha;
        data['day'] = this.day;
        data['gender'] = this.gender;
        data['hour'] = this.hour;
        data['latitude'] = this.latitude;
        data['longitude'] = this.longitude;
        data['minute'] = this.minute;
        data['month'] = this.month;
        data['sunrise'] = this.sunrise;
        data['sunset'] = this.sunset;
        data['timezone'] = this.timezone;
        data['year'] = this.year;
        return data;
    }
}