import 'package:get/get.dart';
import 'package:vivashri/config/route.dart';
import 'package:vivashri/data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});
  var userData = {}.obs; // Observable for user data
  var isLoading = true.obs; // Loading state

  // Future<Response> userlloginapi({
  //   required BuildContext context,
  //   String? mobilenumner,
  //   String? fcmToken,
  // }) async {
  //   EasyLoading.show();
  //   update();

  //   Response response = await authRepo.userloginapi(
  //     mobilenumner: mobilenumner!.trim(),
  //   );

  //   if (response.statusCode == 200) {
  //     EasyLoading.dismiss();
  //     Get.snackbar(
  //       'Success',
  //       'OTP has been sent successfully to your number $mobilenumner.',
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );

  //     print('Doctor:::::::::::::::${response.body['token']}');
  //   } else if (response.statusCode == 422) {
  //     var errorMsg =
  //         response.body['errors']?['mobile']?[0] ?? "Validation error!";
  //     EasyLoading.dismiss();
  //     Get.snackbar(
  //       'Error',
  //       errorMsg,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } else {
  //     EasyLoading.dismiss();
  //     // showCustomSnackBar(response.body['message'].toString(), isError: true);
  //   }

  //   update();
  //   return response;
  // }

  String? getAuthToken() {
    return authRepo.getUserToken();
  }

  void logOut() {
    Get.offNamed(RouteHelper.getLoginRoute());
    return authRepo.removeUserToken();
  }
}
