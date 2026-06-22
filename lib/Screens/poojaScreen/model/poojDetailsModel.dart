class PoojaDetailModel {
  bool? status;
  Data? data;
  String? message;
  var participents;

  PoojaDetailModel({this.status, this.data, this.message,this.participents});

  PoojaDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
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

  Data.fromJson(Map<String, dynamic> json) {
    pujaImage = json['pujaImage'];
    bannerImages = json['bannerImages'].cast<String>();
    pujaDate = json['pujaDate'];
    mandirName = json['mandirName'];
    aboutPuja = json['aboutPuja'];
    purposeOfPooja = json['purposeOfPooja'];
    aboutTempalTitle = json['aboutTempalTitle'];
    templeImage = json['templeImage'];
    aboutTempalDescription = json['aboutTempalDescription'];
    if (json['benifits'] != null) {
      benifits = <Benifits>[];
      json['benifits'].forEach((v) {
        benifits!.add(new Benifits.fromJson(v));
      });
    }
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(new Faq.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    isDelete = json['is_delete'];
    colorStatus = json['colorStatus'];
    sId = json['_id'];
    title = json['title'];
    if (json['packages'] != null) {
      packages = <Packages>[];
      json['packages'].forEach((v) {
        packages!.add(new Packages.fromJson(v));
      });
    }
    pujaDatetime = json['pujaDatetime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
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
    if (this.benifits != null) {
      data['benifits'] = this.benifits!.map((v) => v.toJson()).toList();
    }
    if (this.faq != null) {
      data['faq'] = this.faq!.map((v) => v.toJson()).toList();
    }
    data['is_delete'] = this.isDelete;
    data['colorStatus'] = this.colorStatus;
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.packages != null) {
      data['packages'] = this.packages!.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['pujaDatetime'] = this.pujaDatetime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Benifits {
 var title;
  var description;

  Benifits({this.title, this.description});

  Benifits.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
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
    question = json['question'];
    answer = json['answer'];
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
    packageType = json['packageType'];
    packageDescription = json['packageDescription'].cast<String>();
    sId = json['_id'];
    packageName = json['packageName'];
    packagePrice = json['packagePrice'];
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
    photo = json['photo'];
    sId = json['_id'];
    name = json['name'];
    review = json['review'];
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






// class PoojaDetailModel {
//   bool? status;
//   Data? data;
//   String? message;
//
//   PoojaDetailModel({this.status, this.data, this.message});
//
//   PoojaDetailModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class Data {
//   String? pujaImage;
//   String? pujaDate;
//   String? mandirName;
//   String? aboutPuja;
//   String? aboutTempalTitle;
//   String? aboutTempalDescription;
//   List<Benifits>? benifits;
//   List<Packages>? packages;
//   List<Faq>? faq;
//   String? isDelete;
//   String? colorStatus;
//   String? sId;
//   String? title;
//   String? pujaDatetime;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   Data(
//       {this.pujaImage,
//         this.pujaDate,
//         this.mandirName,
//         this.aboutPuja,
//         this.aboutTempalTitle,
//         this.aboutTempalDescription,
//         this.benifits,
//         this.packages,
//         this.faq,
//         this.isDelete,
//         this.colorStatus,
//         this.sId,
//         this.title,
//         this.pujaDatetime,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     pujaImage = json['pujaImage'];
//     pujaDate = json['pujaDate'];
//     mandirName = json['mandirName'];
//     aboutPuja = json['aboutPuja'];
//     aboutTempalTitle = json['aboutTempalTitle'];
//     aboutTempalDescription = json['aboutTempalDescription'];
//     if (json['benifits'] != null) {
//       benifits = <Benifits>[];
//       json['benifits'].forEach((v) {
//         benifits!.add(new Benifits.fromJson(v));
//       });
//     }
//     if (json['packages'] != null) {
//       packages = <Packages>[];
//       json['packages'].forEach((v) {
//         packages!.add(new Packages.fromJson(v));
//       });
//     }
//     if (json['faq'] != null) {
//       faq = <Faq>[];
//       json['faq'].forEach((v) {
//         faq!.add(new Faq.fromJson(v));
//       });
//     }
//     isDelete = json['is_delete'];
//     colorStatus = json['colorStatus'];
//     sId = json['_id'];
//     title = json['title'];
//     pujaDatetime = json['pujaDatetime'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pujaImage'] = this.pujaImage;
//     data['pujaDate'] = this.pujaDate;
//     data['mandirName'] = this.mandirName;
//     data['aboutPuja'] = this.aboutPuja;
//     data['aboutTempalTitle'] = this.aboutTempalTitle;
//     data['aboutTempalDescription'] = this.aboutTempalDescription;
//     if (this.benifits != null) {
//       data['benifits'] = this.benifits!.map((v) => v.toJson()).toList();
//     }
//     if (this.packages != null) {
//       data['packages'] = this.packages!.map((v) => v.toJson()).toList();
//     }
//     if (this.faq != null) {
//       data['faq'] = this.faq!.map((v) => v.toJson()).toList();
//     }
//     data['is_delete'] = this.isDelete;
//     data['colorStatus'] = this.colorStatus;
//     data['_id'] = this.sId;
//     data['title'] = this.title;
//     data['pujaDatetime'] = this.pujaDatetime;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
// class Benifits {
//   String? title;
//   String? description;
//
//   Benifits({this.title, this.description});
//
//   Benifits.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     description = json['description'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['description'] = this.description;
//     return data;
//   }
// }
//
// class Packages {
//   String? packageName;
//   String? packagePrice;
//   String? packageType;
//   List<String>? packageDescription;
//
//   Packages({this.packageName, this.packagePrice, this.packageDescription});
//
//   Packages.fromJson(Map<String, dynamic> json) {
//     packageName = json['packageName'];
//     packagePrice = json['packagePrice'];
//     packageType = json['packageType'];
//     packageDescription = json['packageDescription'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['packageName'] = this.packageName;
//     data['packagePrice'] = this.packagePrice;
//     data['packageType'] = this.packageType;
//     data['packageDescription'] = this.packageDescription;
//     return data;
//   }
// }
//
// class Faq {
//   String? question;
//   String? answer;
//
//   Faq({this.question, this.answer});
//
//   Faq.fromJson(Map<String, dynamic> json) {
//     question = json['question'];
//     answer = json['answer'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['question'] = this.question;
//     data['answer'] = this.answer;
//     return data;
//   }
// }
