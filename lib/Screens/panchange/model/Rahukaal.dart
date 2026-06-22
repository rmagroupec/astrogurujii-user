
class Rahukaal {
    String? end;
    String? start;

    Rahukaal({this.end, this.start});

    factory Rahukaal.fromJson(Map<String?, dynamic> json) {
        return Rahukaal(
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