
class Result {
    String? banner;
    String? country;
    String? created_at;
    String? description;
    String? id;
    String? is_delete;
    String? price;
    String? status;
    String? type;
    String? updated_at;

    Result({this.banner, this.country, this.created_at, this.description, this.id, this.is_delete, this.price, this.status, this.type, this.updated_at});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            banner: json['banner'], 
            country: "INR",
            created_at: json['created_at'], 
            description: json['description'], 
            id: json['id'], 
            is_delete: json['is_delete'], 
            price: json['price'], 
            status: json['status'], 
            type: json['type'], 
            updated_at: json['updated_at'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['banner'] = this.banner;
        data['country'] = this.country;
        data['created_at'] = this.created_at;
        data['description'] = this.description;
        data['id'] = this.id;
        data['is_delete'] = this.is_delete;
        data['price'] = this.price;
        data['status'] = this.status;
        data['type'] = this.type;
        data['updated_at'] = this.updated_at;
        return data;
    }
}