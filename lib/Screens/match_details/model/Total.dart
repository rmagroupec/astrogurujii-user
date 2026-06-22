
class Total {
    var minimum_required;
    var received_points;
    var total_points;

    Total({this.minimum_required, this.received_points, this.total_points});

    factory Total.fromJson(Map<String, dynamic> json) {
        return Total(
            minimum_required: json['minimum_required'], 
            received_points: json['received_points'], 
            total_points: json['total_points'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['minimum_required'] = this.minimum_required;
        data['received_points'] = this.received_points;
        data['total_points'] = this.total_points;
        return data;
    }
}