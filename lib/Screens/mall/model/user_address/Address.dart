
class Address {
    int? v;
    String? id;
    String? address;
    String? address_type;
    String? building_name;
    String? city_id;
    String? contact_person_mobile;
    String? contact_person_name;
    String? created_at;
    String? created_date;
    String? is_default;
    String? landmark;
    String? lat;
    String? latitude;
    String? location;
    String? long;
    String? longitude;
    String? note;
    String? pincode;
    String? states_id;
    String? status;
    String? updated_at;
    String? updated_date;
    String? user_id;
    String? flat_no;

    Address({this.flat_no,this.v, this.id, this.address, this.address_type, this.building_name, this.city_id, this.contact_person_mobile, this.contact_person_name, this.created_at, this.created_date, this.is_default, this.landmark, this.lat, this.latitude, this.location, this.long, this.longitude, this.note, this.pincode, this.states_id, this.status, this.updated_at, this.updated_date, this.user_id});

    factory Address.fromJson(Map<String?, dynamic> json) {
        return Address(
            v: json['__v'],
            id: json['_id'],
            address: json['address'],
            flat_no: json['flat_no'],
            address_type: json['address_type'],
            building_name: json['building_name'], 
            city_id: json['city_id'], 
            contact_person_mobile: json['contact_person_mobile'], 
            contact_person_name: json['contact_person_name'], 
            created_at: json['created_at'], 
            created_date: json['created_date'], 
            is_default: json['is_default'], 
            landmark: json['landmark'], 
            lat: json['lat'], 
            latitude: json['latitude'], 
            location: json['location'], 
            long: json['long'], 
            longitude: json['longitude'], 
            note: json['note'], 
            pincode: json['pincode'], 
            states_id: json['states_id'], 
            status: json['status'], 
            updated_at: json['updated_at'], 
            updated_date: json['updated_date'], 
            user_id: json['user_id'], 
        );
    }

    Map<String?, dynamic> toJson() {
        final Map<String?, dynamic> data = new Map<String?, dynamic>();
        data['__v'] = this.v;
        data['_id'] = this.id;
        data['address'] = this.address;
        data['flat_no'] = this.flat_no;
        data['address_type'] = this.address_type;
        data['building_name'] = this.building_name;
        data['city_id'] = this.city_id;
        data['contact_person_mobile'] = this.contact_person_mobile;
        data['contact_person_name'] = this.contact_person_name;
        data['created_at'] = this.created_at;
        data['created_date'] = this.created_date;
        data['is_default'] = this.is_default;
        data['landmark'] = this.landmark;
        data['lat'] = this.lat;
        data['latitude'] = this.latitude;
        data['location'] = this.location;
        data['long'] = this.long;
        data['longitude'] = this.longitude;
        data['note'] = this.note;
        data['pincode'] = this.pincode;
        data['states_id'] = this.states_id;
        data['status'] = this.status;
        data['updated_at'] = this.updated_at;
        data['updated_date'] = this.updated_date;
        data['user_id'] = this.user_id;
        return data;
    }
}