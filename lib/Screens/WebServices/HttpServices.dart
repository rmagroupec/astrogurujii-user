import 'dart:developer';
import 'dart:io';

import 'package:astro_gurujii/Screens/Models/AstroDetailsModel.dart';
import 'package:astro_gurujii/Screens/Models/AstrologerModel.dart';
import 'package:astro_gurujii/Screens/Models/CategoryModel.dart';
import 'package:astro_gurujii/Screens/Models/CheckNumberModel.dart';
import 'package:astro_gurujii/Screens/Models/GetGiftModel.dart';
 import 'package:astro_gurujii/Screens/Models/HomeDataModel.dart';
import 'package:astro_gurujii/Screens/Models/RegisterOtpModel.dart';
import 'package:astro_gurujii/Screens/Models/UpdateProfileModel.dart';
import 'package:astro_gurujii/Screens/Models/UploadImageModel.dart';
import 'package:astro_gurujii/Screens/Models/UserLoginModel.dart';
import 'package:astro_gurujii/Screens/Models/UserRegisterModel.dart';
import 'package:astro_gurujii/Screens/Models/last_call_list/LastCallListModel.dart';
import 'package:astro_gurujii/Screens/Models/location/LocationModel.dart';
import 'package:astro_gurujii/Screens/Models/profileModel.dart';
import 'package:astro_gurujii/Screens/Models/review_list_by_channel_id/RatingListDetailModel.dart';
import 'package:astro_gurujii/Screens/WebServices/api_helper.dart';
import 'package:astro_gurujii/Screens/WebServices/model/LatitudeModel/LatiduseModels.dart';
import 'package:astro_gurujii/Screens/WebServices/model/UserReportList/UserReportListModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/Wallet_amount_list/WalletAmountListModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/blog_list/BlogListModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/call_initiate/CallInitiateModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/call_initiate_status/CallInitiateStatusModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/call_status_update/CallStatusUpdateModel.dart';
 import 'package:astro_gurujii/Screens/WebServices/model/google_map/AutoSuggetionApi.dart';
 import 'package:astro_gurujii/Screens/WebServices/model/major_vdasha/MajorDashaModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/notification/Notifications.dart';
import 'package:astro_gurujii/Screens/WebServices/model/refer_user_list/ReferUserListModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/setting/SettingModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/transaction/TransactionModel.dart';
import 'package:astro_gurujii/Screens/WebServices/model/user_question/UserQuestionModel.dart';
import 'package:astro_gurujii/Screens/basic_numerology/model/BasicNumerologyModel.dart';
import 'package:astro_gurujii/Screens/mall/model/cart_list/CartListModel.dart';
import 'package:astro_gurujii/Screens/mall/model/category/CategoryListModel.dart';
 import 'package:astro_gurujii/Screens/mall/model/product_list/ProductListModel.dart';
import 'package:astro_gurujii/Screens/mall/model/user_address/UserAddressModel.dart';
import 'package:astro_gurujii/Screens/match_details/model/MatchingDetails.dart';
import 'package:astro_gurujii/Screens/offer/model/OfferListModel.dart';
import 'package:astro_gurujii/Screens/panchange/model/PanchangeModel.dart';
import 'package:astro_gurujii/Screens/report/model/ReportListModel.dart';
import 'package:astro_gurujii/Screens/torat/model/TarotModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MatchingDetails.dart';
import '../Models/live_listing/live_listing_reponse.dart';
import '../Models/register_astro/AstroStatusModel.dart';
import '../Models/register_astro/RegisterAstroModel.dart';
import '../Models/testimonilas/AllTestimonialsModel.dart';
import '../TalkAstrologer/bannerModel.dart';
import '../homeScreen/chatLisitngModel.dart';
import '../mall/astroMallBannerModel.dart';
import '../mall/model/add_to_cart/AddCartModel.dart';
 import '../mall/order_details_model.dart';
import '../poojaScreen/model/poojDetailsModel.dart';
import '../poojaScreen/model/poojaBookingResponse.dart';
import '../poojaScreen/model/poojaListingModel.dart';
import '../pooja_orders/model/PoojaBookingsModel.dart';
import '../pooja_orders/model/view_details_model.dart';
import '../transection_screen/transactionGiftModel.dart';
import 'model/get_daily_sun_horoscope_model/get_daily_sun_horoscope.dart';
import 'model/kundali/KundaliChartsModel.dart';
import 'model/kundali/model/KundaliModel.dart';
import 'model/kundali/model/antarDashaModel.dart';
import 'model/kundali/model/mahaDashModel.dart';
import 'model/kundali/model/modelNew.dart';

class HttpServices {
  ApiBaseHelper _apiHelper = ApiBaseHelper();
  String userID = '';
  String name = '';
  String countryCode = '';
  late String _deviceID, _deviceToken = '';
  String _deviceType = 'WEB';
  String phone = '';
  String email = '';
  String image = '';

  Future _init() async {
    final _prefs = await SharedPreferences.getInstance();
    _deviceID =  '';
    _deviceToken = _prefs.getString('deviceToken') ?? '';
    name = _prefs.getString('name') ?? '';
    userID = _prefs.getString('USER_ID') ?? '';
    phone = _prefs.getString('MOBILE_NO') ?? '';
    email = _prefs.getString('email') ?? '';
    image = _prefs.getString('PROFILE_IMAGE') ?? '';

    countryCode = "1234";
    if (Platform.isAndroid) {
      _deviceType = 'Android';
    } else if (Platform.isIOS) {
      _deviceType = 'IOS';
    }
  }

  showExceptionToast() {
    Fluttertoast.showToast(msg: 'Something Went Wrong', timeInSecForIosWeb: 10);
  }

  Future<CheckNumberModel?> check_number({
    required String mobileNumber,
    required String country,
    required String country_code,
    required String type,
    required String otp,
  }) async {
    await _init();
    Map reqBody = {
      "number": mobileNumber,
      "otp": otp,
      "type": type,
      "country": country,
      "country_code": country_code,
      "deviceType": _deviceType,
      "deviceID": _deviceID,
      "deviceToken": _deviceToken,
    };
    final response = await _apiHelper.post('user_api/user_login_new', reqBody);
    try {
      return CheckNumberModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<RegisterOtpModel?> otp_register_process(
      {required String mobileNumber,
      required String otp,
      required String country,
      required String country_code}) async {
    await _init();
    Map reqBody = {
      "number": mobileNumber,
      "otp": otp,
      "country": country,
      "country_code": country_code
    };
    final response =
        await _apiHelper.post('user_api/otp_register_process', reqBody);
    try {
      return RegisterOtpModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserRegisterModel?> user_register(
      {required String country_code,
      required String country,
      required String name,
      required String number,
      required String gender,
      required String email,
      required String date,
      required String time,
      required String placeOfBirth,
      required String referral}) async {
    await _init();
    Map reqBody = {
      "country": country,
      "country_code": country_code,
      "name": name,
      "number": number,
      "email": email,
      "gender": gender,
      "deviceType": _deviceType,
      "deviceID": _deviceID,
      "deviceToken": _deviceToken,
      "refer_code_user": "jhjjtrtt",
      "date_of_birth": date,
      "time_of_birth": time,
      "place_of_birth": placeOfBirth,
      "refer_code_user": referral
    };
    final response = await _apiHelper.post('user_api/user_register', reqBody);
    try {
      return UserRegisterModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<PoojaModel?> poojaListingApi(Map<String, String> data) async {
    print("hello1.1");
    // Map reqBody = {};
    String url = "https://admin.astrogurujii.com/puja/pujalisting";
    //  final response=await _apiHelper.post('user_api/login', reqBody);
    final response = await _apiHelper.postN(data, url);
    try {
      log("Response is ====>>>  $response");

      return PoojaModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<PoojaDetailModel?> poojaDetailsApi(String instaId) async {
    Map reqBody = {"instaId": instaId.toString()};
    String url = "https://admin.astrogurujii.com/puja/pujabyinstaid";

    //  final response=await _apiHelper.post('user_api/login', reqBody);
    final response = await _apiHelper.postN(reqBody, url);
    try {
      log("Response is ====>>>  $response");

      return PoojaDetailModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<PoojaBookResponseModel?> bookPooja(
      {String? packagePrice,
      String? packageType,
      String? poojaId,
      String? poojaDate,
      String? userId,
      String? payment_mode,
      BuildContext? context}) async {
    Map reqBody = {
      "puja_id": poojaId.toString(),
      "puja_date": poojaDate.toString(),
      "puja_amount": packagePrice.toString(),
      "puja_type": packageType.toString(),
      "user_id": userId.toString(),
      "payment_mode":payment_mode.toString()
      //"user_id":"657ad5aca6d5df2db90465ad"
    };

    String url = "https://admin.astrogurujii.com/puja/bookpuja";

    //  final response=await _apiHelper.post('user_api/login', reqBody);
    final response = await _apiHelper.postN(reqBody, url);

     // try {
      return PoojaBookResponseModel.fromJson(response);
    // } catch (e) {
    //   return null;
    // }

    // Fluttertoast.showToast(
    //     msg: response["message"],
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
    //
    // if (response["status"] == true) {
    //   Navigator.pop(context!);
    // } else {}
  }

  Future<UserLoginModel?> user_login(
      {required String number, required String otp}) async {
    _init();
    Map reqBody = {
      "number": number,
      "otp": otp,
      "deviceType": _deviceType,
      "deviceID": _deviceID,
      "deviceToken": _deviceToken
    };
    final response = await _apiHelper.post('user_api/login', reqBody);
    try {
      return UserLoginModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserLoginModel?> skipe_login({required String country}) async {
    Map reqBody = {
      "country": country,
    };
    final response = await _apiHelper.post('user_api/skipe_login', reqBody);
    try {
      return UserLoginModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<ProfileModel?> profile_api() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'user_api/get_profile', "${_prefs.get('token')}");
    try {
      print("profile---->>> $response");
      return ProfileModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<CategoryModel?> category() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'user_api/category_list', "${_prefs.get('token')}");

    print("categoryResponse=====>>>>> ${response}");
    try {
      return CategoryModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UpdateprofileModel?> updateProfile_api(
      {required String gender,
      required String dob,
      required String tob,
      required String pob,
      required String name,
      required String email,
      required String rashi}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "gender": gender,
      "dob": dob,
      "tob": tob,
      "pob": pob,
      "name": name,
      "email": email,
      "rashi": rashi
    };
    log("token==>${_prefs.get('token')}");
    final response = await _apiHelper.put(
        'user_api/profile_update', reqBody, "${_prefs.get('token')}");
    try {
      return UpdateprofileModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AstrologerModel?> astrologer(
      {var followAstro,
      var language_id,
      var gender,
      var sort_val,
      var skill_id,
      required String report_id,
      required String search,
      required String page,
      required String isChat,
      required String isVoice,
      required String isVideo,
      required String cat_id,
      required String is_question,
      required String country,
      required String expert_astro}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "search": "",
      "page": "",
      "is_chat": isChat,
      "followAstro": followAstro,
      "is_voice_call": isVoice,
      "is_video_call": isVideo,
      "cat_id": cat_id,
      "language_id": language_id,
      "gender": gender,
      "sort_val": sort_val,
      "is_question": is_question,
      "skill_id": skill_id,
      "country": country,
      "report_id": report_id,
      "expert_astro": expert_astro
    };
    print("token ${_prefs.get('token')}");
    final response = await _apiHelper.postBearer(
        'user_api/astrologer_list', reqBody, "${_prefs.get('token')}");
    try {
      print("${AstrologerModel.fromJson(response)}----astrologer aPI   $reqBody");
      return AstrologerModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AstroDetilsModel?> astrologer_details({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id};
    final response = await _apiHelper.postBearer(
        'user_api/astrologer_profile', reqBody, "${_prefs.get('token')}");
    print("Astro---- Profile${response}");

    return AstroDetilsModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }


  Future<dynamic> get_live_users_count({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"live_id": id};
    print("ddddddddddd");
    final response = await _apiHelper.postBearer(
        'user_api/get_live_users_count', reqBody, "${_prefs.get('token')}");

    print("respponse--->> $response");

    return response;
    try {} catch (e) {
      return null;
    }
  }

  Future<dynamic> get_live_users_count_forPooja({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"puja_id": id};
    print("ddddddddddd");
    final response = await _apiHelper.postBearer(
        'user_api/live_users_count_pujaBooking', reqBody, "${_prefs.get('token')}");

    print("respponse--->> $response");

    return response;
    try {} catch (e) {
      return null;
    }
  }
  // Future<GetLiveUser?> get_live_users_count({required String id}) async {
  //   final _prefs = await SharedPreferences.getInstance();
  //   Map reqBody = {"live_id": id};
  //   final response = await _apiHelper.postBearer(
  //       'user_api/get_live_users_count', reqBody, "${_prefs.get('token')}");
  //
  //   return GetLiveUser.fromJson(response);
  //   try {} catch (e) {
  //     return null;
  //   }
  // }
  Future<UploadImageModel?> mp3_image_update({
    required String path,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String fileName = path.split('/').last;
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString('token')}";

    // String fileName = img.split('/').last;
    // Dio dio = new Dio();
    FormData data = FormData.fromMap({
      "image": path == ""
          ? ""
          : await MultipartFile.fromFile(
        path,
        filename: fileName,
      ),
    });
    try {
      Response response = await dio.post(
        'https://admin.astrogurujii.com/user_api/upload_mp3_file',
        data: data,

      );
      print(response.data);
      return UploadImageModel.fromJson(response.data);
    } catch (e) {
      print("gjgjgg" + e.toString());
      showExceptionToast();
      return null;
    }
  }
  Future<UploadImageModel?> chat_image_update({
    required String img,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String fileName = img.split('/').last;
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString('token')}";

    // String fileName = img.split('/').last;
    // Dio dio = new Dio();
    FormData data = FormData.fromMap({
      "image": img == ""
          ? ""
          : await MultipartFile.fromFile(
              img,
              filename: fileName,
            ),
    });
    try {
      Response response = await dio.post(
        'https://admin.astrogurujii.com/user_api/upload_a_file',
        data: data,
      );
      return UploadImageModel.fromJson(response.data);
    } catch (e) {
      print("gjgjgg" + e.toString());
      showExceptionToast();
      return null;
    }
  }

  Future<UploadImageModel?> profile_update({
    required String img,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String fileName = img.split('/').last;
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString('token')}";

    // String fileName = img.split('/').last;
    // Dio dio = new Dio();
    FormData data = FormData.fromMap({
      "profile_img": img == ""
          ? ""
          : await MultipartFile.fromFile(
              img,
              filename: fileName,
            ),
    });
    try {
      Response response = await dio.post(
        'https://admin.astrogurujii.com/user_api/profile_update_img',
        data: data,
      );
      return UploadImageModel.fromJson(response.data);
    } catch (e) {
      print("gjgjgg" + e.toString());
      showExceptionToast();
      return null;
    }
  }

  Future<HomeDataModel?> home_data() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'user_api/home_data', "${_prefs.get('token')}");
    print("Home Api Response===>>>> ${response}");
    return HomeDataModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<AstroMallBannerModel?> astoBannerApiFun() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'user_api/astro_mall_banners', "${_prefs.get('token')}");
    print("astro_mall_banners Response===>>>> ${response}");
    return AstroMallBannerModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<CallInitiateModel?> call_initiate(
      {var kundli,
      required String astrologer_id,
      required String call_type,
      required String channel_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "astrologer_id": astrologer_id,
      "call_type": call_type,
      "fb_channel_id": channel_id,
      "kundli": kundli
    };
    final response = await _apiHelper.postBearer(
        'user_api/call_initiate', reqBody, "${_prefs.get('token')}");
    try {
      return CallInitiateModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<CallStatusUpdateModel?> call_status_update(
      {required String channel_id, required String status}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"channel_id": channel_id, "status": status};
    final response = await _apiHelper.postBearer(
        'user_api/call_status_update', reqBody, "${_prefs.get('token')}");
    try {
      return CallStatusUpdateModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<RegisterAstroModel?> registerAstro(
      {required String name,
      required String number,
      required String email,
      required String qulification,
      required String experience}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "name": name,
      "number": number,
      "email": email,
      "qulification": qulification,
      "experience": experience
    };
    log("token==>>>${_prefs.get('token')}");
    final response = await _apiHelper.postBearer(
        'v2/astroRequest', reqBody, "${_prefs.get('token')}");
    log('ex===>>$response');

    try {
      return RegisterAstroModel.fromJson(response);
    } catch (e) {
      log('ex===>>$e');
      return null;
    }
  }

  Future<CallInitiateStatusModel?> call_initiate_status(
      {required String channel_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"channel_id": channel_id};
    final response = await _apiHelper.postBearer(
        'user_api/call_initiate_status', reqBody, "${_prefs.get('token')}");
    try {
      print(response);
      return CallInitiateStatusModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AstroStatusModel?> getAstroStatus() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'v2/getAstroRequestStatus', "${_prefs.get('token')}");
    log("token===>>> ${_prefs.get('token')}");
    try {
      return AstroStatusModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AllTestimonialsModel?> getAllTestimonials() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'v2/allTestimonial', "${_prefs.get('token')}");
    log("token===>>> ${_prefs.get('token')}");
    try {
      return AllTestimonialsModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<BannerModel?> bannerApiFun(String callType) async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await _apiHelper.getBearer(
        'v2/banner?callType=$callType', "${_prefs.get('token')}");

    print("responsebannerApiFun===>>  ${response}");
    try {
      return BannerModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<CallInitiateStatusModel?> change_connection_request_status(
      {required String channel_id, required String status}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"channel_id": channel_id, "status": status};
    final response = await _apiHelper.postBearer(
        'user_api/call_status_update', reqBody, "${_prefs.get('token')}");
    try {
      return CallInitiateStatusModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<CallInitiateStatusModel?> add_rating(
      {required String channel_id,
      required String rating,
      required String review}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "channel_id": channel_id,
      "rating": rating,
      "review": review,
    };
    final response = await _apiHelper.postBearer(
        'user_api/add_rating', reqBody, "${_prefs.get('token')}");
    try {
      return CallInitiateStatusModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<TransactionModel?> transaction({required String type}) async {
    final _prefs = await SharedPreferences.getInstance();
    // print('=====>'+_prefs.get('token').toString());
    Map reqBody = {"type": type};
    final response = await _apiHelper.postBearer(
        'user_api/transaction', reqBody, "${_prefs.get('token')}");
    try {
      return TransactionModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<GiftTranscationListModel?> giftTransaction() async {
    final _prefs = await SharedPreferences.getInstance();
    // print('=====>'+_prefs.get('token').toString());
     final response = await _apiHelper.getBearer(
        'user_api/gift_transaction', "${_prefs.get('token')}");
    // try {
      return GiftTranscationListModel.fromJson(response);
    // } catch (e) {
    //   print("errrorr --->>> $e");
    //   return null;
    // }
  }

  Future<get_daily_sun_horoscope> get_daily_sun_horoscopea(
      {required String sign, required String date}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"zodiac": sign, "date": date, "token": _prefs.get('token')};
    final response = await _apiHelper.postBearerHoro(
        'user_api/get_daily_sun_horoscope', reqBody);

    print("HoroScope response====>>> ${response}");
    return get_daily_sun_horoscope.fromJson(response);
  }


  Future<AntarDashaModel?> antarDashaApiFun(
      {
        required String dob,
        required String tob,
        required String lat,
        required String lon,

      }

      ) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "dob":dob,
      "tob":tob,
      "lat":lat,
      "lon":lon
    };

    final response = await _apiHelper.postBearer(
        'user_api/antarDasha', reqBody, "${_prefs.get('token')}");
    return AntarDashaModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }


  Future<MahaDashaModel?> mahaDashaApiFun(
      {
        required String dob,
        required String tob,
        required String lat,
        required String lon,

      }

      ) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "dob":dob,
      "tob":tob,
      "lat":lat,
      "lon":lon
    };

    final response = await _apiHelper.postBearer(
        'user_api/mahaDasha', reqBody, "${_prefs.get('token')}");
    return MahaDashaModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }


  Future<KundaliChartsModel?> kundaliNewChart(
      {required String name,
        required String year,
        required String month,
        required String day,
        required String hour,
        required String min,
        required String lat,
        required String lon,
        required String tzone,
        required String planetColor,
        required String signColor,
        required String lineColor,
        required String chartType}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "dob": day + "/" + month + "/" + year,
      "tob": hour + ":" + min,
      "name": name,
      "year": year,
      "month": month,
      "day": day,
      "min": min,
      "hour": hour,
      "lat": lat,
      "lon": lon,
      "tzone": tzone,
      "planetColor": planetColor,
      "signColor": signColor,
      "lineColor": lineColor,
      "chartType": chartType
    };
    final response = await _apiHelper.postBearer(
        'user_api/chart_img', reqBody, "${_prefs.get('token')}");

    print("Image chart Api response====>> ${response}");

    return KundaliChartsModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<KundaliNew?> kundaliNew(
      {required String name,
        required String year,
        required String month,
        required String day,
        required String hour,
        required String min,
        required String lat,
        required String lon,
        required String tzone,
        required String planetColor,
        required String signColor,
        required String lineColor,
        required String chartType}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "dob": day + "/" + month + "/" + year,
      "tob": hour + ":" + min,
      "name": name,
      "year": year,
      "month": month,
      "day": day,
      "min": min,
      "hour": hour,
      "lat": lat,
      "lon": lon,
      "tzone": tzone,
      "planetColor": planetColor,
      "signColor": signColor,
      "lineColor": lineColor,
      "chartType": chartType
    };
    final response = await _apiHelper.postBearer(
        'user_api/fetch_horoscope_data', reqBody, "${_prefs.get('token')}");

    print("fetch_horoscope_data -response=====>>> $response");
    return KundaliNew.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<CallInitiateStatusModel?> user_question_add(
      {required String astrologer_id,
      required String question,
      required String price}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "astrologer_id": astrologer_id,
      "question": question,
      "price": price
    };
    final response = await _apiHelper.postBearer(
        'user_api/user_question_add', reqBody, "${_prefs.get('token')}");
    try {
      return CallInitiateStatusModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<CategoryListModel?> product_category_list(
      {required String astrologer_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"astrologer_id": astrologer_id};
    final response = await _apiHelper.postBearer(
        'user_api/product_category_list', reqBody, "${_prefs.get('token')}");
    try {
      return CategoryListModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<ProductListModel?> product_list(
      {required String category_id,
      required String product_id,
      required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "category_id": category_id,
      "product_id": product_id,
      "id": id,
      "search": ""
    };
    final response = await _apiHelper.postBearer(
        'user_api/product_list', reqBody, "${_prefs.get('token')}");
    try {
      return ProductListModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<ProductListModel?> wish_list(
      {required String category_id, required String product_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "category_id": category_id,
      "product_id": product_id,
      "search": ""
    };
    final response = await _apiHelper.postBearer(
        'user_api/wish_list', reqBody, "${_prefs.get('token')}");
    try {
      return ProductListModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AddCartModel?> add_to_cart({required String product_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"product_id": product_id};
    final response = await _apiHelper.postBearer(
        'user_api/add_to_cart', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AddCartModel?> sub_to_cart({required String product_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"product_id": product_id};
    final response = await _apiHelper.postBearer(
        'user_api/sub_to_cart', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  //https://admin.astropush.com/user_api/remove_cart
  Future<AddCartModel?> remove_item_to_cart(
      {required String product_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"product_id": product_id};
    final response = await _apiHelper.postBearer(
        'user_api/remove_cart', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<CartListModel?> cart_list({required String product_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"product_id": product_id};
    final response = await _apiHelper.postBearer(
        'user_api/cart_list', reqBody, "${_prefs.get('token')}");
    try {
      return CartListModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AddCartModel?> wishlist_add_update(
      {required String product_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"product_id": product_id};
    final response = await _apiHelper.postBearer(
        'user_api/wishlist_add_update', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserAddressModel?> user_address(
      { String? key,
       String? location,
       String? building_name,
       String? landmark,
       String? address_type,
       String? contact_person_name,
       String? contact_person_mobile,
       String? is_default,
       String? pincode,
       String? flat_no,
       String? latitude,
       String? longitude}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "key": key,
      "location": location,
      "building_name": building_name,
      "landmark": landmark,
      "address_type": address_type,
      "contact_person_name": contact_person_name,
      "contact_person_mobile": contact_person_mobile,
      "is_default": is_default,
      "pincode": pincode,
      "flat_no": flat_no,
      "latitude": latitude,
      "longitude": longitude
    };
    final response = await _apiHelper.postBearer(
        'user_api/user_address', reqBody, "${_prefs.get('token')}");
    try {
      return UserAddressModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }


  Future<dynamic> checkout(
      {required String address_id,
      required String coupan_code,
      required String coupan_amount,

      required String delivery_date,
      required String payment_mode}) async {
    final _prefs = await SharedPreferences.getInstance();

    Map reqBody = {
      "address_id": address_id,
      "coupan_code": coupan_code,
      "coupan_amount": coupan_amount,
      "delivery_date": delivery_date,
      "payment_mode": payment_mode,
    };

    final response = await _apiHelper.postBearer('user_api/order', reqBody, "${_prefs.get('token')}");
      print("bbbbbbb===>> $response");
    // return  OrderNowModel.fromJson(response);
    return  response;
    // try {
    //   return OrderNowModel.fromJson(response);
    // } catch (e) {
    //   return null;
    // }
   }
          /// old

  // Future<OrderListModel?> order_list({required String order_id}) async {
  //   final _prefs = await SharedPreferences.getInstance();
  //   Map reqBody = {"order_id": order_id};
  //   final response = await _apiHelper.postBearer(
  //       'user_api/order_list', reqBody, "${_prefs.get('token')}");
  //
  //   print("Order Details====>> $response");
  //   try {
  //     return OrderListModel.fromJson(response);
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<dynamic> cancel_order({required String order_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "order_id": order_id,
      "status": "CANCEL"
    };
    final response = await _apiHelper.postBearer(
        'user_api/update_order_status', reqBody, "${_prefs.get('token')}");

    print("update_order_status---====>> $response");
    try {
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<OrderDetailsModelN?> order_list({required String order_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"order_id": order_id};
    final response = await _apiHelper.postBearer(
        'user_api/order_list', reqBody, "${_prefs.get('token')}");

    print("Order Details====>> $response");
    try {
      return OrderDetailsModelN.fromJson(response);
    } catch (e) {
      return null;
    }
  }



  Future<AddCartModel?> notifyme({required String astro_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"astro_id": astro_id};
    final response = await _apiHelper.postBearer(
        'user_api/notifyme', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<UserQuestionModel?> get_ask_question(
      {required String astro_id}) async {
    final _prefs = await SharedPreferences.getInstance();

    Map reqBody = {"astro_id": astro_id};
    final response = await _apiHelper.postBearer(
        'user_api/user_question', reqBody, "${_prefs.get('token')}");
    try {
      return UserQuestionModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AddCartModel?> addWallet(
      {var offer_id,
      required String profit_amount,
      required String coupan_code,
      required String amount,
      required String wallet_amount,
      required String transaction_id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "offer_id": offer_id,
      "amount": amount,
      "coupan_code": coupan_code,
      "profit_amount": profit_amount,
      "wallet_amount": wallet_amount,
      "transaction_id": transaction_id
    };
    final response = await _apiHelper.postBearer(
        'user_api/user_wallet_add', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<AddCartModel?> currency_update({required String currency}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"currency": currency};
    final response = await _apiHelper.postBearer(
        'user_api/currency_update', reqBody, "${_prefs.get('token')}");
    try {
      return AddCartModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<BlogListModel?> blog_list({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id};
    final response = await _apiHelper.postBearer(
        'user_api/blog_list', reqBody, "${_prefs.get('token')}");
    try {
      return BlogListModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<Notifications?> notifications_list({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id};
    final response = await _apiHelper.postBearer(
        'user_api/notifications_list', reqBody, "${_prefs.get('token')}");
    try {
      return Notifications.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<Notifications?> notifications_drop({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id};
    final response = await _apiHelper.postBearer(
        'user_api/notifications_drop', reqBody, "${_prefs.get('token')}");
    try {
      return Notifications.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  //https://admin.astropush.com/user_api/kunddli
  Future<KundaliModel?> kundali(
      {required String name,
      required String year,
      required String month,
      required String day,
      required String hour,
      required String min,
      required String lat,
      required String lon,
      required String tzone,
      required String planetColor,
      required String signColor,
      required String lineColor,
      required String chartType}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "name": name,
      "year": year,
      "month": month,
      "day": day,
      "min": min,
      "hour": hour,
      "lat": lat,
      "lon": lon,
      "tzone": tzone,
      "planetColor": planetColor,
      "signColor": signColor,
      "lineColor": lineColor,
      "chartType": chartType
    };
    final response = await _apiHelper.postBearer(
        'user_api/kunddli', reqBody, "${_prefs.get('token')}");
    return KundaliModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<MatchMaking?> get_ashtakoot_match(
      {required String name,
        required String year,
        required String month,
        required String day,
        required String hour,
        required String min,
        required String lat,
        required String lon,
        required String tzone,
        required String f_name,
        required String f_year,
        required String f_month,
        required String f_day,
        required String f_hour,
        required String f_min,
        required String f_lat,
        required String f_lon,
        required String f_tzone}) async {
    final _prefs = await SharedPreferences.getInstance();
    if (min.length == 1) {
      min = "0" + min;
    }
    if (hour.length == 1) {
      hour = "0" + hour;
    }

    if (f_hour.length == 1) {
      f_hour = "0" + f_hour;
    }
    if (f_min.length == 1) {
      f_min = "0" + f_min;
    }
    Map reqBody = {
      "m_name": name,
      "boy_dob": day + "/" + month + "/" + year,
      "boy_tob": hour + ":" + min,
      "boy_lat": lat,
      "boy_lon": lon,
      "m_tzone": tzone,
      "f_name": f_name,
      "girl_dob": f_day + "/" + f_month + "/" + f_year,
      "girl_tob": f_hour + ":" + f_min,
      "girl_lat": f_lat,
      "girl_lon": f_lon,
      "f_tzone": f_tzone,
    };
    final response = await _apiHelper.postBearer(
        'user_api/get_ashtakoot_match', reqBody, "${_prefs.get('token')}");
    return MatchMaking.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<MatchingDetails?> match_details(
      {required String name,
      required String year,
      required String month,
      required String day,
      required String hour,
      required String min,
      required String lat,
      required String lon,
      required String tzone,
      required String f_name,
      required String f_year,
      required String f_month,
      required String f_day,
      required String f_hour,
      required String f_min,
      required String f_lat,
      required String f_lon,
      required String f_tzone}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "m_name": name,
      "m_year": year,
      "m_month": month,
      "m_day": day,
      "m_min": min,
      "m_hour": hour,
      "m_lat": lat,
      "m_lon": lon,
      "m_tzone": tzone,
      "f_name": f_name,
      "f_year": f_year,
      "f_month": f_month,
      "f_day": f_day,
      "f_min": f_min,
      "f_hour": f_hour,
      "f_lat": f_lat,
      "f_lon": f_lon,
      "f_tzone": f_tzone,
    };
    final response = await _apiHelper.postBearer(
        'user_api/match_details', reqBody, "${_prefs.get('token')}");
    return MatchingDetails.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<MajorDashaModel?> major_vdasha({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id};
    final response = await _apiHelper.postBearer(
        'user_api/major_vdasha', reqBody, "${_prefs.get('token')}");
    return MajorDashaModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<MajorDashaModel?> sub_vdasha(
      {required String id, required String md}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id, "md": md};
    final response = await _apiHelper.postBearer(
        'user_api/sub_vdasha', reqBody, "${_prefs.get('token')}");
    return MajorDashaModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<MajorDashaModel?> sub_sub_vdasha(
      {required String id, required String md, required String ad}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id, "md": md, "ad": ad};
    final response = await _apiHelper.postBearer(
        'user_api/sub_sub_vdasha', reqBody, "${_prefs.get('token')}");
    return MajorDashaModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<dynamic> quickContact({
    required String name,
    required String message,
    required String subject,
    required String email,

  }) async {
    final _prefs = await SharedPreferences.getInstance();
    var reqBody =
    {
      "name": name,
      "message": message,
      "subject": subject,
      "email": email
    };
print("dasassa===>> ${reqBody}");
     final response = await _apiHelper.postBearer(
        'user_api/support_queries', reqBody,"${_prefs.get('token')}");

    print("respponse support_queries--->> $response");

    return response;

    try {} catch (e) {
      return null;
    }

  }

  Future<MajorDashaModel?> sub_sub_sub_vdasha(
      {required String id,
      required String md,
      required String ad,
      required String pd}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id, "md": md, "ad": ad, "pd": pd};
    final response = await _apiHelper.postBearer(
        'user_api/sub_sub_sub_vdasha', reqBody, "${_prefs.get('token')}");
    return MajorDashaModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<ReportListModel?> report_list({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"id": id};
    final response = await _apiHelper.postBearer(
        'user_api/report_type', reqBody, "${_prefs.get('token')}");
    return ReportListModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<UserReportListModel?> user_report_list() async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {};
    final response = await _apiHelper.postBearer(
        'user_api/report_list', reqBody, "${_prefs.get('token')}");
    return UserReportListModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  //https://admin.astropush.com/user_api/follow_astro
  Future<ReportListModel?> follow_astro({required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"astro_id": id};
    final response = await _apiHelper.postBearer(
        'user_api/follow_astro', reqBody, "${_prefs.get('token')}");
    return ReportListModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<SettingModel?> setting() async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {};
    final response = await _apiHelper.postBearer(
        'user_api/setting', reqBody, "${_prefs.get('token')}");
    return SettingModel.fromJson(response);

    try {} catch (e) {
      return null;
    }

  }

  Future<ChatListingModelN?> chatListingApi() async {
    final _prefs = await SharedPreferences.getInstance();
     final response = await _apiHelper.getBearer(
        'user_api/chat_history', "${_prefs.get('token')}");

     print("Chat histroy response=====>>> ${response}");

    return ChatListingModelN.fromJson(response);
    try {} catch (e) {
      return null;
    }

  }



  Future<ReferUserListModel?> refer_user_list() async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {};
    final response = await _apiHelper.postBearer(
        'user_api/refer_user_list', reqBody, "${_prefs.get('token')}");
    return ReferUserListModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<LocationModel?> geo_details({required String place}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"place": place};
    final response = await _apiHelper.postBearer(
        'user_api/geo_details', reqBody, "${_prefs.get('token')}");
    return LocationModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<OfferListModel?> coupan_list(
      {required String coupan_code, required String type}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"coupan_code": coupan_code, "type": type};
    final response = await _apiHelper.postBearer(
        'user_api/coupan_list', reqBody, "${_prefs.get('token')}");
    return OfferListModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<KundaliModel?> report_form_add(
      {required String astro_id,
      required String report_type,
      required String number,
      required String name,
      required String last_name,
      required String gender,
      required String month,
      required String dob,
      required String tob,
      required String pob,
      required String address,
      required String marital_status,
      required String occupation,
      required String amount,
      required String any_comments,
      required String ans_language,
      required String is_payment_done}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "astro_id": astro_id,
      "report_type": report_type,
      "first_name": name,
      "last_name": last_name,
      "number": number,
      "gender": gender,
      "month": month,
      "dob": dob,
      "tob": tob,
      "pob": pob,
      "address": address,
      "marital_status": marital_status,
      "occupation": occupation,
      "amount": amount,
      "any_comments": any_comments,
      "ans_language": ans_language,
      "is_payment_done": is_payment_done
    };
    final response = await _apiHelper.postBearer(
        'user_api/report_form_add', reqBody, "${_prefs.get('token')}");
    return KundaliModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }
  Future<BasicNumerologyModel?> basic_numerology(
      {required String year,
        required String month,
        required String day}) async {
    _init();
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "date": day + "/" + month + "/" + year,
      "name": (_prefs.get('name') == null) ? "Guest user" : _prefs.get('name')
    };
    final response = await _apiHelper.postBearer(
        'user_api/get_numerology_prediction',
        reqBody,
        "${_prefs.get('token')}");
    return BasicNumerologyModel.fromJson(response);
  }


  Future<LatiduseModels?> geocode({required String place}) async {
    _init();
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "place": place,
    };
    final response = await _apiHelper.postBearer(
        'user_api/geocode', reqBody, "${_prefs.get('token')}");
    return LatiduseModels.fromJson(response);
  }

  Future<PanchangeModel?> advanced_panchang({
    required String year,
    required String month,
    required String day,
    required String hour,
    required String min,
    required String lat,
    required String lon,
  }) async {
    _init();
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "year": year,
      "month": month,
      "day": day,
      "hour": hour,
      "min": min,
      "lat": lat,
      "lon": lon,
      "tzone": "5.5",
      "name": _prefs.get('name')
    };
    final response = await _apiHelper.postBearer(
        'user_api/advanced_panchang', reqBody, "${_prefs.get('token')}");
    return PanchangeModel.fromJson(response);
  }

  Future<AutoSuggetionApi?> googleMap({required String address}) async {
    final response = await _apiHelper.getGoogleMap(
        // 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${address}&language=en&sensor=true&types=%28cities%29&key=AIzaSyCuC8sZ2-HU7kKN_vxvVYF8FdAlyW2Enqo');
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${address}&language=en&sensor=true&types=%28cities%29&key=AIzaSyAyFVZ9vVQSjclBQnkSe_O4UkY-FRbTRrw');
    return AutoSuggetionApi.fromJson(response);
  }

  Future<WalletAmountListModel?> Wallet_amount_list() async {
    _init();
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {};
    final response = await _apiHelper.postBearer(
        'user_api/Wallet_amount_list', reqBody, "${_prefs.get('token')}");
    return WalletAmountListModel.fromJson(response);
  }

  //https://admin.astropush.com/user_api/follow_astro
  Future<RatingListDetailModel?> review_list_by_channel_id(
      {required String id}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"channel_id": id};
    final response = await _apiHelper.postBearer(
        'user_api/review_list_by_channel_id',
        reqBody,
        "${_prefs.get('token')}");
    return RatingListDetailModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<TarotModel?> tarot({required String question}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {"text": question};
    final response = await _apiHelper.postBearer(
        'user_api/tarot_list', reqBody, "${_prefs.get('token')}");
    return TarotModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<LastCallListModel?> lastCallList() async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {};
    final response = await _apiHelper.postBearer(
        'user_api/last_call_list', reqBody, "${_prefs.get('token')}");
    return LastCallListModel.fromJson(response);
    try {} catch (e) {
      return null;
    }
  }

  Future<LiveListing?> getLiveListing() async {
    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");
    final response = await _apiHelper.getBearer(
        'user_api/listing_of_live_astrlogers', "${_prefs.get('token')}");

    print("getLiveListing=====>>>>> ${response}");
    try {
      return LiveListing.fromJson(response);
    } catch (e) {
      print("error in ===>>> ${e}");
      return null;
    }
  }

  Future<LiveListing?> joinLiveAstrologerApi(String liveId) async {
    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");
    Map reqBody = {
      "live_id": liveId,
    };

    final response = await _apiHelper.postBearer(
        'user_api/join_live', reqBody, "${_prefs.get('token')}");

    print("joinLiveAstrologerApi=====>>>>> ${response}");
    // try {
    //   return LiveListing.fromJson(response);
    // } catch (e) {
    //   return null;
    // }
  }

  Future<LiveListing?> joinLiveForPoojaApi(String liveId) async {
    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");
    Map reqBody = {
      "puja_id": liveId,
    };

    final response = await _apiHelper.postBearer(
        'user_api/join_live_puja_booking', reqBody, "${_prefs.get('token')}");

    print("joinLiveForPoojaApi=====>>>>> ${response}");

  }

  Future<GetGiftModel?> getGiftsListing() async {
    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");
    final response = await _apiHelper.getBearer(
        'user_api/get_gifts', "${_prefs.get('token')}");

    print("getLiveListing=====>>>>> ${response}");
    try {
      return GetGiftModel.fromJson(response);
    } catch (e) {
      print("error in ===>>> ${e}");
      return null;
    }
  }

/// Mohnish
  ///
  Future<PoojaBookingsModel?> poojaBookingListApi() async {
    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

        final response=await _apiHelper.getBearer('user_api/get_pooja_bookings',"${_prefs.get('token')}");
  //  final response = await _apiHelper.postN(reqBody, url);
    try {
      log("Response of poojaBookingApi ====>>>  $response");

      return PoojaBookingsModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<ViewDetailsModel?> viewDetailsFunApi(String ?pujaBookingId) async {
    Map reqBody = {
      "pujaBookingId": pujaBookingId,

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/get_userdetails_of_puja',reqBody,"${_prefs.get('token')}");
    //  final response = await _apiHelper.postN(reqBody, url);
    try {
      log("Response of viewDetailsFunApi ====>>>  $response");

      return ViewDetailsModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }


  Future<dynamic?> addDetailApi({
    required String pujaBookingId,
    required String name,
    required String purposeOfPooja,
    required String gotra,
    required String email,
    required String place,
    required String whatsappNumber,
    required String courierAddress,

}) async {
    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");
    Map reqBody = {
      "pujaBookingId": pujaBookingId,
      "name": name,
      "purposeOfPooja": purposeOfPooja,
      "gotra": gotra,
       "email":email,
      "place":place,
      "whatsappNumber":whatsappNumber,
      "courierAddress":courierAddress
    };

    print("reBody===>>> ${reqBody}");

    final response=await _apiHelper.postBearer('user_api/add_user_details_in_puja', reqBody,"${_prefs.get('token')}",);

     try {
      log("Response of addDetailApi ====>>>  $response");

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic>giftSendApiForAstroFun({


    String? giftId, String ?to, String ?type,int? amount
  }) async {
    Map reqBody = {

      "giftId": giftId,
      "to": to,
      "type": type,
      "amount": amount
      // "giftId":giftId.toString(),
      // "to":to.toString(),
      // "type":"Gift Card"

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/gift_transaction',reqBody,"${_prefs.get('token')}");
     try {
      log("Response of giftSendApi ====>>>  $response");

      return response;
    } catch (e) {
       print("eroorr===>> ${e}");
      return null;
    }
  }



  Future<dynamic>giftSendApiForLiveFun({


    String? giftId, String ?to,int? amount,String ?id
  }) async {
    Map reqBody = {

      "giftId": giftId,
      "to": to,
      "type": "live",
      "liveId":id,
      "amount": amount
      // "giftId":giftId.toString(),
      // "to":to.toString(),
      // "type":"Gift Card"

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/gift_transaction',reqBody,"${_prefs.get('token')}");
    try {
      log("Response of giftSendApiForLiveFun ====>>>  $response");

      return response;
    } catch (e) {
      print("eroorr===>> ${e}");
      return null;
    }
  }


  Future<dynamic>giftSendApiForPoojaFun({
    String? giftId, String ?to, String ?type,int? amount,String ?id

  }) async {
    Map reqBody = {

      "giftId": giftId,
      "to": to,
      "type": "puja_booking",
      "pujaId":id,
      "amount": amount
      // "giftId":giftId.toString(),
      // "to":to.toString(),
      // "type":"Gift Card"

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/gift_transaction',reqBody,"${_prefs.get('token')}");
    try {
      log("Response of giftSendApiForPoojaFun ====>>>  $response");

      return response;
    } catch (e) {
      print("eroorr===>> ${e}");
      return null;
    }
  }



  Future<dynamic>joinLiveFun({
    String ? puja_id,
   }) async {
    Map reqBody = {

      "puja_id":puja_id.toString()

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/join_live_puja_booking',reqBody,"${_prefs.get('token')}");
    try {
      log("Response of joinLiveFun ====>>>  $response");

      return response;
    } catch (e) {
      print("eroorr===>> ${e}");
      return null;
    }
  }

  Future<dynamic>leaveLiveFun({
    String ? puja_id,
  }) async {
    Map reqBody = {

      "puja_id":puja_id.toString()

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/leave_live_puja_booking',reqBody,"${_prefs.get('token')}");
    try {
      log("Response of leaveLiveFun ====>>>  $response");

      return response;
    } catch (e) {
      print("eroorr===>> ${e}");
      return null;
    }
  }

  Future<dynamic>leaveLiveForHome({
    String ? live_id,
  }) async {
    Map reqBody = {

      "live_id":live_id.toString()

    };

    final _prefs = await SharedPreferences.getInstance();
    print("Token===>>> ${_prefs.get('token')}");

    final response=await _apiHelper.postBearer('user_api/leave_live',reqBody,"${_prefs.get('token')}");
    try {
      log("Response of leaveLiveFun for Home  ====>>>  $response");

      return response;
    } catch (e) {
      print("eroorr===>> ${e}");
      return null;
    }
  }

  Future<dynamic> reportAstrologer(
      {required String astrologerId,
        required String reason}
      ) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
      "astrologerId": astrologerId,
      "reason": reason
    };
    final response = await _apiHelper.postBearer(
        'user_api/reportAstrologer', reqBody, "${_prefs.get('token')}");
    print("Response of reportAstrologer ------------->>>>>>>>> ${response}");

    return response;
    try {} catch (e) {
      return null;
    }
  }


  Future<dynamic> getAllCouponCode() async {
    final _prefs = await SharedPreferences.getInstance();

    final response = await _apiHelper.getBearer(
        'user_api/all_coupans_listing', "${_prefs.get('token')}");
    print("Response of getAllCouponCode ------------->>>>>>>>> ${response}");

    return response;
    try {} catch (e) {
      return null;
    }
  }

  Future<dynamic> applyCouponCode({required String price,required String coupan_code}) async {
    final _prefs = await SharedPreferences.getInstance();
    Map reqBody = {
       "coupan_code":coupan_code.toString(),
      "price":price.toString()
    };
    final response = await _apiHelper.postBearer(
        'user_api/coupan_details', reqBody,"${_prefs.get('token')}");
    print("Response of applyCouponCode ------------->>>>>>>>> ${response}");

    return response;
    try {} catch (e) {
      return null;
    }
  }

}
