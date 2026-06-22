
class CallStatusUpdateModel {
    String? message;
    String? results;
    bool? status;

    CallStatusUpdateModel({this.message, this.results, this.status});

    factory CallStatusUpdateModel.fromJson(Map<String?, dynamic> json) {
        return CallStatusUpdateModel(
            message: json['message'], 
            results: json['results'], 
            status: json['status'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['message'] = this.message;
        data['results'] = this.results;
        data['status'] = this.status;
        return data;
    }
}