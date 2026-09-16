class PoojaDetailModel {
  bool? status;
  Data? data;
  String? message;
  var participents;

  PoojaDetailModel({this.status, this.data, this.message, this.participents});

  PoojaDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] == true;
    data = (json['data'] is Map)
        ? Data.fromJson(Map<String, dynamic>.from(json['data']))
        : null;
    message = json['message']?.toString();
    participents = json['participents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['participents'] = this.participents;
    return data;
  }
}

class Data {
  String? pujaImage;
  List<String>? bannerImages;
  String? pujaDate;
  String? mandirName;
  String? aboutPuja;
  String? purposeOfPooja;
  String? aboutTempalTitle;
  String? aboutTempalDescription;
  String? templeImage;
  List<Benifits>? benifits;
  List<Faq>? faq;
  String? isDelete;
  String? colorStatus;
  String? sId;
  String? title;
  List<Packages>? packages;
  List<Reviews>? reviews;

  String? pujaDatetime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.pujaImage,
        this.bannerImages,
        this.pujaDate,
        this.mandirName,
        this.aboutPuja,
        this.purposeOfPooja,
        this.aboutTempalTitle,
        this.templeImage,
        this.aboutTempalDescription,
        this.benifits,
        this.faq,
        this.reviews,
        this.isDelete,
        this.colorStatus,
        this.sId,
        this.title,
        this.packages,
        this.pujaDatetime,
        this.createdAt,
        this.updatedAt,
        this.iV});

  // Helper: safely turn any JSON value into List<String>, no matter whether
  // it's null, missing, a String, a List of mixed types, or anything else.
  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').toList();
    }
    return <String>[];
  }

  // Helper: safely turn any JSON value into a List<Map>, so a malformed or
  // missing array never throws while building sub-object lists below.
  static List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  Data.fromJson(Map<String, dynamic> json) {
    pujaImage = json['pujaImage']?.toString();
    bannerImages = _asStringList(json['bannerImages']);          // was .cast<String>() — crashed on null
    pujaDate = json['pujaDate']?.toString();
    mandirName = json['mandirName']?.toString();
    aboutPuja = json['aboutPuja']?.toString();
    purposeOfPooja = json['purposeOfPooja']?.toString();
    aboutTempalTitle = json['aboutTempalTitle']?.toString();
    templeImage = json['templeImage']?.toString();
    aboutTempalDescription = json['aboutTempalDescription']?.toString();

    benifits = _asMapList(json['benifits']).map((v) => Benifits.fromJson(v)).toList();
    faq = _asMapList(json['faq']).map((v) => Faq.fromJson(v)).toList();
    reviews = _asMapList(json['reviews']).map((v) => Reviews.fromJson(v)).toList();
    packages = _asMapList(json['packages']).map((v) => Packages.fromJson(v)).toList();

    isDelete = json['is_delete']?.toString();
    colorStatus = json['colorStatus']?.toString();
    sId = json['_id']?.toString();
    title = json['title']?.toString();

    pujaDatetime = json['pujaDatetime']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    iV = json['__v'] is int ? json['__v'] as int : int.tryParse(json['__v']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pujaImage'] = this.pujaImage;
    data['bannerImages'] = this.bannerImages;
    data['pujaDate'] = this.pujaDate;
    data['mandirName'] = this.mandirName;
    data['aboutPuja'] = this.aboutPuja;
    data['purposeOfPooja'] = this.purposeOfPooja;
    data['aboutTempalTitle'] = this.aboutTempalTitle;
    data['templeImage'] = this.templeImage;
    data['aboutTempalDescription'] = this.aboutTempalDescription;
    data['benifits'] = (this.benifits ?? []).map((v) => v.toJson()).toList();
    data['faq'] = (this.faq ?? []).map((v) => v.toJson()).toList();
    data['is_delete'] = this.isDelete;
    data['colorStatus'] = this.colorStatus;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['packages'] = (this.packages ?? []).map((v) => v.toJson()).toList();
    data['reviews'] = (this.reviews ?? []).map((v) => v.toJson()).toList();
    data['pujaDatetime'] = this.pujaDatetime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Benifits {
  String? title;
  String? description;

  Benifits({this.title, this.description});

  Benifits.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    description = json['description']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}

class Faq {
  String? question;
  String? answer;

  Faq({this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question']?.toString();
    answer = json['answer']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}

class Packages {
  String? packageType;
  List<String>? packageDescription;
  String? sId;
  String? packageName;
  String? packagePrice;

  Packages(
      {this.packageType,
        this.packageDescription,
        this.sId,
        this.packageName,
        this.packagePrice});

  Packages.fromJson(Map<String, dynamic> json) {
    packageType = json['packageType']?.toString();
    packageDescription = Data._asStringList(json['packageDescription']); // was .cast<String>() — crashed on null
    sId = json['_id']?.toString();
    packageName = json['packageName']?.toString();
    packagePrice = json['packagePrice']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageType'] = this.packageType;
    data['packageDescription'] = this.packageDescription;
    data['_id'] = this.sId;
    data['packageName'] = this.packageName;
    data['packagePrice'] = this.packagePrice;
    return data;
  }
}

class Reviews {
  String? photo;
  String? sId;
  String? name;
  String? review;

  Reviews({this.photo, this.sId, this.name, this.review});

  Reviews.fromJson(Map<String, dynamic> json) {
    photo = json['photo']?.toString();
    sId = json['_id']?.toString();
    name = json['name']?.toString();
    review = json['review']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['review'] = this.review;
    return data;
  }
}