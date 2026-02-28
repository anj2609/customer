import 'package:evfual/data/modal/promo_model.dart';
import 'package:get/get.dart';

class PromoController extends GetxController {
  var selectedCategory = "All".obs;

  final categories = ["All", "Discount", "Cashback", "Partnership"].obs;

  final promoList = <PromoModel>[
    PromoModel(
      title: "BEST DEAL",
      subtitle: "END OF YEAR PROMO",
      discount: "20% OFF",
      code: "EOYP25",
      image: "assets/images/Rectangle.png",
      category: "Discount",
      applogo: "assets/images/splashscreen.png",
    ),
    PromoModel(
      title: "SPECIAL OFFER",
      subtitle: "FOR NEW USER ONLY",
      discount: "15% OFF",
      code: "NUP15K",
      image: "assets/images/Rectangle.png",
      category: "Discount",
      applogo: "assets/images/splashscreen.png",
    ),
     PromoModel(
      title: "SPECIAL OFFER",
      subtitle: "FOR NEW USER ONLY",
      discount: "15% OFF",
      code: "NUP15K",
      image: "assets/images/Rectangle.png",
      category: "Discount",
      applogo: "assets/images/splashscreen.png",
    ),
     PromoModel(
      title: "SPECIAL OFFER",
      subtitle: "FOR NEW USER ONLY",
      discount: "15% OFF",
      code: "NUP15K",
      image: "assets/images/Rectangle.png",
      category: "Discount",
      applogo: "assets/images/splashscreen.png",
    ),
    
  ].obs;

  List<PromoModel> get filteredList {
    if (selectedCategory.value == "All") {
      return promoList;
    }
    return promoList
        .where((e) => e.category == selectedCategory.value)
        .toList();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}