
class LatiduseModels {
    var lat;
    var lng;

    LatiduseModels({this.lat, this.lng});

    factory LatiduseModels.fromJson(Map<String, dynamic> json) {
        return LatiduseModels(
            lat: json['lat'], 
            lng: json['lng'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['lat'] = this.lat;
        data['lng'] = this.lng;
        return data;
    }
}