class UserLoginModel {
  bool? status;
  String? token;
  String? message;
  List<Results>? results;

  UserLoginModel({this.status, this.token, this.message, this.results});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? id;
  String? name;
  String? email;
  String? number;
  String? gender;
  String? dob;
  String? birth_place;
  String? birth_time;

  Results({this.gender,this.dob,this.birth_place,this.birth_time,this.id, this.name, this.email, this.number});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    number = json['number'];
    gender = json['gender'];
    dob = json['dob'];
    birth_place = json['birth_place'];
    birth_time = json['birth_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['number'] = this.number;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['birth_place'] = this.birth_place;
    data['birth_time'] = this.birth_time;
    return data;
  }
}