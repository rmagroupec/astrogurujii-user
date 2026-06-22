class BasicNumerologyModel {
  bool? status;
  String? message;
  Data? data;

  BasicNumerologyModel({this.status, this.message, this.data});

  BasicNumerologyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Destiny? destiny;
  Destiny? personality;
  Destiny? attitude;
  Destiny? character;
  Destiny? soul;
  Destiny? agenda;
  Destiny? purpose;

  Data(
      {this.destiny,
      this.personality,
      this.attitude,
      this.character,
      this.soul,
      this.agenda,
      this.purpose});

  Data.fromJson(Map<String, dynamic> json) {
    destiny =
        json['destiny'] != null ? new Destiny.fromJson(json['destiny']) : null;
    personality = json['personality'] != null
        ? new Destiny.fromJson(json['personality'])
        : null;
    attitude = json['attitude'] != null
        ? new Destiny.fromJson(json['attitude'])
        : null;
    character = json['character'] != null
        ? new Destiny.fromJson(json['character'])
        : null;
    soul = json['soul'] != null ? new Destiny.fromJson(json['soul']) : null;
    agenda =
        json['agenda'] != null ? new Destiny.fromJson(json['agenda']) : null;
    purpose =
        json['purpose'] != null ? new Destiny.fromJson(json['purpose']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.destiny != null) {
      data['destiny'] = this.destiny!.toJson();
    }
    if (this.personality != null) {
      data['personality'] = this.personality!.toJson();
    }
    if (this.attitude != null) {
      data['attitude'] = this.attitude!.toJson();
    }
    if (this.character != null) {
      data['character'] = this.character!.toJson();
    }
    if (this.soul != null) {
      data['soul'] = this.soul!.toJson();
    }
    if (this.agenda != null) {
      data['agenda'] = this.agenda!.toJson();
    }
    if (this.purpose != null) {
      data['purpose'] = this.purpose!.toJson();
    }
    return data;
  }
}

class Destiny {
  String? title;
  String? category;
  String? number;
  bool? master;
  String? meaning;
  String? description;

  Destiny(
      {this.title,
      this.category,
      this.number,
      this.master,
      this.meaning,
      this.description});

  Destiny.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    category = json['category'];
    number = json['number'];
    master = json['master'];
    meaning = json['meaning'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['category'] = this.category;
    data['number'] = this.number;
    data['master'] = this.master;
    data['meaning'] = this.meaning;
    data['description'] = this.description;
    return data;
  }
}
