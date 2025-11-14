import 'dart:convert';
import 'package:get/get.dart';
import 'package:vivashri/data/repository/home_repo.dart';


class HomeController extends GetxController implements GetxService {
  final HomeRepo homeRepo;

  HomeController({
    required this.homeRepo,
  });

  bool isLoading = false;
}

Map<String, dynamic> getxControllerFromJson(String str) {
  return json.decode(str);
}
