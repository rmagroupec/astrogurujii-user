
class ManglikPresentRuleX {
    List<String>? based_on_aspect;
    List<String>? based_on_house;

    ManglikPresentRuleX({this.based_on_aspect, this.based_on_house});

    factory ManglikPresentRuleX.fromJson(Map<String, dynamic> json) {
        return ManglikPresentRuleX(
            based_on_aspect: json['based_on_aspect'] != null ? new List<String>.from(json['based_on_aspect']) : null, 
            based_on_house: json['based_on_house'] != null ? new List<String>.from(json['based_on_house']) : null, 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.based_on_aspect != null) {
            data['based_on_aspect'] = this.based_on_aspect;
        }
        if (this.based_on_house != null) {
            data['based_on_house'] = this.based_on_house;
        }
        return data;
    }
}