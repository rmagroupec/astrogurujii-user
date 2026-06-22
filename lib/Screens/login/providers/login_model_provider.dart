import 'package:get/get.dart';

import '../login_model_model.dart';

class LoginModelProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return LoginModel.fromJson(map);
      if (map is List)
        return map.map((item) => LoginModel.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'http://159.65.14.122:5001/user/login';
  }

  Future<LoginModel?> getLoginModel(int id) async {
    final response = await get('loginmodel/$id');
    return response.body;
  }

  Future<Response<LoginModel>> postLoginModel(LoginModel loginmodel) async =>
      await post('loginmodel', loginmodel);
  Future<Response> deleteLoginModel(int id) async =>
      await delete('loginmodel/$id');
}
