class AntarDashaModel {
  final bool status;
  final AntarDashaData data;

  AntarDashaModel({required this.status, required this.data});

  factory AntarDashaModel.fromJson(Map<String, dynamic> json) {
    return AntarDashaModel(
      status: json['status'],
      data: AntarDashaData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class AntarDashaData {
  final List<List<String>> antardashas;
  final List<List<String>> antardashaOrder;

  AntarDashaData({required this.antardashas, required this.antardashaOrder});

  factory AntarDashaData.fromJson(Map<String, dynamic> json) {
    return AntarDashaData(
      antardashas: (json['antardashas'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      antardashaOrder: (json['antardasha_order'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'antardashas': antardashas.map((e) => e.map((e) => e).toList()).toList(),
      'antardasha_order': antardashaOrder.map((e) => e.map((e) => e).toList()).toList(),
    };
  }
}
