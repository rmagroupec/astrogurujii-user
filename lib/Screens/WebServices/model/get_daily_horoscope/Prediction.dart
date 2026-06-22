
class Prediction {
  String? emotions;
  String? health;
  String? luck;
  String? personal;
  String? profession;
  String? travel;

  Prediction(
      {this.emotions,
      this.health,
      this.luck,
      this.personal,
      this.profession,
      this.travel});

  factory Prediction.fromJson(Map<String?, dynamic> json) {
    return Prediction(
      emotions: json['emotions'],
      health: json['health'],
      luck: json['luck'],
      personal: json['personal_life'],
      profession: json['profession'],
      travel: json['travel'],
    );
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['emotions'] = this.emotions;
    data['health'] = this.health;
    data['personal_life'] = this.personal;
    data['profession'] = this.profession;
    data['travel'] = this.travel;
    data['luck'] = this.luck;

    return data;
  }
}
