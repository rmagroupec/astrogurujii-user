class AstroDetilsModel {
  bool? status;
  String? message;
  List<Results>? results;

  AstroDetilsModel({this.status, this.message, this.results});

  AstroDetilsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  // Add this utility method in the Results class to handle NaN values
  dynamic _handleNaN(dynamic value) {
    if (value.toString() == 'NaN') return 0;
    return value;
  }

  String? id;
  String? name;
  String? about;
  var experience;
  var perMinChat;
  var perMinVoiceCall;
  var perMinVideoCall;
  var perQuestionPrice;
  String? isChatOnline;
  String? isVoiceOnline;
  String? isVideoOnline;
  String? isChat;
  String? isVoiceCall;
  String? isVideoCall;
  String? isQuestion;
  String? profileImg;
  var country;
  var astro_number;
  var is_busy;
  var per_min_chat_offer;
  var per_min_voice_call_offer;
  var per_min_video_call_offer;
  var avg_rate;
  var is_Follow;
  var follow_count;

  var chat_count;
  var audio_count;
  var video_count;
  var consult;
  var one_rate;
  var two_rate;
  var three_rate;
  var four_rate;
  var five_rate;
  var state;
  var city;
  var astro_country;
  int? totalRating;
  int? rating_total_person;

  List<Language>? language;
  List<AstroCategory>? category;
  List<Skill>? skill;
  List<Rating>? rating;
  List<Galary>? galary;

  Results(
      {this.one_rate,
        this.two_rate,
        this.three_rate,
        this.four_rate,
        this.five_rate,
        this.rating_total_person,
        this.consult,
        this.video_count,
        this.chat_count,
        this.audio_count,
        this.country,
        this.is_Follow,
        this.follow_count,
        this.is_busy,
        this.per_min_chat_offer,
        this.per_min_voice_call_offer,
        this.per_min_video_call_offer,
        this.astro_number,
        this.id,
        this.name,
        this.about,
        this.experience,
        this.perMinChat,
        this.perMinVoiceCall,
        this.perMinVideoCall,
        this.perQuestionPrice,
        this.isChatOnline,
        this.isVoiceOnline,
        this.isVideoOnline,
        this.isChat,
        this.isVoiceCall,
        this.isVideoCall,
        this.isQuestion,
        this.profileImg,
        this.language,
        this.category,
        this.skill,
        this.state,
        this.city,
        this.astro_country,
        this.avg_rate,
        this.totalRating,
        this.rating,
        this.galary});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    one_rate = _handleNaN(json['one_rate']);
    two_rate = _handleNaN(json['two_rate']);
    three_rate = _handleNaN(json['three_rate']);
    four_rate = _handleNaN(json['four_rate']);
    five_rate = _handleNaN(json['five_rate']);
    rating_total_person = json['rating_total_person'];
    consult = json['consult'];
    video_count = json['video_count'];
    chat_count = json['chat_count'];
    audio_count = json['audio_count'];
    astro_number = json['astro_number'];
    is_Follow = json['is_Follow'];
    follow_count = json['follow_count'];
    country = "INR";
    per_min_chat_offer = _handleNaN(json['per_min_chat_offer']);
    per_min_voice_call_offer = _handleNaN(json['per_min_voice_call_offer']);
    per_min_video_call_offer = _handleNaN(json['per_min_video_call_offer']);
    is_busy = json['is_busy'];
    name = json['name'];
    about = json['about'];
    state = json['state'];
    city = json['city'];
    astro_country = json['astro_country'];
    experience = json['experience'];
    perMinChat = _handleNaN(json['per_min_chat']);
    perMinVoiceCall = _handleNaN(json['per_min_voice_call']);
    perMinVideoCall = _handleNaN(json['per_min_video_call']);
    perQuestionPrice = _handleNaN(json['per_question_price']);
    isChatOnline = json['is_chat_online'];
    isVoiceOnline = json['is_voice_online'];
    isVideoOnline = json['is_video_online'];
    isChat = json['is_chat'];
    isVoiceCall = json['is_voice_call'];
    isVideoCall = json['is_video_call'];
    isQuestion = json['is_question'];
    profileImg = json['profile_img'];
    avg_rate = _handleNaN(json['avg_rate']);
    totalRating = json['total_rating'];

    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <AstroCategory>[];
      json['category'].forEach((v) {
        category!.add(AstroCategory.fromJson(v));
      });
    }
    if (json['skill'] != null) {
      skill = <Skill>[];
      json['skill'].forEach((v) {
        skill!.add(Skill.fromJson(v));
      });
    }
    if (json['rating'] != null) {
      rating = <Rating>[];
      json['rating'].forEach((v) {
        rating!.add(Rating.fromJson(v));
      });
    }
    if (json['galary'] != null) {
      galary = <Galary>[];
      json['galary'].forEach((v) {
        galary!.add(Galary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['one_rate'] = this.one_rate;
    data['two_rate'] = this.two_rate;
    data['three_rate'] = this.three_rate;
    data['four_rate'] = this.four_rate;
    data['five_rate'] = this.five_rate;
    data['rating_total_person'] = this.rating_total_person;
    data['consult'] = this.consult;
    data['audio_count'] = this.audio_count;
    data['chat_count'] = this.chat_count;
    data['video_count'] = this.video_count;
    data['avg_rate'] = this.avg_rate;
    data['name'] = this.name;
    data['is_Follow'] = this.is_Follow;
    data['follow_count'] = this.follow_count;
    data['about'] = this.about;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['astro_country'] = this.astro_country;
    data['astro_number'] = this.astro_number;
    data['per_min_chat_offer'] = this.per_min_chat_offer;
    data['per_min_video_call_offer'] = this.per_min_video_call_offer;
    data['per_min_voice_call_offer'] = this.per_min_voice_call_offer;
    data['is_busy'] = this.is_busy;
    data['experience'] = this.experience;
    data['per_min_chat'] = this.perMinChat;
    data['per_min_voice_call'] = this.perMinVoiceCall;
    data['per_min_video_call'] = this.perMinVideoCall;
    data['per_question_price'] = this.perQuestionPrice;
    data['is_chat_online'] = this.isChatOnline;
    data['is_voice_online'] = this.isVoiceOnline;
    data['is_video_online'] = this.isVideoOnline;
    data['is_chat'] = this.isChat;
    data['is_voice_call'] = this.isVoiceCall;
    data['is_video_call'] = this.isVideoCall;
    data['is_question'] = this.isQuestion;
    data['profile_img'] = this.profileImg;
    if (this.language != null) {
      data['language'] = this.language!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.skill != null) {
      data['skill'] = this.skill!.map((v) => v.toJson()).toList();
    }
    if (this.rating != null) {
      data['rating'] = this.rating!.map((v) => v.toJson()).toList();
    }
    if (this.galary != null) {
      data['galary'] = this.galary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Language {
  String? sId;
  String? name;

  Language({this.sId, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Skill {
  String? sId;
  String? name;

  Skill({this.sId, this.name});

  Skill.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}


class AstroCategory {
  String? sId;
  String? name;

  AstroCategory({this.sId, this.name});

  AstroCategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}



class Rating {
  String? name;
  String? profileImg;
  int? rating;
  String? review;
  var astr_comment;
  String? createdDate;

  Rating(
      {this.name, this.profileImg, this.rating, this.review, this.createdDate});

  Rating.fromJson(Map<String, dynamic> json) {
    astr_comment = json['astr_comment'];
    name = json['name'];
    profileImg = json['profile_img'];
    rating = json['rating'];
    review = json['review'];
    createdDate = json['Created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['astr_comment'] = this.astr_comment;
    data['name'] = this.name;
    data['profile_img'] = this.profileImg;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['Created_date'] = this.createdDate;
    return data;
  }
}

class Galary {
  String? astrologerId;
  String? file;
  String? sId;

  Galary({this.astrologerId, this.file, this.sId});

  Galary.fromJson(Map<String, dynamic> json) {
    astrologerId = json['astrologer_id'];
    file = json['file'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['astrologer_id'] = this.astrologerId;
    data['file'] = this.file;
    data['_id'] = this.sId;
    return data;
  }
}