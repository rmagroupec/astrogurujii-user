
class FemaleAstroDetailsX {
    var ascendant;
    var charan;
    var gan;
    var karan;
    var nadi;
    var naksahtra;
    var naksahtraLord;
    var name_alphabet;
    var paya;
    var sign;
    var signLord;
    var tatva;
    var tithi;
    var varna;
    var vashya;
    var yog;
    var yoni;
    var yunja;

    FemaleAstroDetailsX({this.ascendant, this.charan, this.gan, this.karan, this.nadi, this.naksahtra, this.naksahtraLord, this.name_alphabet, this.paya, this.sign, this.signLord, this.tatva, this.tithi, this.varna, this.vashya, this.yog, this.yoni, this.yunja});

    factory FemaleAstroDetailsX.fromJson(Map<String, dynamic> json) {
        return FemaleAstroDetailsX(
            ascendant: json['ascendant'], 
            charan: json['charan'], 
            gan: json['gan'], 
            karan: json['karan'], 
            nadi: json['nadi'], 
            naksahtra: json['naksahtra'], 
            naksahtraLord: json['naksahtraLord'], 
            name_alphabet: json['name_alphabet'], 
            paya: json['paya'], 
            sign: json['sign'], 
            signLord: json['signLord'], 
            tatva: json['tatva'], 
            tithi: json['tithi'], 
            varna: json['varna'], 
            vashya: json['vashya'], 
            yog: json['yog'], 
            yoni: json['yoni'], 
            yunja: json['yunja'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ascendant'] = this.ascendant;
        data['charan'] = this.charan;
        data['gan'] = this.gan;
        data['karan'] = this.karan;
        data['nadi'] = this.nadi;
        data['naksahtra'] = this.naksahtra;
        data['naksahtraLord'] = this.naksahtraLord;
        data['name_alphabet'] = this.name_alphabet;
        data['paya'] = this.paya;
        data['sign'] = this.sign;
        data['signLord'] = this.signLord;
        data['tatva'] = this.tatva;
        data['tithi'] = this.tithi;
        data['varna'] = this.varna;
        data['vashya'] = this.vashya;
        data['yog'] = this.yog;
        data['yoni'] = this.yoni;
        data['yunja'] = this.yunja;
        return data;
    }
}