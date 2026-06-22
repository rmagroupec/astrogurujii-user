
class Result {
    var coupan_code;
    String? coupan_discount;
    String? discount_amount_up_to;
    String? discount_type;
    String? end_date;
    String? id;
    String? img;
    String? minimum_order_price;
    String? per_user_use;
    var user_coupan_user_count;
    var title;
    String? start_date;
    String? type;

    Result({this.title,this.user_coupan_user_count,this.coupan_code, this.coupan_discount, this.discount_amount_up_to, this.discount_type, this.end_date, this.id, this.img, this.minimum_order_price, this.per_user_use, this.start_date, this.type});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            title: json['title'],
            user_coupan_user_count: json['user_coupan_user_count'],
            coupan_code: json['coupan_code'],
            coupan_discount: json['coupan_discount'],
            discount_amount_up_to: json['discount_amount_up_to'], 
            discount_type: json['discount_type'], 
            end_date: json['end_date'], 
            id: json['id'], 
            img: json['img'], 
            minimum_order_price: json['minimum_order_price'], 
            per_user_use: json['per_user_use'], 
            start_date: json['start_date'], 
            type: json['type'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['title'] = this.title;
        data['user_coupan_user_count'] = this.user_coupan_user_count;
        data['coupan_code'] = this.coupan_code;
        data['coupan_discount'] = this.coupan_discount;
        data['discount_amount_up_to'] = this.discount_amount_up_to;
        data['discount_type'] = this.discount_type;
        data['end_date'] = this.end_date;
        data['id'] = this.id;
        data['img'] = this.img;
        data['minimum_order_price'] = this.minimum_order_price;
        data['per_user_use'] = this.per_user_use;
        data['start_date'] = this.start_date;
        data['type'] = this.type;
        return data;
    }
}