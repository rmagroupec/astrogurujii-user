
class Result {
    String? astro_name;
    String? created_at;
    String? id;
    String? price;
    String? question;
    String? reply;
    String? status;
    String? pob;
    String? tob;
    String? name;
    String? gender;

    Result({this.pob,this.tob,this.name,this.gender,this.astro_name, this.created_at, this.id, this.price, this.question, this.reply, this.status});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            astro_name: json['astro_name'], 
            created_at: json['created_at'], 
            id: json['id'], 
            price: json['price'], 
            question: json['question'], 
            reply: json['reply'],
            pob: json['pob'],
            tob: json['tob'],
            name: json['name'],
            gender: json['gender'],
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['astro_name'] = this.astro_name;
        data['created_at'] = this.created_at;
        data['id'] = this.id;
        data['price'] = this.price;
        data['question'] = this.question;
        data['reply'] = this.reply;
        data['status'] = this.status;
        data['pob'] = this.pob;
        data['tob'] = this.tob;
        data['name'] = this.name;
        data['gender'] = this.gender;
        return data;
    }
}