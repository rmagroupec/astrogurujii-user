
class get_daily_sun_horoscope {
  bool? status;
  String?  message;
  Data? data;

  get_daily_sun_horoscope({this.status, this.message, this.data});

  get_daily_sun_horoscope.fromJson(Map<String?, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Horoscope? horoscope;

  Data({this.horoscope});

  Data.fromJson(Map<String?, dynamic> json) {
    horoscope = json['horoscope'] != null
        ? new Horoscope.fromJson(json['horoscope'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.horoscope != null) {
      data['horoscope'] = this.horoscope!.toJson();
    }
    return data;
  }
}

class Horoscope {
  String? luckyColor;
  String? luckyColorCode;
  List<int>? luckyNumber;
  BotResponse? botResponse;
  String? zodiac;

  Horoscope(
      {this.luckyColor,
      this.luckyColorCode,
      this.luckyNumber,
      this.botResponse,
      this.zodiac});

  Horoscope.fromJson(Map<String?, dynamic> json) {
    luckyColor = json['lucky_color'];
    luckyColorCode = json['lucky_color_code'];
    luckyNumber = json['lucky_number'].cast<int>();
    botResponse = json['bot_response'] != null
        ? new BotResponse.fromJson(json['bot_response'])
        : null;
    zodiac = json['zodiac'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['lucky_color'] = this.luckyColor;
    data['lucky_color_code'] = this.luckyColorCode;
    data['lucky_number'] = this.luckyNumber;
    if (this.botResponse != null) {
      data['bot_response'] = this.botResponse!.toJson();
    }
    data['zodiac'] = this.zodiac;
    return data;
  }
}

class BotResponse {
  Physique? physique;
  Physique? status;
  Physique? finances;
  Physique? relationship;
  Physique? career;
  Physique? travel;
  Physique? family;
  Physique? friends;
  Physique? health;
  Physique? totalScore;

  BotResponse(
      {this.physique,
      this.status,
      this.finances,
      this.relationship,
      this.career,
      this.travel,
      this.family,
      this.friends,
      this.health,
      this.totalScore});

  BotResponse.fromJson(Map<String?, dynamic> json) {
    physique = json['physique'] != null
        ? new Physique.fromJson(json['physique'])
        : null;
    status =
        json['status'] != null ? new Physique.fromJson(json['status']) : null;
    finances = json['finances'] != null
        ? new Physique.fromJson(json['finances'])
        : null;
    relationship = json['relationship'] != null
        ? new Physique.fromJson(json['relationship'])
        : null;
    career =
        json['career'] != null ? new Physique.fromJson(json['career']) : null;
    travel =
        json['travel'] != null ? new Physique.fromJson(json['travel']) : null;
    family =
        json['family'] != null ? new Physique.fromJson(json['family']) : null;
    friends =
        json['friends'] != null ? new Physique.fromJson(json['friends']) : null;
    health =
        json['health'] != null ? new Physique.fromJson(json['health']) : null;
    totalScore = json['total_score'] != null
        ? new Physique.fromJson(json['total_score'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this.physique != null) {
      data['physique'] = this.physique!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.finances != null) {
      data['finances'] = this.finances!.toJson();
    }
    if (this.relationship != null) {
      data['relationship'] = this.relationship!.toJson();
    }
    if (this.career != null) {
      data['career'] = this.career!.toJson();
    }
    if (this.travel != null) {
      data['travel'] = this.travel!.toJson();
    }
    if (this.family != null) {
      data['family'] = this.family!.toJson();
    }
    if (this.friends != null) {
      data['friends'] = this.friends!.toJson();
    }
    if (this.health != null) {
      data['health'] = this.health!.toJson();
    }
    if (this.totalScore != null) {
      data['total_score'] = this.totalScore!.toJson();
    }
    return data;
  }
}

class Physique {
  int? score;
  String? splitResponse;

  Physique({this.score, this.splitResponse});

  Physique.fromJson(Map<String?, dynamic> json) {
    score = json['score'];
    splitResponse = json['split_response'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['score'] = this.score;
    data['split_response'] = this.splitResponse;
    return data;
  }
}
