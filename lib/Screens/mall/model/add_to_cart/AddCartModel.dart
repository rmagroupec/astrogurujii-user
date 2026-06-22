
class AddCartModel {
    String? message;
    bool? status;
    String? item_count;

    AddCartModel({this.item_count,this.message, this.status});

    factory AddCartModel.fromJson(Map<String, dynamic> json) {
        return AddCartModel(
            message: json['message'],
            status: json['status'],
            item_count: json['item_count'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['status'] = this.status;
        data['item_count'] = this.item_count;
        return data;
    }
}