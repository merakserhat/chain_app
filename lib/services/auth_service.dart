import 'package:chain_app/models/response/login_response.dart';
import 'package:chain_app/models/response/register_response.dart';
import 'package:dio/dio.dart';
import 'package:chain_app/constants/app_constants.dart';
import 'package:chain_app/services/app_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<LoginResponse> login(
      {required String email, required String password}) async {
    LoginResponse loginResponse = LoginResponse();
    try {
      var response = await AppClient().dio.post(
          "${AppConstants.baseUrl}auth/login",
          data: {'email': email, 'password': password});

      if (response.statusCode == null) {
        loginResponse.serverError = AppConstants.serverErrorMessage;
        loginResponse.isValid = false;
        return loginResponse;
      }

      if (response.statusCode! >= 400) {
        loginResponse.serverError = AppConstants.serverErrorMessage;
        loginResponse.isValid = false;
        return loginResponse;
      }

      print("Successfully logged in");
      print(response.data);

      String token = response.data["token"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      AppClient().token = token;

      loginResponse.token = token;

      return loginResponse;
    } on DioError catch (e) {
      print(e.response?.data);
      if (e.response?.data != null) {
        return LoginResponse.fromJson(e.response!.data);
      }

      return LoginResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    } catch (e) {
      print(e.toString());
      return LoginResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    }
  }

  static Future<RegisterResponse> register(
      {required String email,
      required String password,
      required String username}) async {
    RegisterResponse registerResponse = RegisterResponse();
    try {
      var response = await AppClient().dio.post(
          "${AppConstants.baseUrl}auth/register",
          data: {'email': email, 'password': password, 'username': username});

      if (response.statusCode == null) {
        registerResponse.serverError = AppConstants.serverErrorMessage;
        registerResponse.isValid = false;
        return registerResponse;
      }

      if (response.statusCode! >= 400) {
        registerResponse.serverError = AppConstants.serverErrorMessage;
        registerResponse.isValid = false;
        return registerResponse;
      }

      print("Successfully logged in");
      print(response.data);

      String token = response.data["token"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, token);
      AppClient().token = token;

      registerResponse.token = token;

      return registerResponse;
    } on DioError catch (e) {
      print(e.response?.data);
      if (e.response?.data != null) {
        return RegisterResponse.fromJson(e.response!.data);
      }

      return RegisterResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    } catch (e) {
      print(e.toString());
      return RegisterResponse(
        isValid: false,
        serverError: AppConstants.serverErrorMessage,
      );
    }
  }

  static Future<bool> validateToken({required String token}) async {
    try {
      var response = await AppClient().dio.post(
          "${AppConstants.baseUrl}auth/validateToken",
          data: {'token': token});

      if (response.statusCode == null) {
        return false;
      }

      if (response.statusCode! >= 400) {
        return false;
      }

      print("Successfully validated token");
      print(response.data);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
