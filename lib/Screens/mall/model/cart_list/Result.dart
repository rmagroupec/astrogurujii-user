
class Result {
    String? created_date;
    String? id;
    String? mrp;
    String? price;
    String? product_id;
    String? product_name;
    String? qty;
    String? sum_price;
    String? display_image;

    Result({this.display_image,this.created_date, this.id, this.mrp, this.price, this.product_id, this.product_name, this.qty, this.sum_price});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            created_date: json['created_date'], 
            id: json['id'], 
            mrp: json['mrp'], 
            price: json['price'], 
            product_id: json['product_id'], 
            product_name: json['product_name'], 
            qty: json['qty'], 
            sum_price: json['sum_price'],
            display_image: json['display_image'],
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['created_date'] = this.created_date;
        data['id'] = this.id;
        data['mrp'] = this.mrp;
        data['price'] = this.price;
        data['product_id'] = this.product_id;
        data['product_name'] = this.product_name;
        data['qty'] = this.qty;
        data['sum_price'] = this.sum_price;
        data['display_image'] = this.display_image;
        return data;
    }
}