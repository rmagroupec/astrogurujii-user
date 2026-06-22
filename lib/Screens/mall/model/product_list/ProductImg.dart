
class ProductImg {
    String? id;
    String? image;

    ProductImg({this.id, this.image});

    factory ProductImg.fromJson(Map<String?, dynamic> json) {
        return ProductImg(
            id: json['_id'],
            image: json['image'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['_id'] = this.id;
        data['image'] = this.image;
        return data;
    }
}