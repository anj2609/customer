import 'package:get/get.dart';
import 'package:myrideuser/data/controller/addaddress_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
  }
}