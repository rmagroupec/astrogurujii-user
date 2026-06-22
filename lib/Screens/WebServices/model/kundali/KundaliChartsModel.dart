import 'dart:convert';

class KundaliChartsModel {
  final String? status;
  final Message? message;

  KundaliChartsModel({
    this.status,
    this.message,
  });

  KundaliChartsModel copyWith({
    String? status,
    Message? message,
  }) =>
      KundaliChartsModel(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory KundaliChartsModel.fromRawJson(String str) =>
      KundaliChartsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KundaliChartsModel.fromJson(Map<String, dynamic> json) =>
      KundaliChartsModel(
        status: json["status"],
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
      };
}

class Message {
  final String? d1;
  final String? d9;
  final String? moon;
  final String? sun;
  final String? kp_chalit;

  Message({
    this.d1,
    this.d9,
    this.moon,
    this.sun,
    this.kp_chalit,
  });

  Message copyWith({
    String? d1,
    String? d9,
    String? moon,
    String? sun,
    String? kp_chalit,
  }) =>
      Message(
        d1: d1 ?? this.d1,
        d9: d9 ?? this.d9,
        moon: moon ?? this.moon,
        sun: sun ?? this.sun,
        kp_chalit: kp_chalit ?? this.kp_chalit,
      );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        d1: json["D1"],
        d9: json["D9"],
        moon: json["moon"],
        sun: json["sun"],
    kp_chalit: json["kp_chalit"],
      );

  Map<String, dynamic> toJson() => {
        "D1": d1,
        "D9": d9,
        "moon": moon,
        "sun": sun,
        "kp_chalit": kp_chalit,
      };
}
