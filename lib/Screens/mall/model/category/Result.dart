
class Result {
    String? created_date;
    String? description;
    String? id;
    String? image;
    String? name;

    Result({this.created_date, this.description, this.id, this.image, this.name});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            created_date: json['created_date'], 
            description: json['description'], 
            id: json['id'], 
            image: json['image'], 
            name: json['name'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['created_date'] = this.created_date;
        data['description'] = this.description;
        data['id'] = this.id;
        data['image'] = this.image;
        data['name'] = this.name;
        return data;
    }
}