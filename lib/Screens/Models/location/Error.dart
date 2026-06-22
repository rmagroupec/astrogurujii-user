
import 'package:astro_gurujii/Screens/Models/location/Context.dart';

class Error {
    Context? context;
    String? message;
    List<String>? path;
    String? type;

    Error({this.context, this.message, this.path, this.type});

    factory Error.fromJson(Map<String, dynamic> json) {
        return Error(
            context: json['context'] != null ? Context.fromJson(json['context']) : null, 
            message: json['message'], 
            path: json['path'] != null ? new List<String>.from(json['path']) : null, 
            type: json['type'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['type'] = this.type;
        if (this.context != null) {
            data['context'] = this.context!.toJson();
        }
        if (this.path != null) {
            data['path'] = this.path;
        }
        return data;
    }
}