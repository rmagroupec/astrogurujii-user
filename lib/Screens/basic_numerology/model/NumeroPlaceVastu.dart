
class NumeroPlaceVastu {
    String? description;
    String? title;

    NumeroPlaceVastu({this.description, this.title});

    factory NumeroPlaceVastu.fromJson(Map<String?, dynamic> json) {
        return NumeroPlaceVastu(
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