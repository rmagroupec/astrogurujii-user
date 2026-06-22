
class NakShool {
    String? direction;
    String? remedies;

    NakShool({this.direction, this.remedies});

    factory NakShool.fromJson(Map<String?, dynamic> json) {
        return NakShool(
            direction: json['direction'], 
            remedies: json['remedies'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['direction'] = this.direction;
        data['remedies'] = this.remedies;
        return data;
    }
}