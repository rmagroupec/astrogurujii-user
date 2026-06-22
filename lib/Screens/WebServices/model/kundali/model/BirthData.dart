
class BirthData {
    double? ayanamsha;
    int? day;
    int? hour;
    double? latitude;
    double? longitude;
    int? minute;
    int? month;
    int? seconds;
    String? sunrise;
    String? sunset;
    double? timezone;
    int? year;

    BirthData({this.ayanamsha, this.day, this.hour, this.latitude, this.longitude, this.minute, this.month, this.seconds, this.sunrise, this.sunset, this.timezone, this.year});

    factory BirthData.fromJson(Map<String?, dynamic> json) {
        return BirthData(
            ayanamsha: json['ayanamsha'], 
            day: json['day'], 
            hour: json['hour'], 
            latitude: json['latitude'], 
            longitude: json['longitude'], 
            minute: json['minute'], 
            month: json['month'], 
            seconds: json['seconds'], 
            sunrise: json['sunrise'], 
            sunset: json['sunset'], 
            timezone: json['timezone'], 
            year: json['year'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['ayanamsha'] = this.ayanamsha;
        data['day'] = this.day;
        data['hour'] = this.hour;
        data['latitude'] = this.latitude;
        data['longitude'] = this.longitude;
        data['minute'] = this.minute;
        data['month'] = this.month;
        data['seconds'] = this.seconds;
        data['sunrise'] = this.sunrise;
        data['sunset'] = this.sunset;
        data['timezone'] = this.timezone;
        data['year'] = this.year;
        return data;
    }
}