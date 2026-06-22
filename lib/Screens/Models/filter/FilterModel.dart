class FilterModel {
  List<Skill>? skill;
  List<Skill>? languages;
  List<Skill>? gender;
  List<Skill>? sort;

  FilterModel({this.skill, this.languages, this.gender, this.sort});

  FilterModel.fromJson(Map<String, dynamic> json) {
    if (json['skill'] != null) {
      skill = <Skill>[];
      json['skill'].forEach((v) {
        skill!.add(new Skill.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = <Skill>[];
      json['languages'].forEach((v) {
        languages!.add(new Skill.fromJson(v));
      });
    }
    if (json['gender'] != null) {
      gender = <Skill>[];
      json['gender'].forEach((v) {
        gender!.add(new Skill.fromJson(v));
      });
    }
    if (json['sort'] != null) {
      sort = <Skill>[];
      json['sort'].forEach((v) {
        sort!.add(new Skill.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.skill != null) {
      data['skill'] = this.skill!.map((v) => v.toJson()).toList();
    }
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    if (this.gender != null) {
      data['gender'] = this.gender!.map((v) => v.toJson()).toList();
    }
    if (this.sort != null) {
      data['sort'] = this.sort!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Skill {
  var id;
  var name;
  var status;

  Skill({this.status,this.id, this.name});

  Skill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
