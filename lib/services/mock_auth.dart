import 'dart:math';

import 'package:chain_app/constants/app_constants.dart';
import 'package:chain_app/services/app_client.dart';
import 'package:chain_app/models/response/login_response.dart';
import 'package:chain_app/models/response/register_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService {
  static const String mockEmail = "admin@gmail.com";
  static const String mockPassword = "123456";

  static Future<LoginResponse> login(
      {required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic>? responseData;
    if (password == mockPassword && email == mockEmail) {
      responseData = {
        'status': "success",
        'message': "Logged in successfully",
        "token": "bearer_token"
      };

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, "bearer_token");
      AppClient().token = "bearer_token";
    } else {
      if (email == mockEmail) {
        responseData = {
          'status': "error",
          'error': {"password": "Password is not correct"}
        };
      } else {
        responseData = {
          'status': "error",
          'error': {"email": "Email does not exist"}
        };
      }
    }

    return LoginResponse.fromJson(responseData);
  }

  static Future<RegisterResponse> register(
      {required String email,
      required String password,
      required String username}) async {
    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic>? responseData;
    if (password == mockPassword && email == mockEmail) {
      responseData = {
        'status': "success",
        'message': "Logged in successfully",
        'token': "bearer_token"
      };
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, "bearer_token");
      AppClient().token = "bearer_token";
    } else {
      if (email == mockEmail) {
        responseData = {
          'status': "error",
          'error': {"password": "Password is not appropriate"}
        };
      } else {
        responseData = {
          'status': "error",
          'error': {"email": "Email is already exist"}
        };
      }
    }

    return RegisterResponse.fromJson(responseData);
  }

  static Future<bool> validateToken({required String token}) async {
    try {
      Random r = Random();

      await Future.delayed(const Duration(milliseconds: 500));

      return r.nextBool();
    } catch (e) {
      print(e);
      return false;
    }
  }

  // static Future<bool> forgotPassword({required String email}) async {
  //   try {
  //     var response = await AppClient().dio.post(
  //         "${AppConstants.baseUrl}auth/forgotPassword",
  //         data: {'email': email});
  //
  //     if (response.statusCode == null) {
  //       return false;
  //     }
  //
  //     print(response.data);
  //
  //     return true;
  //   } on DioError catch (e) {
  //     print(e.response?.data);
  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  //
  // static Future<bool> checkCode(
  //     {required int code, required String email}) async {
  //   try {
  //     var response = await AppClient().dio.post(
  //         "${AppConstants.baseUrl}auth/checkForgetPasswordCode",
  //         data: {'email': email, 'code': code});
  //
  //     if (response.statusCode == null) {
  //       return false;
  //     } else if (response.statusCode! >= 400) {
  //       return false;
  //     }
  //     AppClient().resetToken = response.data["resetToken"];
  //
  //     print(response.data);
  //
  //     return true;
  //   } on DioError catch (e) {
  //     print(e.response?.data);
  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  //
  // static Future<bool> changePassword({required String password}) async {
  //   try {
  //     var response = await AppClient()
  //         .dio
  //         .post("${AppConstants.baseUrl}auth/resetPassword", data: {
  //       'newPassword': password,
  //       'resetToken': AppClient().resetToken
  //     });
  //
  //     if (response.statusCode == null) {
  //       return false;
  //     } else if (response.statusCode! >= 400) {
  //       return false;
  //     }
  //
  //     print(response.data);
  //
  //     return true;
  //   } on DioError catch (e) {
  //     print(e.response?.data);
  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  //
  //
  // static Future<bool> removeAccount() async {
  //   try {
  //     var response = await AppClient()
  //         .dio
  //         .post("${AppConstants.baseUrl}user/removeAccount");
  //
  //     print("Successfully validated token");
  //     print(response.data);
  //
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
