
class Geoname {
    var country_code;
    var latitude;
    var longitude;
    var place_name;
    var timezone_id;

    Geoname({this.country_code, this.latitude, this.longitude, this.place_name, this.timezone_id});

    factory Geoname.fromJson(Map<String, dynamic> json) {
        return Geoname(
            country_code: json['country_code'], 
            latitude: json['latitude'], 
            longitude: json['longitude'], 
            place_name: json['place_name'], 
            timezone_id: json['timezone_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['country_code'] = this.country_code;
        data['latitude'] = this.latitude;
        data['longitude'] = this.longitude;
        data['place_name'] = this.place_name;
        data['timezone_id'] = this.timezone_id;
        return data;
    }

    @override
  String toString() {
    return 'Geoname{country_code: $country_code, latitude: $latitude, longitude: $longitude, place_name: $place_name, timezone_id: $timezone_id}';
  }
}