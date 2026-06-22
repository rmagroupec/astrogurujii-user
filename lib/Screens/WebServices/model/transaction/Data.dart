
class Data {
    int? amount;
    String? amount_type;
    String? amount_type_for;
    String? astro_name;
    String? astrologer_id;
    String? channel_id;
    String? created_at;
    int? debit_user_id;
    String? description;
    String? id;
    String? remedy;
    String? remedy_id;
    String? time;
    String? transaction_date;
    String? type;
    String? user_id;
    var order_id;
    String? per_min_charge;
    String? astro_image;

    Data({this.astro_image,this.order_id,this.per_min_charge,this.amount, this.amount_type, this.amount_type_for, this.astro_name, this.astrologer_id, this.channel_id, this.created_at, this.debit_user_id, this.description, this.id, this.remedy, this.remedy_id, this.time, this.transaction_date, this.type, this.user_id});

    factory Data.fromJson(Map<String?, dynamic> json) {
        return Data(
            astro_image: json['astro_image'],
            order_id: json['order_id'],
            per_min_charge: json['per_min_charge'],
            amount: json['amount'],
            amount_type: json['amount_type'],
            amount_type_for: json['amount_type_for'], 
            astro_name: json['astro_name'], 
            astrologer_id: json['astrologer_id'], 
            channel_id: json['channel_id'], 
            created_at: json['created_at'], 
            debit_user_id: json['debit_user_id'], 
            description: json['description'], 
            id: json['id'], 
            remedy: json['remedy'], 
            remedy_id: json['remedy_id'], 
            time: json['time'], 
            transaction_date: json['transaction_date'], 
            type: json['type'], 
            user_id: json['user_id'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['astro_image'] = this.astro_image;
        data['order_id'] = this.order_id;
        data['per_min_charge'] = this.per_min_charge;
        data['amount'] = this.amount;
        data['amount_type'] = this.amount_type;
        data['amount_type_for'] = this.amount_type_for;
        data['astro_name'] = this.astro_name;
        data['astrologer_id'] = this.astrologer_id;
        data['channel_id'] = this.channel_id;
        data['created_at'] = this.created_at;
        data['debit_user_id'] = this.debit_user_id;
        data['description'] = this.description;
        data['id'] = this.id;
        data['remedy'] = this.remedy;
        data['remedy_id'] = this.remedy_id;
        data['time'] = this.time;
        data['transaction_date'] = this.transaction_date;
        data['type'] = this.type;
        data['user_id'] = this.user_id;
        return data;
    }
}