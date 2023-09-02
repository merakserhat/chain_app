import 'package:dio/dio.dart';
import 'package:chain_app/constants/app_constants.dart';
import 'package:chain_app/services/app_client.dart';

class TempService {
  static Future<bool> temp() async {
    try {
      var response =
          await AppClient().dio.get("${AppConstants.baseUrl}groceries");

      if (response.statusCode == null) {
        return false;
      }

      if (response.statusCode! >= 400) {
        return false;
      }

      print("Successfully see groceries in");
      print(response.data);

      return true;
    } on DioError catch (e) {
      print(e.response?.data);
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
