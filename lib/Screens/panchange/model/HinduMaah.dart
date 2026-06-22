
class HinduMaah {
    var adhik_status;
    var amanta;
    var amanta_id;
    var purnimanta;
    var purnimanta_id;

    HinduMaah({this.adhik_status, this.amanta, this.amanta_id, this.purnimanta, this.purnimanta_id});

    factory HinduMaah.fromJson(Map<String, dynamic> json) {
        return HinduMaah(
            adhik_status: json['adhik_status'], 
            amanta: json['amanta'], 
            amanta_id: json['amanta_id'], 
            purnimanta: json['purnimanta'], 
            purnimanta_id: json['purnimanta_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['adhik_status'] = this.adhik_status;
        data['amanta'] = this.amanta;
        data['amanta_id'] = this.amanta_id;
        data['purnimanta'] = this.purnimanta;
        data['purnimanta_id'] = this.purnimanta_id;
        return data;
    }
}