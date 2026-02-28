import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwapController extends GetxController implements GetxService {
  var isLoading = false.obs;
  var swapList = [].obs;

  void getSwapHistory() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    isLoading.value = true;

    final response = await GetConnect().post(
      'https://evfuel.akslearning.in/api/user-swap-history',
      {"user_id": token},
    );

    if (response.statusCode == 200) {
      swapList.value = response.body['success']['history'];
    }

    isLoading.value = false;
  }
}
