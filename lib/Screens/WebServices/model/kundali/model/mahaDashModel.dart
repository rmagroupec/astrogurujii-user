class MahaDashaModel {
  bool? status;
  Data? data;

  MahaDashaModel({this.status, this.data});

  MahaDashaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? mahadasha;
  List<String>? mahadashaOrder;
  var startYear;
  var dashaStartDate;
 var dashaRemainingAtBirth;

  Data(
      {this.mahadasha,
        this.mahadashaOrder,
        this.startYear,
        this.dashaStartDate,
        this.dashaRemainingAtBirth});

  Data.fromJson(Map<String, dynamic> json) {
    mahadasha = json['mahadasha'].cast<String>();
    mahadashaOrder = json['mahadasha_order'].cast<String>();
    startYear = json['start_year'];
    dashaStartDate = json['dasha_start_date'];
    dashaRemainingAtBirth = json['dasha_remaining_at_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mahadasha'] = this.mahadasha;
    data['mahadasha_order'] = this.mahadashaOrder;
    data['start_year'] = this.startYear;
    data['dasha_start_date'] = this.dashaStartDate;
    data['dasha_remaining_at_birth'] = this.dashaRemainingAtBirth;
    return data;
  }
}
