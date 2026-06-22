class CheckNumberModel {
  bool? status;
  String? token;
  String? message;
  Results? results;
  String? type;

  CheckNumberModel(
      {this.status, this.token, this.message, this.results, this.type});

  CheckNumberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Results {
  String? id;
  String? name;
  String? email;
  String? number;
  String? profileImg;
  String? gender;
  String? dob;
  String? referCode;
  String? birthPlace;
  String? birthTime;

  Results(
      {this.id,
        this.name,
        this.email,
        this.number,
        this.profileImg,
        this.gender,
        this.dob,
        this.referCode,
        this.birthPlace,
        this.birthTime});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    number = json['number'];
    profileImg = json['profile_img'];
    gender = json['gender'];
    dob = json['dob'];
    referCode = json['refer_code'];
    birthPlace = json['birth_place'];
    birthTime = json['birth_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['number'] = this.number;
    data['profile_img'] = this.profileImg;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['refer_code'] = this.referCode;
    data['birth_place'] = this.birthPlace;
    data['birth_time'] = this.birthTime;
    return data;
  }
}
