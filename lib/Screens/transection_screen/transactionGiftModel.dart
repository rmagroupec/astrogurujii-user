class GiftTranscationListModel {
  bool? status;
  List<Gifts>? gifts;

  GiftTranscationListModel({this.status, this.gifts});

  GiftTranscationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['gifts'] != null) {
      gifts = <Gifts>[];
      json['gifts'].forEach((v) {
        gifts!.add(new Gifts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.gifts != null) {
      data['gifts'] = this.gifts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gifts {
  String? sId;
  FromUser? fromUser;
  ToAstro? toAstro;
  Gift? gift;
  String? type;
  // PujaId? pujaId;
  // PujaId? liveId;
  int? amount;
  String? createdAt;
  int? iV;

  Gifts(
      {this.sId,
        this.fromUser,
        this.toAstro,
        this.gift,
        this.type,
        // this.pujaId,
        // this.liveId,
        this.amount,
        this.createdAt,
        this.iV});

  Gifts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fromUser = json['fromUser'] != null
        ? new FromUser.fromJson(json['fromUser'])
        : null;
    toAstro =
    json['toAstro'] != null ? new ToAstro.fromJson(json['toAstro']) : null;
    gift = json['gift'] != null ? new Gift.fromJson(json['gift']) : null;
    type = json['type'];
    // pujaId =
    // json['pujaId'] != null ? new PujaId.fromJson(json['pujaId']) : null;
    // liveId =
    // json['liveId'] != null ? new PujaId.fromJson(json['liveId']) : null;
    amount = json['amount'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.fromUser != null) {
      data['fromUser'] = this.fromUser!.toJson();
    }
    if (this.toAstro != null) {
      data['toAstro'] = this.toAstro!.toJson();
    }
    if (this.gift != null) {
      data['gift'] = this.gift!.toJson();
    }
    data['type'] = this.type;
    // if (this.pujaId != null) {
    //   data['pujaId'] = this.pujaId!.toJson();
    // }
    // if (this.liveId != null) {
    //   data['liveId'] = this.liveId!.toJson();
    // }
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class FromUser {
  String? name;
  String? sId;

  FromUser({this.name, this.sId});

  FromUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['_id'] = this.sId;
    return data;
  }
}

class ToAstro {
  String? displayname;
  String? sId;

  ToAstro({this.displayname, this.sId});

  ToAstro.fromJson(Map<String, dynamic> json) {
    displayname = json['displayname'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayname'] = this.displayname;
    data['_id'] = this.sId;
    return data;
  }
}

class Gift {
  String? title;
  String? image;
  String? sId;
  int? price;

  Gift({this.title, this.image, this.sId, this.price});

  Gift.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    sId = json['_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['price'] = this.price;
    return data;
  }
}

// class PujaId {
//   String? sId;
//   PujaId? pujaId;
//
//   PujaId({this.sId, this.pujaId});
//
//   PujaId.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     pujaId =
//     json['puja_id'] != null ? new PujaId.fromJson(json['puja_id']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     if (this.pujaId != null) {
//       data['puja_id'] = this.pujaId!.toJson();
//     }
//     return data;
//   }
// }

// class PujaId {
//   String? sId;
//   String? title;
//
//   PujaId({this.sId, this.title});
//
//   PujaId.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     title = json['title'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['title'] = this.title;
//     return data;
//   }
// }
