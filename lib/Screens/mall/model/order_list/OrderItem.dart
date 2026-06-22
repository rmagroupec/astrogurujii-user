
class OrderItem {
    String? created_at;
    String? image;
    String? itemID;
    String? net_price;
    String? orderID;
    String? price;
    String? productID;
    String? product_name;
    String? qty;
    String? status;
    String? updated_at;

    OrderItem({this.created_at, this.image, this.itemID, this.net_price, this.orderID, this.price, this.productID, this.product_name, this.qty, this.status, this.updated_at});

    factory OrderItem.fromJson(Map<String?, dynamic> json) {
        return OrderItem(
            created_at: json['created_at'], 
            image: json['image'], 
            itemID: json['itemID'], 
            net_price: json['net_price'], 
            orderID: json['orderID'], 
            price: json['price'], 
            productID: json['productID'], 
            product_name: json['product_name'], 
            qty: json['qty'], 
            status: json['status'], 
            updated_at: json['updated_at'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['created_at'] = this.created_at;
        data['image'] = this.image;
        data['itemID'] = this.itemID;
        data['net_price'] = this.net_price;
        data['orderID'] = this.orderID;
        data['price'] = this.price;
        data['productID'] = this.productID;
        data['product_name'] = this.product_name;
        data['qty'] = this.qty;
        data['status'] = this.status;
        data['updated_at'] = this.updated_at;
        return data;
    }
}