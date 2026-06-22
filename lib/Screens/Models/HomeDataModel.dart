class HomeDataModel {
  bool? status;
  String? message;
  var is_open_rating;
  var channel_id;

  List<HomeBanner>? banner;
  List<HomeBanner>? banner_ads;
  List<Blog>? blog;
  List<ProductCategory>? productCategory;
  List<Astrologer>? astrologer;
  List<Astrologer>? top_astrologer;
  List<Live>? live;
  List<Testimonials>? testimonials;
  List<VideoData>? videoData;
  HomeDataModel(
      {
        this.is_open_rating,
        this.videoData,
        this.channel_id,
        this.status,
        this.message,
        this.banner,
        this.banner_ads,
        this.blog,
        this.productCategory,
        this.astrologer,
        this.top_astrologer,
        this.live,
        this.testimonials});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    is_open_rating = json['is_open_rating'];
    channel_id = json['channel_id'];
    status = json['status'];
    message = json['message'];
    if (json['banner'] != null) {
      banner = <HomeBanner>[];
      json['banner'].forEach((v) {
        banner!.add( HomeBanner.fromJson(v));
      });
    }
    if (json['banner_ads'] != null) {
      banner_ads = <HomeBanner>[];
      json['banner_ads'].forEach((v) {
        banner_ads!.add( HomeBanner.fromJson(v));
      });
    }
    if (json['blog'] != null) {
      blog = <Blog>[];
      json['blog'].forEach((v) {
        blog!.add(new Blog.fromJson(v));
      });
    }
    if (json['product_category'] != null) {
      productCategory = <ProductCategory>[];
      json['product_category'].forEach((v) {
        productCategory!.add(new ProductCategory.fromJson(v));
      });
    }
    if (json['astrologer'] != null) {
      astrologer = <Astrologer>[];
      json['astrologer'].forEach((v) {
        astrologer!.add(new Astrologer.fromJson(v));
      });
    }

    if (json['top_astrologer'] != null) {
      top_astrologer = <Astrologer>[];
      json['top_astrologer'].forEach((v) {
        top_astrologer!.add(new Astrologer.fromJson(v));
      });
    }

   /* if (json['Video_data'] != null) {
      videoData = <VideoData>[];
      json['Video_data'].forEach((v) {
        videoData!.add(new VideoData.fromJson(v));
      });
    }*/

    if (json['live'] != null) {
      live = <Live>[];
      json['live'].forEach((v) {
        live!.add(new Live.fromJson(v));
      });
    }
    if (json['testimonials'] != null) {
      testimonials = <Testimonials>[];
      json['testimonials'].forEach((v) {
        testimonials!.add(new Testimonials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['is_open_rating'] = this.is_open_rating;
    data['channel_id'] = this.channel_id;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.banner_ads != null) {
      data['banner_ads'] = this.banner_ads!.map((v) => v.toJson()).toList();
    }
    if (this.blog != null) {
      data['blog'] = this.blog!.map((v) => v.toJson()).toList();
    }
    if (this.videoData != null) {
      data['Video_data'] = this.videoData!.map((v) => v.toJson()).toList();
    }
    if (this.productCategory != null) {
      data['product_category'] =
          this.productCategory!.map((v) => v.toJson()).toList();
    }
    if (this.top_astrologer != null) {
      data['top_astrologer'] = this.top_astrologer!.map((v) => v.toJson()).toList();
    }
    if (this.astrologer != null) {
      data['astrologer'] = this.astrologer!.map((v) => v.toJson()).toList();
    }
    if (this.live != null) {
      data['live'] = this.live!.map((v) => v.toJson()).toList();
    }
    if (this.testimonials != null) {
      data['testimonials'] = this.testimonials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeBanner {
  String? link;
  String? img;
  String? sId;
  String? redirectTo;

  HomeBanner({this.link, this.img, this.sId,this.redirectTo});

  HomeBanner.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    img = json['img'];
    redirectTo = json['redirectTo'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['link'] = this.link;
    data['img'] = this.img;
    data['redirectTo'] = this.redirectTo;
    data['_id'] = this.sId;
    return data;
  }
}

class Blog {
  String? title;
  String? description;
  String? auther;
  String? img;
  String? createdDate;
  String? sId;

  Blog(
      {this.title,
        this.description,
        this.auther,
        this.img,
        this.createdDate,
        this.sId});

  Blog.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    auther = json['auther'];
    img = json['img'];
    createdDate = json['Created_date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['auther'] = this.auther;
    data['img'] = this.img;
    data['Created_date'] = this.createdDate;
    data['_id'] = this.sId;
    return data;
  }
}

class ProductCategory {
  String? image;
  String? description;
  String? sId;
  String? name;

  ProductCategory({this.image, this.description, this.sId, this.name});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    description = json['description'];
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['image'] = this.image;
    data['description'] = this.description;
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Astrologer {
  String? id;
  String? name;
  String? profileImg;
  var experience;
  var per_min_chat;
  var per_min_chat_offer;
  var country;
  List<Language>? language;

  Astrologer(
      {
        this.per_min_chat,
        this.per_min_chat_offer,
        this.country,
        this.id, this.name, this.profileImg, this.experience, this.language});

  Astrologer.fromJson(Map<String, dynamic> json) {
    per_min_chat_offer = json['per_min_chat_offer'];
    per_min_chat = json['per_min_chat'];
    country = "INR";
    id = json['id'];
    name = json['name'];
    profileImg = json['profile_img'];
    experience = json['experience'];
    if (json['language'] != null) {
      language = <Language>[];
      json['language'].forEach((v) {
        language!.add(new Language.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['per_min_chat_offer'] = this.per_min_chat_offer;
    data['per_min_chat'] = this.per_min_chat;
    data['country'] = this.country;
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_img'] = this.profileImg;
    data['experience'] = this.experience;
    if (this.language != null) {
      data['language'] = this.language!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Language {
  String? name;

  Language({this.name});

  Language.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Live {
  String? id;
  String? name;
  String? profileImg;
  String? channelId;
  String? password;

  Live({this.id, this.name, this.profileImg, this.channelId, this.password});

  Live.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImg = json['profile_img'];
    channelId = json['channel_id'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_img'] = this.profileImg;
    data['channel_id'] = this.channelId;
    data['password'] = this.password;
    return data;
  }
}

class Testimonials {
  String? title;
  String? description;
  String? color;
  String? img;
  String? sId;

  Testimonials({this.title, this.description, this.color, this.img, this.sId});

  Testimonials.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    color = json['color'];
    img = json['img'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['color'] = this.color;
    data['img'] = this.img;
    data['_id'] = this.sId;
    return data;
  }
}

class VideoData {
  String? videoId;
  String? title;
  String? createdDate;
  String? updatedDate;
  String? isDelete;
  String? status;
  String? sId;
  int? iV;

  VideoData(
      {this.videoId,
        this.title,
        this.createdDate,
        this.updatedDate,
        this.isDelete,
        this.status,
        this.sId,
        this.iV});

  VideoData.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    title = json['title'];
    createdDate = json['Created_date'];
    updatedDate = json['Updated_date'];
    isDelete = json['is_delete'];
    status = json['status'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['Created_date'] = this.createdDate;
    data['Updated_date'] = this.updatedDate;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}