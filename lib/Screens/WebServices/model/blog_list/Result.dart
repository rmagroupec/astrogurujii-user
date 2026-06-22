
class Result {
    String? auther;
    String? category;
    String? category_id;
    String? created_date;
    String? description;
    String? id;
    String? img;
    String? title;
    String? view_count;

    Result({this.view_count,this.auther, this.category, this.category_id, this.created_date, this.description, this.id, this.img, this.title});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            view_count: json['view_count'],
            auther: json['auther'],
            category: json['category'],
            category_id: json['category_id'], 
            created_date: json['Created_date'],
            description: json['description'], 
            id: json['id'], 
            img: json['img'], 
            title: json['title'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['view_count'] = this.view_count;
        data['auther'] = this.auther;
        data['category'] = this.category;
        data['category_id'] = this.category_id;
        data['Created_date'] = this.created_date;
        data['description'] = this.description;
        data['id'] = this.id;
        data['img'] = this.img;
        data['title'] = this.title;
        return data;
    }
}