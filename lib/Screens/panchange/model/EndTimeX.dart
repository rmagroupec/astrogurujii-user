
class EndTimeX {
    var hour;
    var minute;
    var second;

    EndTimeX({this.hour, this.minute, this.second});

    factory EndTimeX.fromJson(Map<String, dynamic> json) {
        return EndTimeX(
            hour: json['hour'], 
            minute: json['minute'], 
            second: json['second'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['hour'] = this.hour;
        data['minute'] = this.minute;
        data['second'] = this.second;
        return data;
    }
}