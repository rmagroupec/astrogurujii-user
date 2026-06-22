class ViewDetailsModel {
  bool? status;
  UserDetails? userDetails;

  ViewDetailsModel({this.status, this.userDetails});

  ViewDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? name;
  String? purposeOfPooja;
  String? gotra;
  String? place;
  String? email;
  String? whatsappNumber;
  String? courierAddress;

  UserDetails(
      {this.name,
        this.purposeOfPooja,
        this.gotra,
        this.place,
        this.email,
        this.whatsappNumber,
        this.courierAddress});

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    purposeOfPooja = json['purposeOfPooja'];
    gotra = json['gotra'];
    place = json['place'];
    email = json['email'];
    whatsappNumber = json['whatsappNumber'];
    courierAddress = json['courierAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['purposeOfPooja'] = this.purposeOfPooja;
    data['gotra'] = this.gotra;
    data['place'] = this.place;
    data['email'] = this.email;
    data['whatsappNumber'] = this.whatsappNumber;
    data['courierAddress'] = this.courierAddress;
    return data;
  }
}
