
class Result {
    String? image;
    String? tarot_desc;
    String? tarot_id;
    String? tarot_name;
    String? status;
    Result({this.status,this.image, this.tarot_desc, this.tarot_id, this.tarot_name});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            image: json['image'], 
            tarot_desc: json['tarot_desc'], 
            tarot_id: json['tarot_id'], 
            tarot_name: json['tarot_name'],
            status: json['status']??"N",
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['image'] = this.image;
        data['status'] = this.status;
        data['tarot_desc'] = this.tarot_desc;
        data['tarot_id'] = this.tarot_id;
        data['tarot_name'] = this.tarot_name;
        return data;
    }
}