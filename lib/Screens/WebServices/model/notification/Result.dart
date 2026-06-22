
class Result {
    String? created_date;
    String? id;
    String? image;
    String? is_seen;
    String? text;
    String? title;

    Result({this.created_date, this.id, this.image, this.is_seen, this.text, this.title});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            created_date: json['Created_date'],
            id: json['id'], 
            image: json['image'], 
            is_seen: json['is_seen'], 
            text: json['text'], 
            title: json['title'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['Created_date'] = this.created_date;
        data['id'] = this.id;
        data['image'] = this.image;
        data['is_seen'] = this.is_seen;
        data['text'] = this.text;
        data['title'] = this.title;
        return data;
    }
}