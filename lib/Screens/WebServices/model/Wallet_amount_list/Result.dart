
class Resultss {
    String? offer_id;
    String? recharge_amount;
    String? offer;
    String? used_time;
    String? currency;
    String? msg;


    Resultss({this.offer_id,this.recharge_amount, this.offer, this.used_time, this.currency, this.msg});

    factory Resultss.fromJson(Map<String, dynamic> json) {
        return Resultss(
            offer_id: json['offer_id'],
            recharge_amount: json['recharge_amount'],
            offer: json['offer'],
            used_time: json['used_time'],
            currency: json['currency'],
            msg: json['msg'],

        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['offer_id'] = this.offer_id;
        data['recharge_amount'] = this.recharge_amount;
        data['offer'] = this.offer;
        data['used_time'] = this.used_time;
        data['currency'] = this.currency;
        data['msg'] = this.msg;
        return data;
    }
}