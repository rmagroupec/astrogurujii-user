
class NumeroFavTime {
    String? description;
    String? title;

    NumeroFavTime({this.description, this.title});

    factory NumeroFavTime.fromJson(Map<String?, dynamic> json) {
        return NumeroFavTime(
            description: json['description'], 
            title: json['title'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['description'] = this.description;
        data['title'] = this.title;
        return data;
    }
}