class MatchMaking {
  bool? status;
  var message;
  Data? data;

  MatchMaking({this.status, this.message, this.data});

  MatchMaking.fromJson(Map<String, dynamic> json) {
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
  Tara? tara;
  Gana? gana;
  Yoni? yoni;
  Bhakoot? bhakoot;
  Grahamaitri? grahamaitri;
  Vasya? vasya;
  Nadi? nadi;
  Varna? varna;
  var score;
  var botResponse;

  Data(
      {this.tara,
      this.gana,
      this.yoni,
      this.bhakoot,
      this.grahamaitri,
      this.vasya,
      this.nadi,
      this.varna,
      this.score,
      this.botResponse});

  Data.fromJson(Map<String, dynamic> json) {
    tara = json['tara'] != null ? new Tara.fromJson(json['tara']) : null;
    gana = json['gana'] != null ? new Gana.fromJson(json['gana']) : null;
    yoni = json['yoni'] != null ? new Yoni.fromJson(json['yoni']) : null;
    bhakoot =
        json['bhakoot'] != null ? new Bhakoot.fromJson(json['bhakoot']) : null;
    grahamaitri = json['grahamaitri'] != null
        ? new Grahamaitri.fromJson(json['grahamaitri'])
        : null;
    vasya = json['vasya'] != null ? new Vasya.fromJson(json['vasya']) : null;
    nadi = json['nadi'] != null ? new Nadi.fromJson(json['nadi']) : null;
    varna = json['varna'] != null ? new Varna.fromJson(json['varna']) : null;
    score = json['score'];
    botResponse = json['bot_response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tara != null) {
      data['tara'] = this.tara!.toJson();
    }
    if (this.gana != null) {
      data['gana'] = this.gana!.toJson();
    }
    if (this.yoni != null) {
      data['yoni'] = this.yoni!.toJson();
    }
    if (this.bhakoot != null) {
      data['bhakoot'] = this.bhakoot!.toJson();
    }
    if (this.grahamaitri != null) {
      data['grahamaitri'] = this.grahamaitri!.toJson();
    }
    if (this.vasya != null) {
      data['vasya'] = this.vasya!.toJson();
    }
    if (this.nadi != null) {
      data['nadi'] = this.nadi!.toJson();
    }
    if (this.varna != null) {
      data['varna'] = this.varna!.toJson();
    }
    data['score'] = this.score;
    data['bot_response'] = this.botResponse;
    return data;
  }
}

class Tara {
  var boyTara;
  var girlTara;
  var tara;
  var description;
  var name;
  var fullScore;

  Tara(
      {this.boyTara,
      this.girlTara,
      this.tara,
      this.description,
      this.name,
      this.fullScore});

  Tara.fromJson(Map<String, dynamic> json) {
    boyTara = json['boy_tara'];
    girlTara = json['girl_tara'];
    tara = json['tara'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_tara'] = this.boyTara;
    data['girl_tara'] = this.girlTara;
    data['tara'] = this.tara;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Gana {
  var boyGana;
  var girlGana;
  var gana;
  var description;
  var name;
  var fullScore;

  Gana(
      {this.boyGana,
      this.girlGana,
      this.gana,
      this.description,
      this.name,
      this.fullScore});

  Gana.fromJson(Map<String, dynamic> json) {
    boyGana = json['boy_gana'];
    girlGana = json['girl_gana'];
    gana = json['gana'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_gana'] = this.boyGana;
    data['girl_gana'] = this.girlGana;
    data['gana'] = this.gana;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Yoni {
  var boyYoni;
  var girlYoni;
  var yoni;
  var description;
  var name;
  var fullScore;

  Yoni(
      {this.boyYoni,
      this.girlYoni,
      this.yoni,
      this.description,
      this.name,
      this.fullScore});

  Yoni.fromJson(Map<String, dynamic> json) {
    boyYoni = json['boy_yoni'];
    girlYoni = json['girl_yoni'];
    yoni = json['yoni'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_yoni'] = this.boyYoni;
    data['girl_yoni'] = this.girlYoni;
    data['yoni'] = this.yoni;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Bhakoot {
  var boyRasi;
  var girlRasi;
  var boyRasiName;
  var girlRasiName;
  var bhakoot;
  var description;
  var name;
  var fullScore;

  Bhakoot(
      {this.boyRasi,
      this.girlRasi,
      this.boyRasiName,
      this.girlRasiName,
      this.bhakoot,
      this.description,
      this.name,
      this.fullScore});

  Bhakoot.fromJson(Map<String, dynamic> json) {
    boyRasi = json['boy_rasi'];
    girlRasi = json['girl_rasi'];
    boyRasiName = json['boy_rasi_name'];
    girlRasiName = json['girl_rasi_name'];
    bhakoot = json['bhakoot'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_rasi'] = this.boyRasi;
    data['girl_rasi'] = this.girlRasi;
    data['boy_rasi_name'] = this.boyRasiName;
    data['girl_rasi_name'] = this.girlRasiName;
    data['bhakoot'] = this.bhakoot;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Grahamaitri {
  var boyLord;
  var girlLord;
  var grahamaitri;
  var description;
  var name;
  var fullScore;

  Grahamaitri(
      {this.boyLord,
      this.girlLord,
      this.grahamaitri,
      this.description,
      this.name,
      this.fullScore});

  Grahamaitri.fromJson(Map<String, dynamic> json) {
    boyLord = json['boy_lord'];
    girlLord = json['girl_lord'];
    grahamaitri = json['grahamaitri'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_lord'] = this.boyLord;
    data['girl_lord'] = this.girlLord;
    data['grahamaitri'] = this.grahamaitri;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Vasya {
  var boyVasya;
  var girlVasya;
  var vasya;
  var description;
  var name;
  var fullScore;

  Vasya(
      {this.boyVasya,
      this.girlVasya,
      this.vasya,
      this.description,
      this.name,
      this.fullScore});

  Vasya.fromJson(Map<String, dynamic> json) {
    boyVasya = json['boy_vasya'];
    girlVasya = json['girl_vasya'];
    vasya = json['vasya'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_vasya'] = this.boyVasya;
    data['girl_vasya'] = this.girlVasya;
    data['vasya'] = this.vasya;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Nadi {
  var boyNadi;
  var girlNadi;
  var nadi;
  var description;
  var name;
  var fullScore;

  Nadi(
      {this.boyNadi,
      this.girlNadi,
      this.nadi,
      this.description,
      this.name,
      this.fullScore});

  Nadi.fromJson(Map<String, dynamic> json) {
    boyNadi = json['boy_nadi'];
    girlNadi = json['girl_nadi'];
    nadi = json['nadi'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_nadi'] = this.boyNadi;
    data['girl_nadi'] = this.girlNadi;
    data['nadi'] = this.nadi;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}

class Varna {
  var boyVarna;
  var girlVarna;
  var varna;
  var description;
  var name;
  var fullScore;

  Varna(
      {this.boyVarna,
      this.girlVarna,
      this.varna,
      this.description,
      this.name,
      this.fullScore});

  Varna.fromJson(Map<String, dynamic> json) {
    boyVarna = json['boy_varna'];
    girlVarna = json['girl_varna'];
    varna = json['varna'];
    description = json['description'];
    name = json['name'];
    fullScore = json['full_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['boy_varna'] = this.boyVarna;
    data['girl_varna'] = this.girlVarna;
    data['varna'] = this.varna;
    data['description'] = this.description;
    data['name'] = this.name;
    data['full_score'] = this.fullScore;
    return data;
  }
}
