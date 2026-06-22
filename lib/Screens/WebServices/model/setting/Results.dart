
class Results {
    var v;
    var id;
    var about_us;
    var astro_android_cur_int;
    var astro_android_man_int;
    var astro_ios_cur_int;
    var astro_ios_man_int;
    var contact_us;
    var created_date;
    var faqs;
    var privacy_policy;
    var rate_us;
    var refer_amount;
    var refer_amount_usd;
    var terms_and_conditions;
    var user_android_cur_int;
    var user_android_man_int;
    var user_ios_cur_int;
    var user_ios_man_int;
    var usermaintenance_status;
    var usermaintenance_image;
    var usermaintenance_text;

    Results({this.usermaintenance_text,this.usermaintenance_image,this.usermaintenance_status,this.v, this.id, this.about_us, this.astro_android_cur_int, this.astro_android_man_int, this.astro_ios_cur_int, this.astro_ios_man_int, this.contact_us, this.created_date, this.faqs, this.privacy_policy, this.rate_us, this.refer_amount, this.refer_amount_usd, this.terms_and_conditions, this.user_android_cur_int, this.user_android_man_int, this.user_ios_cur_int, this.user_ios_man_int});

    factory Results.fromJson(Map<String, dynamic> json) {
        return Results(
            v: json['__v'],
            id: json['_id'],
            usermaintenance_image: json['usermaintenance_image'],
            usermaintenance_status: json['usermaintenance_status'],
            usermaintenance_text: json['usermaintenance_text'],
            about_us: json['about_us'],
            astro_android_cur_int: json['astro_android_cur_int'],
            astro_android_man_int: json['astro_android_man_int'], 
            astro_ios_cur_int: json['astro_ios_cur_int'], 
            astro_ios_man_int: json['astro_ios_man_int'], 
            contact_us: json['contact_us'], 
            created_date: json['created_date'], 
            faqs: json['faqs'], 
            privacy_policy: json['privacy_policy'], 
            rate_us: json['rate_us'], 
            refer_amount: json['refer_amount'], 
            refer_amount_usd: json['refer_amount_usd'], 
            terms_and_conditions: json['terms_and_conditions'], 
            user_android_cur_int: json['user_android_cur_int'], 
            user_android_man_int: json['user_android_man_int'], 
            user_ios_cur_int: json['user_ios_cur_int'], 
            user_ios_man_int: json['user_ios_man_int'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['__v'] = this.v;
        data['_id'] = this.id;
        data['usermaintenance_status'] = this.usermaintenance_status;
        data['usermaintenance_image'] = this.usermaintenance_image;
        data['usermaintenance_text'] = this.usermaintenance_text;
        data['about_us'] = this.about_us;
        data['astro_android_cur_int'] = this.astro_android_cur_int;
        data['astro_android_man_int'] = this.astro_android_man_int;
        data['astro_ios_cur_int'] = this.astro_ios_cur_int;
        data['astro_ios_man_int'] = this.astro_ios_man_int;
        data['contact_us'] = this.contact_us;
        data['created_date'] = this.created_date;
        data['faqs'] = this.faqs;
        data['privacy_policy'] = this.privacy_policy;
        data['rate_us'] = this.rate_us;
        data['refer_amount'] = this.refer_amount;
        data['refer_amount_usd'] = this.refer_amount_usd;
        data['terms_and_conditions'] = this.terms_and_conditions;
        data['user_android_cur_int'] = this.user_android_cur_int;
        data['user_android_man_int'] = this.user_android_man_int;
        data['user_ios_cur_int'] = this.user_ios_cur_int;
        data['user_ios_man_int'] = this.user_ios_man_int;
        return data;
    }
}