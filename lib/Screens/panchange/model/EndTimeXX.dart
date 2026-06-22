
class EndTimeXX {
    var hour;
    var minute;
    var second;

    EndTimeXX({this.hour, this.minute, this.second});

    factory EndTimeXX.fromJson(Map<String, dynamic> json) {
        return EndTimeXX(
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