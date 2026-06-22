
class Prediction {
    String description;

    Prediction({required this.description});

    factory Prediction.fromJson(Map<String, dynamic> json) {
        return Prediction(
            description: json['description'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['description'] = this.description;
        return data;
    }
}