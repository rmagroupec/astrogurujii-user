
class AstroDetail {
    String? ascendant;
    String? ascendant_lord;
    int? charan;
    String? gan;
    String? karan;
    String? nadi;
    String? naksahtra;
    String? naksahtraLord;
    String? name_alphabet;
    String? paya;
    String? sign;
    String? signLord;
    String? tatva;
    String? tithi;
    String? varna;
    String? vashya;
    String? yog;
    String? yoni;
    String? yunja;

    AstroDetail({this.ascendant, this.ascendant_lord, this.charan, this.gan, this.karan, this.nadi, this.naksahtra, this.naksahtraLord, this.name_alphabet, this.paya, this.sign, this.signLord, this.tatva, this.tithi, this.varna, this.vashya, this.yog, this.yoni, this.yunja});

    factory AstroDetail.fromJson(Map<String?, dynamic> json) {
        return AstroDetail(
            ascendant: json['ascendant'], 
            ascendant_lord: json['ascendant_lord'], 
            charan: json['Charan'],
            gan: json['Gan'],
            karan: json['Karan'],
            nadi: json['Nadi'],
            naksahtra: json['Naksahtra'],
            naksahtraLord: json['NaksahtraLord'],
            name_alphabet: json['name_alphabet'], 
            paya: json['paya'], 
            sign: json['sign'], 
            signLord: json['SignLord'],
            tatva: json['tatva'], 
            tithi: json['Tithi'],
            varna: json['Varna'],
            vashya: json['Vashya'],
            yog: json['Yog'],
            yoni: json['Yoni'],
            yunja: json['yunja'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['ascendant'] = this.ascendant;
        data['ascendant_lord'] = this.ascendant_lord;
        data['Charan'] = this.charan;
        data['Gan'] = this.gan;
        data['Karan'] = this.karan;
        data['Nadi'] = this.nadi;
        data['Naksahtra'] = this.naksahtra;
        data['naksahtraLord'] = this.naksahtraLord;
        data['NaksahtraLord'] = this.name_alphabet;
        data['paya'] = this.paya;
        data['sign'] = this.sign;
        data['SignLord'] = this.signLord;
        data['tatva'] = this.tatva;
        data['Tithi'] = this.tithi;
        data['Varna'] = this.varna;
        data['Vashya'] = this.vashya;
        data['Yog'] = this.yog;
        data['Yoni'] = this.yoni;
        data['yunja'] = this.yunja;
        return data;
    }
}