
class CallInitiateModel {
    String? channel_id;
    String? fb_channel_id;
    String? message;
    String? results;
    bool? status;
    String? agora_token;

    CallInitiateModel({this.fb_channel_id,this.channel_id, this.message, this.results, this.status, this.agora_token});

    factory CallInitiateModel.fromJson(Map<String?, dynamic> json) {
        return CallInitiateModel(
            channel_id: json['channel_id'],
            fb_channel_id: json['fb_channel_id'],
            message: json['message'],
            results: json['results'],
            status: json['status'],
            agora_token: json["agora_token"]
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['channel_id'] = this.channel_id;
        data['fb_channel_id'] = this.fb_channel_id;
        data['message'] = this.message;
        data['results'] = this.results;
        data['status'] = this.status;
        data['agora_token'] = this.agora_token!;
        return data;
    }
}