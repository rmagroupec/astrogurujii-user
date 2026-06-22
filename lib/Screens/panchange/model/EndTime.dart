
class EndTime {
    var hour;
    var minute;
    var second;

    EndTime({this.hour, this.minute, this.second});

    factory EndTime.fromJson(Map<String, dynamic> json) {
        return EndTime(
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