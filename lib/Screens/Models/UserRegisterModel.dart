class UserRegisterModel {
  bool? status;
  String? token;
  String? message;
  Results? results;

  UserRegisterModel({this.status, this.token, this.message, this.results});

  UserRegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    results =
    json['results'] != null ? new Results.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

/*
var gender=prefs?.getString('gender');
var dob=prefs?.getString('dob');
var birth_place=prefs?.getString('birth_place');
var birth_time=prefs?.getString('birth_time');

*/

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
    birth_place = json['place_of_birth'];
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
    data['place_of_birth'] = this.birth_place;
    data['birth_time'] = this.birth_time;
    return data;
  }
}