
class NumeroTable {
    String? date;
    int? destiny_number;
    String? evil_num;
    String? fav_color;
    String? fav_day;
    String? fav_god;
    String? fav_mantra;
    String? fav_metal;
    String? fav_stone;
    String? fav_substone;
    String? friendly_num;
    String? name;
    int? name_number;
    String? neutral_num;
    String? radical_num;
    int? radical_number;
    String? radical_ruler;

    NumeroTable({this.date, this.destiny_number, this.evil_num, this.fav_color, this.fav_day, this.fav_god, this.fav_mantra, this.fav_metal, this.fav_stone, this.fav_substone, this.friendly_num, this.name, this.name_number, this.neutral_num, this.radical_num, this.radical_number, this.radical_ruler});

    factory NumeroTable.fromJson(Map<String?, dynamic> json) {
        return NumeroTable(
            date: json['date'], 
            destiny_number: json['destiny_number'], 
            evil_num: json['evil_num'], 
            fav_color: json['fav_color'], 
            fav_day: json['fav_day'], 
            fav_god: json['fav_god'], 
            fav_mantra: json['fav_mantra'], 
            fav_metal: json['fav_metal'], 
            fav_stone: json['fav_stone'], 
            fav_substone: json['fav_substone'], 
            friendly_num: json['friendly_num'], 
            name: json['name'], 
            name_number: json['name_number'], 
            neutral_num: json['neutral_num'], 
            radical_num: json['radical_num'], 
            radical_number: json['radical_number'], 
            radical_ruler: json['radical_ruler'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['date'] = this.date;
        data['destiny_number'] = this.destiny_number;
        data['evil_num'] = this.evil_num;
        data['fav_color'] = this.fav_color;
        data['fav_day'] = this.fav_day;
        data['fav_god'] = this.fav_god;
        data['fav_mantra'] = this.fav_mantra;
        data['fav_metal'] = this.fav_metal;
        data['fav_stone'] = this.fav_stone;
        data['fav_substone'] = this.fav_substone;
        data['friendly_num'] = this.friendly_num;
        data['name'] = this.name;
        data['name_number'] = this.name_number;
        data['neutral_num'] = this.neutral_num;
        data['radical_num'] = this.radical_num;
        data['radical_number'] = this.radical_number;
        data['radical_ruler'] = this.radical_ruler;
        return data;
    }
}