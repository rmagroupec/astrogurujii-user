class AstrologerModel {
  bool? status;
  String? message;
  List<AstroResults>? results;

  AstrologerModel({this.status, this.message, this.results});

  AstrologerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['results'] != null) {
      results = <AstroResults>[];
      json['results'].forEach((v) {
        results!.add(AstroResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AstroResults {
  String? id;
  var astro_number;
  int? rating;
  var avg_rate;
  String? name;
  var is_busy;
  var per_min_chat_offer;
  var per_min_voice_call_offer;
  var per_min_video_call_offer;
  String? about;
  var experience;
  int? perMinChat;
  int? perMinVoiceCall;
  int? perMinVideoCall;
  String? isChat;
  String? isChatOnline;
  String? isVoiceOnline;
  var watting_time;
  String? isVideoOnline;
  var country;
  var perQuestionPrice;
  var report_price;
  var chat_count;
  var audio_count;
  var video_count;
  var consult;
  String? profileImg;
  List<Language>? language;
  List<Category>? category;

  AstroResults({
    this.consult,
    this.video_count,
    this.audio_count,
    this.chat_count,
    this.watting_time,
    this.country,
    this.avg_rate,
    this.report_price,
    this.id,
    this.rating,
    this.per_min_chat_offer,
    this.per_min_voice_call_offer,
    this.per_min_video_call_offer,
    this.astro_number,
    this.name,
    this.is_busy,
    this.about,
    this.experience,
    this.perMinChat,
    this.perMinVoiceCall,
    this.perMinVideoCall,
    this.isChat,
    this.perQuestionPrice,
    this.isChatOnline,
    this.isVoiceOnline,
    this.isVideoOnline,
    this.profileImg,
    this.language,
    this.category,
  });

  AstroResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    consult = _handleNaN(json['consult']);
    video_count = _handleNaN(json['video_count']);
    audio_count = _handleNaN(json['audio_count']);
    chat_count = _handleNaN(json['chat_count']);
    watting_time = _handleNaN(json['watting_time']);
    avg_rate = _handleNaN(json['avg_rate']);
    astro_number = json['astro_number'];
    report_price = _handleNaN(json['report_price']);
    country = "INR";
    per_min_chat_offer = _handleNaN(json['per_min_chat_offer']);
    per_min_voice_call_offer = _handleNaN(json['per_min_voice_call_offer']);
    per_min_video_call_offer = _handleNaN(json['per_min_video_call_offer']);
    rating = json['rating'];
    name = json['name'];
    is_busy = json['is_busy'];
    about = json['about'];
    experience = _handleNaN(json['experience']);
    perMinChat = _handleNaN(json['per_min_chat']);
    perMinVoiceCall = _handleNaN(json['per_min_voice_call']);
    perMinVideoCall = _handleNaN(json['per_min_video_call']);
    isChat = json['is_chat'];
    perQuestionPrice = _handleNaN(json['per_question_price']);
    isChatOnline = json['is_chat_online'];
    isVoiceOnline = json['is_voice_online'];
    isVideoOnline = json['is_video_online'];
    profileImg = json['profile_img'];
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(Language.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['consult'] = _handleNaN(consult);
    data['video_count'] = _handleNaN(video_count);
    data['audio_count'] = _handleNaN(audio_count);
    data['chat_count'] = _handleNaN(chat_count);
    data['watting_time'] = _handleNaN(watting_time);
    data['avg_rate'] = _handleNaN(avg_rate);
    data['country'] = this.country;
    data['report_price'] = _handleNaN(report_price);
    data['astro_number'] = this.astro_number;
    data['per_min_chat_offer'] = _handleNaN(per_min_chat_offer);
    data['per_min_voice_call_offer'] = _handleNaN(per_min_voice_call_offer);
    data['per_min_video_call_offer'] = _handleNaN(per_min_video_call_offer);
    data['rating'] = this.rating;
    data['name'] = this.name;
    data['is_busy'] = this.is_busy;
    data['about'] = this.about;
    data['experience'] = _handleNaN(experience);
    data['per_min_chat'] = _handleNaN(perMinChat);
    data['per_min_voice_call'] = _handleNaN(perMinVoiceCall);
    data['per_min_video_call'] = _handleNaN(perMinVideoCall);
    data['is_chat'] = this.isChat;
    data['per_question_price'] = this.perQuestionPrice;
    data['is_chat_online'] = this.isChatOnline;
    data['is_voice_online'] = this.isVoiceOnline;
    data['is_video_online'] = this.isVideoOnline;
    data['profile_img'] = this.profileImg;
    if (this.language != null) {
      data['language'] = this.language!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Utility function to handle NaN values
  dynamic _handleNaN(dynamic value) {
    if (value.toString() == 'NaN') return 0;
    return value;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Category {
  String? sId;
  String? name;

  Category({this.sId, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
