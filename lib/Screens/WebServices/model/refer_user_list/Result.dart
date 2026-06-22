
class Result {
    String? id;
    String? dob;
    String? email;
    String? gender;
    String? name;
    String? Created_date;
    String? number;
    String? pob;
    String? profile_img;
    String? rashi;
    String? tob;
    int? wallet;
    int? wallet_usd;

    Result({this.Created_date,this.id, this.dob, this.email, this.gender,  this.name, this.number, this.pob, this.profile_img, this.rashi, this.tob, this.wallet, this.wallet_usd});

    factory Result.fromJson(Map<String?, dynamic> json) {
        return Result(
            Created_date: json['Created_date'],
            id: json['id'],
            dob: json['dob'],
            email: json['email'], 
            gender: json['gender'],
            name: json['name'], 
            number: json['number'], 
            pob: json['pob'], 
            profile_img: json['profile_img'], 
            rashi: json['rashi'], 
            tob: json['tob'], 
            wallet: json['wallet'], 
            wallet_usd: json['wallet_usd'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['Created_date'] = this.Created_date;
        data['id'] = this.id;
        data['dob'] = this.dob;
        data['email'] = this.email;
        data['gender'] = this.gender;
        data['name'] = this.name;
        data['number'] = this.number;
        data['pob'] = this.pob;
        data['profile_img'] = this.profile_img;
        data['rashi'] = this.rashi;
        data['tob'] = this.tob;
        data['wallet'] = this.wallet;
        data['wallet_usd'] = this.wallet_usd;
        return data;
    }
}