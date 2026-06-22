
import 'package:astro_gurujii/Screens/mall/model/product_list/ProductImg.dart';

class Result {
    String? benefits;
    String? category_name;
    String? created_date;
    String? details;
    String? display_image;
    String? id;
    String? is_favorite;
    String? mrp;
    String? name;
    String? price;
    List<ProductImg>? product_img;
    int? qty;

    Result({this.benefits, this.category_name, this.created_date, this.details, this.display_image, this.id, this.is_favorite, this.mrp, this.name, this.price, this.product_img, this.qty});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            benefits: json['benefits'], 
            category_name: json['category_name'], 
            created_date: json['created_date'], 
            details: json['details'], 
            display_image: json['display_image'], 
            id: json['id'], 
            is_favorite: json['is_favorite'], 
            mrp: json['mrp'], 
            name: json['name'], 
            price: json['price'], 
            product_img: json['product_img'] != null ? (json['product_img'] as List).map((i) => ProductImg.fromJson(i)).toList() : null, 
            qty: json['qty'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['benefits'] = this.benefits;
        data['category_name'] = this.category_name;
        data['created_date'] = this.created_date;
        data['details'] = this.details;
        data['display_image'] = this.display_image;
        data['id'] = this.id;
        data['is_favorite'] = this.is_favorite;
        data['mrp'] = this.mrp;
        data['name'] = this.name;
        data['price'] = this.price;
        data['qty'] = this.qty;
        if (this.product_img != null) {
            data['product_img'] = this.product_img!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}