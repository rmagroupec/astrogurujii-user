
class ReportIntakeForm {
    String? address;
    String? amount;
    String? ans_language;
    String? any_comments;
    String? astro_id;
    String? created_at;
    String? dob;
    String? first_name;
    String? gender;
    String? gst;
    String? id;
    String? is_payment_done;
    String? last_name;
    String? marital_status;
    String? number;
    String? occupation;
    String? pob;
    String? reply;
    String? file;
    String? report_type;
    String? status;
    String? tob;
    String? total_price;
    String? updated_at;
    String? user_id;

    ReportIntakeForm({this.file,this.address, this.amount, this.ans_language, this.any_comments, this.astro_id, this.created_at, this.dob, this.first_name, this.gender, this.gst, this.id, this.is_payment_done, this.last_name, this.marital_status, this.number, this.occupation, this.pob, this.reply, this.report_type, this.status, this.tob, this.total_price, this.updated_at, this.user_id});

    factory ReportIntakeForm.fromJson(Map<String, dynamic> json) {
        return ReportIntakeForm(
            file: json['file'],
            address: json['address'],
            amount: json['amount'],
            ans_language: json['ans_language'], 
            any_comments: json['any_comments'], 
            astro_id: json['astro_id'], 
            created_at: json['created_at'], 
            dob: json['dob'], 
            first_name: json['first_name'], 
            gender: json['gender'], 
            gst: json['gst'], 
            id: json['id'], 
            is_payment_done: json['is_payment_done'], 
            last_name: json['last_name'], 
            marital_status: json['marital_status'], 
            number: json['number'], 
            occupation: json['occupation'], 
            pob: json['pob'], 
            reply: json['reply'], 
            report_type: json['report_type'], 
            status: json['status'], 
            tob: json['tob'], 
            total_price: json['total_price'], 
            updated_at: json['updated_at'], 
            user_id: json['user_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['file'] = this.file;
        data['address'] = this.address;
        data['amount'] = this.amount;
        data['ans_language'] = this.ans_language;
        data['any_comments'] = this.any_comments;
        data['astro_id'] = this.astro_id;
        data['created_at'] = this.created_at;
        data['dob'] = this.dob;
        data['first_name'] = this.first_name;
        data['gender'] = this.gender;
        data['gst'] = this.gst;
        data['id'] = this.id;
        data['is_payment_done'] = this.is_payment_done;
        data['last_name'] = this.last_name;
        data['marital_status'] = this.marital_status;
        data['number'] = this.number;
        data['occupation'] = this.occupation;
        data['pob'] = this.pob;
        data['reply'] = this.reply;
        data['report_type'] = this.report_type;
        data['status'] = this.status;
        data['tob'] = this.tob;
        data['total_price'] = this.total_price;
        data['updated_at'] = this.updated_at;
        data['user_id'] = this.user_id;
        return data;
    }
}