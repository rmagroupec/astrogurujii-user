
class ImageModel {
    String? file_name;
    String? message;
    bool? result;
    String? url;

    ImageModel({this.file_name, this.message, this.result, this.url});

    factory ImageModel.fromJson(Map<String?, dynamic> json) {
        return ImageModel(
            file_name: json['file_name'], 
            message: json['message'], 
            result: json['result'], 
            url: json['url'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['file_name'] = this.file_name;
        data['message'] = this.message;
        data['result'] = this.result;
        data['url'] = this.url;
        return data;
    }
}