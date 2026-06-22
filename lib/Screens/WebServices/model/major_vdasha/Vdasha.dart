
class Vdasha {
    String? end;
    String? planet;
    int? planet_id;
    String? start;

    Vdasha({this.end, this.planet, this.planet_id, this.start});

    factory Vdasha.fromJson(Map<String?, dynamic> json) {
        return Vdasha(
            end: json['end'], 
            planet: json['planet'], 
            planet_id: json['planet_id'], 
            start: json['start'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['end'] = this.end;
        data['planet'] = this.planet;
        data['planet_id'] = this.planet_id;
        data['start'] = this.start;
        return data;
    }
}