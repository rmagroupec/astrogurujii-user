
class YamghantKaal {
    String? end;
    String? start;

    YamghantKaal({this.end, this.start});

    factory YamghantKaal.fromJson(Map<String?, dynamic> json) {
        return YamghantKaal(
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