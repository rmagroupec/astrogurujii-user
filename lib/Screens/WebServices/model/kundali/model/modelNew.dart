/// this model is change iff any error occurs refer to astroGurujii



class KundaliNew {
  KundaliNew({
    required this.success,
    required this.message,
    required this.dosha,
    required this.dasha,
    required this.horoscopeKundali,
  });

  final bool? success;
  final String? message;
  final Dosha? dosha;
  final Dasha? dasha;
  final HoroscopeKundali? horoscopeKundali;

  KundaliNew copyWith({
    bool? success,
    String? message,
    Dosha? dosha,
    Dasha? dasha,
    HoroscopeKundali? horoscopeKundali,
  }) {
    return KundaliNew(
      success: success ?? this.success,
      message: message ?? this.message,
      dosha: dosha ?? this.dosha,
      dasha: dasha ?? this.dasha,
      horoscopeKundali: horoscopeKundali ?? this.horoscopeKundali,
    );
  }

  factory KundaliNew.fromJson(Map<String, dynamic> json){
    return KundaliNew(
      success: json["success"],
      message: json["message"],
      dosha: json["dosha"] == null ? null : Dosha.fromJson(json["dosha"]),
      dasha: json["dasha"] == null ? null : Dasha.fromJson(json["dasha"]),
      horoscopeKundali: json["horoscopeKundali"] == null ? null : HoroscopeKundali.fromJson(json["horoscopeKundali"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "dosha": dosha?.toJson(),
    "dasha": dasha?.toJson(),
    "horoscopeKundali": horoscopeKundali?.toJson(),
  };

}

class Dasha {
  Dasha({
    required this.mahaDasha,
    required this.antarDasha,
  });

  final MahaDasha? mahaDasha;
  final AntarDasha? antarDasha;

  Dasha copyWith({
    MahaDasha? mahaDasha,
    AntarDasha? antarDasha,
  }) {
    return Dasha(
      mahaDasha: mahaDasha ?? this.mahaDasha,
      antarDasha: antarDasha ?? this.antarDasha,
    );
  }

  factory Dasha.fromJson(Map<String, dynamic> json){
    return Dasha(
      mahaDasha: json["mahaDasha"] == null ? null : MahaDasha.fromJson(json["mahaDasha"]),
      antarDasha: json["antarDasha"] == null ? null : AntarDasha.fromJson(json["antarDasha"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "mahaDasha": mahaDasha?.toJson(),
    "antarDasha": antarDasha?.toJson(),
  };

}

class AntarDasha {
  AntarDasha({
    required this.antardashas,
    required this.antardashaOrder,
  });

  final List<List<String>> antardashas;
  final List<List<String>> antardashaOrder;

  AntarDasha copyWith({
    List<List<String>>? antardashas,
    List<List<String>>? antardashaOrder,
  }) {
    return AntarDasha(
      antardashas: antardashas ?? this.antardashas,
      antardashaOrder: antardashaOrder ?? this.antardashaOrder,
    );
  }

  factory AntarDasha.fromJson(Map<String, dynamic> json){
    return AntarDasha(
      antardashas: json["antardashas"] == null ? [] : List<List<String>>.from(json["antardashas"]!.map((x) => x == null ? [] : List<String>.from(x!.map((x) => x)))),
      antardashaOrder: json["antardasha_order"] == null ? [] : List<List<String>>.from(json["antardasha_order"]!.map((x) => x == null ? [] : List<String>.from(x!.map((x) => x)))),
    );
  }

  Map<String, dynamic> toJson() => {
    "antardashas": antardashas.map((x) => x.map((x) => x).toList()).toList(),
    "antardasha_order": antardashaOrder.map((x) => x.map((x) => x).toList()).toList(),
  };

}

class MahaDasha {
  MahaDasha({
    required this.mahadasha,
    required this.mahadashaOrder,
    required this.startYear,
    required this.dashaStartDate,
    required this.dashaRemainingAtBirth,
  });

  final List<String> mahadasha;
  final List<String> mahadashaOrder;
    var startYear;
  final String? dashaStartDate;
  final String? dashaRemainingAtBirth;

  MahaDasha copyWith({
    List<String>? mahadasha,
    List<String>? mahadashaOrder,
    var startYear,
    String? dashaStartDate,
    String? dashaRemainingAtBirth,
  }) {
    return MahaDasha(
      mahadasha: mahadasha ?? this.mahadasha,
      mahadashaOrder: mahadashaOrder ?? this.mahadashaOrder,
      startYear: startYear ?? this.startYear,
      dashaStartDate: dashaStartDate ?? this.dashaStartDate,
      dashaRemainingAtBirth: dashaRemainingAtBirth ?? this.dashaRemainingAtBirth,
    );
  }

  factory MahaDasha.fromJson(Map<String, dynamic> json){
    return MahaDasha(
      mahadasha: json["mahadasha"] == null ? [] : List<String>.from(json["mahadasha"]!.map((x) => x)),
      mahadashaOrder: json["mahadasha_order"] == null ? [] : List<String>.from(json["mahadasha_order"]!.map((x) => x)),
      startYear: json["start_year"],
      dashaStartDate: json["dasha_start_date"],
      dashaRemainingAtBirth: json["dasha_remaining_at_birth"],
    );
  }

  Map<String, dynamic> toJson() => {
    "mahadasha": mahadasha.map((x) => x).toList(),
    "mahadasha_order": mahadashaOrder.map((x) => x).toList(),
    "start_year": startYear,
    "dasha_start_date": dashaStartDate,
    "dasha_remaining_at_birth": dashaRemainingAtBirth,
  };

}

class Dosha {
  Dosha({
    required this.mangalDosh,
    required this.kaalsarpDosh,
    required this.manglikDosh,
    required this.pitraDosh,
  });

  final MangalDosh? mangalDosh;
  final Dosh? kaalsarpDosh;
  final ManglikDosh? manglikDosh;
  final Dosh? pitraDosh;

  Dosha copyWith({
    MangalDosh? mangalDosh,
    Dosh? kaalsarpDosh,
    ManglikDosh? manglikDosh,
    Dosh? pitraDosh,
  }) {
    return Dosha(
      mangalDosh: mangalDosh ?? this.mangalDosh,
      kaalsarpDosh: kaalsarpDosh ?? this.kaalsarpDosh,
      manglikDosh: manglikDosh ?? this.manglikDosh,
      pitraDosh: pitraDosh ?? this.pitraDosh,
    );
  }

  factory Dosha.fromJson(Map<String, dynamic> json){
    return Dosha(
      mangalDosh: json["mangalDosh"] == null ? null : MangalDosh.fromJson(json["mangalDosh"]),
      kaalsarpDosh: json["kaalsarpDosh"] == null ? null : Dosh.fromJson(json["kaalsarpDosh"]),
      manglikDosh: json["manglikDosh"] == null ? null : ManglikDosh.fromJson(json["manglikDosh"]),
      pitraDosh: json["pitraDosh"] == null ? null : Dosh.fromJson(json["pitraDosh"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "mangalDosh": mangalDosh?.toJson(),
    "kaalsarpDosh": kaalsarpDosh?.toJson(),
    "manglikDosh": manglikDosh?.toJson(),
    "pitraDosh": pitraDosh?.toJson(),
  };

}

class Dosh {
  Dosh({
    required this.isDoshaPresent,
    required this.botResponse,
    required this.remedies,
    required this.effects,
  });

  final bool? isDoshaPresent;
  final String? botResponse;
  final List<String> remedies;
  final List<String> effects;

  Dosh copyWith({
    bool? isDoshaPresent,
    String? botResponse,
    List<String>? remedies,
    List<String>? effects,
  }) {
    return Dosh(
      isDoshaPresent: isDoshaPresent ?? this.isDoshaPresent,
      botResponse: botResponse ?? this.botResponse,
      remedies: remedies ?? this.remedies,
      effects: effects ?? this.effects,
    );
  }

  factory Dosh.fromJson(Map<String, dynamic> json){
    return Dosh(
      isDoshaPresent: json["is_dosha_present"],
      botResponse: json["bot_response"],
      remedies: json["remedies"] == null ? [] : List<String>.from(json["remedies"]!.map((x) => x)),
      effects: json["effects"] == null ? [] : List<String>.from(json["effects"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "is_dosha_present": isDoshaPresent,
    "bot_response": botResponse,
    "remedies": remedies.map((x) => x).toList(),
    "effects": effects.map((x) => x).toList(),
  };

}

class MangalDosh {
  MangalDosh({
    required this.factors,
    required this.isDoshaPresentMarsFromLagna,
    required this.isDoshaPresentMarsFromMoon,
    required this.isDoshaPresent,
    required this.botResponse,
    required this.score,
    required this.cancellation,
  });

  final Factors? factors;
  final bool? isDoshaPresentMarsFromLagna;
  final bool? isDoshaPresentMarsFromMoon;
  final bool? isDoshaPresent;
  final String? botResponse;
    var score;
  final Cancellation? cancellation;

  MangalDosh copyWith({
    Factors? factors,
    bool? isDoshaPresentMarsFromLagna,
    bool? isDoshaPresentMarsFromMoon,
    bool? isDoshaPresent,
    String? botResponse,
    var score,
    Cancellation? cancellation,
  }) {
    return MangalDosh(
      factors: factors ?? this.factors,
      isDoshaPresentMarsFromLagna: isDoshaPresentMarsFromLagna ?? this.isDoshaPresentMarsFromLagna,
      isDoshaPresentMarsFromMoon: isDoshaPresentMarsFromMoon ?? this.isDoshaPresentMarsFromMoon,
      isDoshaPresent: isDoshaPresent ?? this.isDoshaPresent,
      botResponse: botResponse ?? this.botResponse,
      score: score ?? this.score,
      cancellation: cancellation ?? this.cancellation,
    );
  }

  factory MangalDosh.fromJson(Map<String, dynamic> json){
    return MangalDosh(
      factors: json["factors"] == null ? null : Factors.fromJson(json["factors"]),
      isDoshaPresentMarsFromLagna: json["is_dosha_present_mars_from_lagna"],
      isDoshaPresentMarsFromMoon: json["is_dosha_present_mars_from_moon"],
      isDoshaPresent: json["is_dosha_present"],
      botResponse: json["bot_response"],
      score: json["score"],
      cancellation: json["cancellation"] == null ? null : Cancellation.fromJson(json["cancellation"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "factors": factors?.toJson(),
    "is_dosha_present_mars_from_lagna": isDoshaPresentMarsFromLagna,
    "is_dosha_present_mars_from_moon": isDoshaPresentMarsFromMoon,
    "is_dosha_present": isDoshaPresent,
    "bot_response": botResponse,
    "score": score,
    "cancellation": cancellation?.toJson(),
  };

}

class Cancellation {
  Cancellation({
    required this.cancellationScore,
    required this.cancellationReason,
  });

    var cancellationScore;
  final List<String> cancellationReason;

  Cancellation copyWith({
    var cancellationScore,
    List<String>? cancellationReason,
  }) {
    return Cancellation(
      cancellationScore: cancellationScore ?? this.cancellationScore,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  factory Cancellation.fromJson(Map<String, dynamic> json){
    return Cancellation(
      cancellationScore: json["cancellationScore"],
      cancellationReason: json["cancellationReason"] == null ? [] : List<String>.from(json["cancellationReason"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "cancellationScore": cancellationScore,
    "cancellationReason": cancellationReason.map((x) => x).toList(),
  };

}

class Factors {
  Factors({
    required this.mars,
  });

  final String? mars;

  Factors copyWith({
    String? mars,
  }) {
    return Factors(
      mars: mars ?? this.mars,
    );
  }

  factory Factors.fromJson(Map<String, dynamic> json){
    return Factors(
      mars: json["mars"],
    );
  }

  Map<String, dynamic> toJson() => {
    "mars": mars,
  };

}

class ManglikDosh {
  ManglikDosh({
    required this.manglikByMars,
    required this.isManglikPresent,
    required this.factors,
    required this.botResponse,
    required this.manglikBySaturn,
    required this.manglikByRahuketu,
    required this.aspects,
    required this.score,
  });

  final bool? manglikByMars;
  final bool? isManglikPresent;
  final List<String> factors;
  final String? botResponse;
  final bool? manglikBySaturn;
  final bool? manglikByRahuketu;
  final List<String> aspects;
    var score;

  ManglikDosh copyWith({
    bool? manglikByMars,
    bool? isManglikPresent,
    List<String>? factors,
    String? botResponse,
    bool? manglikBySaturn,
    bool? manglikByRahuketu,
    List<String>? aspects,
    var score,
  }) {
    return ManglikDosh(
      manglikByMars: manglikByMars ?? this.manglikByMars,
      isManglikPresent: isManglikPresent ?? this.isManglikPresent,
      factors: factors ?? this.factors,
      botResponse: botResponse ?? this.botResponse,
      manglikBySaturn: manglikBySaturn ?? this.manglikBySaturn,
      manglikByRahuketu: manglikByRahuketu ?? this.manglikByRahuketu,
      aspects: aspects ?? this.aspects,
      score: score ?? this.score,
    );
  }

  factory ManglikDosh.fromJson(Map<String, dynamic> json){
    return ManglikDosh(
      manglikByMars: json["manglik_by_mars"],
      isManglikPresent: json["is_manglik_present"],
      factors: json["factors"] == null ? [] : List<String>.from(json["factors"]!.map((x) => x)),
      botResponse: json["bot_response"],
      manglikBySaturn: json["manglik_by_saturn"],
      manglikByRahuketu: json["manglik_by_rahuketu"],
      aspects: json["aspects"] == null ? [] : List<String>.from(json["aspects"]!.map((x) => x)),
      score: json["score"],
    );
  }

  Map<String, dynamic> toJson() => {
    "manglik_by_mars": manglikByMars,
    "is_manglik_present": isManglikPresent,
    "factors": factors.map((x) => x).toList(),
    "bot_response": botResponse,
    "manglik_by_saturn": manglikBySaturn,
    "manglik_by_rahuketu": manglikByRahuketu,
    "aspects": aspects.map((x) => x).toList(),
    "score": score,
  };

}

class HoroscopeKundali {
  HoroscopeKundali({
    required this.planetDetails,
    required this.ashtakvarga,
  });

  final PlanetDetails? planetDetails;
  final Ashtakvarga? ashtakvarga;

  HoroscopeKundali copyWith({
    PlanetDetails? planetDetails,
    Ashtakvarga? ashtakvarga,
  }) {
    return HoroscopeKundali(
      planetDetails: planetDetails ?? this.planetDetails,
      ashtakvarga: ashtakvarga ?? this.ashtakvarga,
    );
  }

  factory HoroscopeKundali.fromJson(Map<String, dynamic> json){
    return HoroscopeKundali(
      planetDetails: json["planetDetails"] == null ? null : PlanetDetails.fromJson(json["planetDetails"]),
      ashtakvarga: json["ashtakvarga"] == null ? null : Ashtakvarga.fromJson(json["ashtakvarga"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "planetDetails": planetDetails?.toJson(),
    "ashtakvarga": ashtakvarga?.toJson(),
  };

}

class Ashtakvarga {
  Ashtakvarga({
    required this.ashtakvargaOrder,
    required this.ashtakvargaPoints,
    required this.ashtakvargaTotal,
  });

  final List<String> ashtakvargaOrder;
  final List<List<int>> ashtakvargaPoints;
  final List<int> ashtakvargaTotal;

  Ashtakvarga copyWith({
    List<String>? ashtakvargaOrder,
    List<List<int>>? ashtakvargaPoints,
    List<int>? ashtakvargaTotal,
  }) {
    return Ashtakvarga(
      ashtakvargaOrder: ashtakvargaOrder ?? this.ashtakvargaOrder,
      ashtakvargaPoints: ashtakvargaPoints ?? this.ashtakvargaPoints,
      ashtakvargaTotal: ashtakvargaTotal ?? this.ashtakvargaTotal,
    );
  }

  factory Ashtakvarga.fromJson(Map<String, dynamic> json){
    return Ashtakvarga(
      ashtakvargaOrder: json["ashtakvarga_order"] == null ? [] : List<String>.from(json["ashtakvarga_order"]!.map((x) => x)),
      ashtakvargaPoints: json["ashtakvarga_points"] == null ? [] : List<List<int>>.from(json["ashtakvarga_points"]!.map((x) => x == null ? [] : List<int>.from(x!.map((x) => x)))),
      ashtakvargaTotal: json["ashtakvarga_total"] == null ? [] : List<int>.from(json["ashtakvarga_total"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "ashtakvarga_order": ashtakvargaOrder.map((x) => x).toList(),
    "ashtakvarga_points": ashtakvargaPoints.map((x) => x.map((x) => x).toList()).toList(),
    "ashtakvarga_total": ashtakvargaTotal.map((x) => x).toList(),
  };

}

class PlanetDetails {
  PlanetDetails({
    required this.ascendant,
    required this.sun,
    required this.moon,
    required this.mars,
    required this.mercury,
    required this.jupiter,
    required this.venus,
    required this.saturn,
    required this.rahu,
    required this.ketu,
  });

  final Ascendant? ascendant;
  final Ascendant? sun;
  final Ascendant? moon;
  final Ascendant? mars;
  final Ascendant? mercury;
  final Ascendant? jupiter;
  final Ascendant? venus;
  final Ascendant? saturn;
  final Ascendant? rahu;
  final Ascendant? ketu;

  PlanetDetails copyWith({
    Ascendant? ascendant,
    Ascendant? sun,
    Ascendant? moon,
    Ascendant? mars,
    Ascendant? mercury,
    Ascendant? jupiter,
    Ascendant? venus,
    Ascendant? saturn,
    Ascendant? rahu,
    Ascendant? ketu,
  }) {
    return PlanetDetails(
      ascendant: ascendant ?? this.ascendant,
      sun: sun ?? this.sun,
      moon: moon ?? this.moon,
      mars: mars ?? this.mars,
      mercury: mercury ?? this.mercury,
      jupiter: jupiter ?? this.jupiter,
      venus: venus ?? this.venus,
      saturn: saturn ?? this.saturn,
      rahu: rahu ?? this.rahu,
      ketu: ketu ?? this.ketu,
    );
  }

  factory PlanetDetails.fromJson(Map<String, dynamic> json){
    return PlanetDetails(
      ascendant: json["Ascendant"] == null ? null : Ascendant.fromJson(json["Ascendant"]),
      sun: json["Sun"] == null ? null : Ascendant.fromJson(json["Sun"]),
      moon: json["Moon"] == null ? null : Ascendant.fromJson(json["Moon"]),
      mars: json["Mars"] == null ? null : Ascendant.fromJson(json["Mars"]),
      mercury: json["Mercury"] == null ? null : Ascendant.fromJson(json["Mercury"]),
      jupiter: json["Jupiter"] == null ? null : Ascendant.fromJson(json["Jupiter"]),
      venus: json["Venus"] == null ? null : Ascendant.fromJson(json["Venus"]),
      saturn: json["Saturn"] == null ? null : Ascendant.fromJson(json["Saturn"]),
      rahu: json["Rahu"] == null ? null : Ascendant.fromJson(json["Rahu"]),
      ketu: json["Ketu"] == null ? null : Ascendant.fromJson(json["Ketu"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "Ascendant": ascendant?.toJson(),
    "Sun": sun?.toJson(),
    "Moon": moon?.toJson(),
    "Mars": mars?.toJson(),
    "Mercury": mercury?.toJson(),
    "Jupiter": jupiter?.toJson(),
    "Venus": venus?.toJson(),
    "Saturn": saturn?.toJson(),
    "Rahu": rahu?.toJson(),
    "Ketu": ketu?.toJson(),
  };

}

class Ascendant {
  Ascendant({
    required this.name,
    required this.fullName,
    required this.localDegree,
    required this.globalDegree,
    required this.progressInPercentage,
    required this.rasiNo,
    required this.zodiac,
    required this.house,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.nakshatraPada,
    required this.nakshatraNo,
    required this.zodiacLord,
    required this.isPlanetSet,
    required this.lordStatus,
    required this.basicAvastha,
    required this.isCombust,
    required this.speedRadiansPerDay,
    required this.retro,
  });

  final String? name;
  final String? fullName;
    var localDegree;
    var globalDegree;
    var progressInPercentage;
    var rasiNo;
  final String? zodiac;
    var house;
  final String? nakshatra;
  final String? nakshatraLord;
    var nakshatraPada;
    var nakshatraNo;
  final String? zodiacLord;
  final bool? isPlanetSet;
  final String? lordStatus;
  final String? basicAvastha;
  final bool? isCombust;
    var speedRadiansPerDay;
  final bool? retro;

  Ascendant copyWith({
    String? name,
    String? fullName,
    var localDegree,
    var globalDegree,
    var progressInPercentage,
    var rasiNo,
    String? zodiac,
    var house,
    String? nakshatra,
    String? nakshatraLord,
    var nakshatraPada,
    var nakshatraNo,
    String? zodiacLord,
    bool? isPlanetSet,
    String? lordStatus,
    String? basicAvastha,
    bool? isCombust,
    var speedRadiansPerDay,
    bool? retro,
  }) {
    return Ascendant(
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      localDegree: localDegree ?? this.localDegree,
      globalDegree: globalDegree ?? this.globalDegree,
      progressInPercentage: progressInPercentage ?? this.progressInPercentage,
      rasiNo: rasiNo ?? this.rasiNo,
      zodiac: zodiac ?? this.zodiac,
      house: house ?? this.house,
      nakshatra: nakshatra ?? this.nakshatra,
      nakshatraLord: nakshatraLord ?? this.nakshatraLord,
      nakshatraPada: nakshatraPada ?? this.nakshatraPada,
      nakshatraNo: nakshatraNo ?? this.nakshatraNo,
      zodiacLord: zodiacLord ?? this.zodiacLord,
      isPlanetSet: isPlanetSet ?? this.isPlanetSet,
      lordStatus: lordStatus ?? this.lordStatus,
      basicAvastha: basicAvastha ?? this.basicAvastha,
      isCombust: isCombust ?? this.isCombust,
      speedRadiansPerDay: speedRadiansPerDay ?? this.speedRadiansPerDay,
      retro: retro ?? this.retro,
    );
  }

  factory Ascendant.fromJson(Map<String, dynamic> json){
    return Ascendant(
      name: json["name"],
      fullName: json["full_name"],
      localDegree: json["local_degree"],
      globalDegree: json["global_degree"],
      progressInPercentage: json["progress_in_percentage"],
      rasiNo: json["rasi_no"],
      zodiac: json["zodiac"],
      house: json["house"],
      nakshatra: json["nakshatra"],
      nakshatraLord: json["nakshatra_lord"],
      nakshatraPada: json["nakshatra_pada"],
      nakshatraNo: json["nakshatra_no"],
      zodiacLord: json["zodiac_lord"],
      isPlanetSet: json["is_planet_set"],
      lordStatus: json["lord_status"],
      basicAvastha: json["basic_avastha"],
      isCombust: json["is_combust"],
      speedRadiansPerDay: json["speed_radians_per_day"],
      retro: json["retro"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "full_name": fullName,
    "local_degree": localDegree,
    "global_degree": globalDegree,
    "progress_in_percentage": progressInPercentage,
    "rasi_no": rasiNo,
    "zodiac": zodiac,
    "house": house,
    "nakshatra": nakshatra,
    "nakshatra_lord": nakshatraLord,
    "nakshatra_pada": nakshatraPada,
    "nakshatra_no": nakshatraNo,
    "zodiac_lord": zodiacLord,
    "is_planet_set": isPlanetSet,
    "lord_status": lordStatus,
    "basic_avastha": basicAvastha,
    "is_combust": isCombust,
    "speed_radians_per_day": speedRadiansPerDay,
    "retro": retro,
  };

}
