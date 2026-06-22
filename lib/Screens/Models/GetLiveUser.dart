class GetLiveUser {
  bool? success;
  Data? data;

  GetLiveUser({this.success, this.data});

  GetLiveUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Users>? users;
  var usersCount;

  Data({this.users, this.usersCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    usersCount = json['usersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['usersCount'] = this.usersCount;
    return data;
  }
}

class Users {
  String? name;
  String? email;
  String? number;
  String? sId;

  Users({this.name, this.email, this.number, this.sId});

  Users.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    number = json['number'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['number'] = this.number;
    data['_id'] = this.sId;
    return data;
  }
}
