
import 'package:astro_gurujii/Screens/mall/model/user_address/Address.dart';

class UserAddressModel {
    List<Address>? address_list;
    String? message;
    bool? result;

    UserAddressModel({this.address_list, this.message, this.result});

    factory UserAddressModel.fromJson(Map<String, dynamic> json) {
        return UserAddressModel(
            address_list: json['address_list'] != null ? (json['address_list'] as List).map((i) => Address.fromJson(i)).toList() : null, 
            message: json['message'], 
            result: json['result'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['result'] = this.result;
        if (this.address_list != null) {
            data['address_list'] = this.address_list!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}