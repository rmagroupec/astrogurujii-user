
class Context {
    String? key;
    String? label;
    int? limit;
    String? value;

    Context({this.key, this.label, this.limit, this.value});

    factory Context.fromJson(Map<String?, dynamic> json) {
        return Context(
            key: json['key'], 
            label: json['label'], 
            limit: json['limit'], 
            value: json['value'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['key'] = this.key;
        data['label'] = this.label;
        data['limit'] = this.limit;
        data['value'] = this.value;
        return data;
    }
}