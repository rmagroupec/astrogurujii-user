class UploadImageModel {
  bool? status;
  String? message;
  String? results;

  UploadImageModel({this.status, this.message, this.results});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    results = json['results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['results'] = this.results;
    return data;
  }
}
