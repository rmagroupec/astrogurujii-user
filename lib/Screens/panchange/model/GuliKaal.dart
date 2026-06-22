
class GuliKaal {
    String? end;
    String? start;

    GuliKaal({this.end, this.start});

    factory GuliKaal.fromJson(Map<String?, dynamic> json) {
        return GuliKaal(
            end: json['end'], 
            start: json['start'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['end'] = this.end;
        data['start'] = this.start;
        return data;
    }
}