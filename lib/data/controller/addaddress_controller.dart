import 'package:myrideuser/data/modal/addaddress_model.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  RxList<AddressModel> addressList = <AddressModel>[].obs;

  void addAddress(
    String name,
    String address,
    String details,
    double lat,
    double lng,
  ) {
    addressList.add(
      AddressModel(
        name: name,
        address: address,
        details: details,
        lat: lat,
        lng: lng,
      ),
    );
    update();
  }
}
