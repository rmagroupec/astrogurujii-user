class CategoryModel {
  bool? status;
  var message;
  List<CategoryResults>? results;
  List<Lang>? lang;
  CategoryModel({this.status, this.message, this.results});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['results'] != null) {
      results = <CategoryResults>[];
      json['results'].forEach((v) {
        results!.add(CategoryResults.fromJson(v));
      });
    }
    if (json['lang'] != null) {
      lang = <Lang>[];
      json['lang'].forEach((v) {
        lang!.add(new Lang.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    if (this.lang != null) {
      data['lang'] = this.lang!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryResults {
  var id;
  var name;
  var image;
  var createdDate;
  var status;
  bool ?colorStatus;

  CategoryResults({this.id, this.name, this.image, this.createdDate, this.status,this.colorStatus});

  CategoryResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdDate = json['Created_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['Created_date'] = this.createdDate;
    data['status'] = this.status;
    return data;
  }
}

class Lang {
  var sId;
  var name;

  Lang({this.sId, this.name});

  Lang.fromJson(Map<String, dynamic> json) {
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