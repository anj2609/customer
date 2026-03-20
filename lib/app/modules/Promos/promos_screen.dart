import 'package:evfual/app/modules/Promos/promosdetail_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/data/controller/promoslist.dart';
import 'package:evfual/data/modal/promo_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoScreen extends StatelessWidget {
  final PromoController controller = Get.put(PromoController());

  PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: 
          CircleAvatar(
            radius: 18,
            backgroundColor: ColorResources.blueeebutton,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/splashscreen.png'),
              ),
            ),
          ),
        ),

        title: Text(
          "Promos",
          style: PoppinsMedium.copyWith(color: ColorResources.blackcolor11),
        ),

        actions: [
          Icon(Icons.more_vert, color: ColorResources.blackcolor),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Promo Code Input Card
            _promoCodeCard(),

            const SizedBox(height: 20),

            /// Horizontal Category List
            _categoryList(),

            const SizedBox(height: 20),

            /// Dynamic Promo List
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final promo = controller.filteredList[index];
                    return _promoCard(context, promo);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoCodeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/discount.png',
            height: 50,
            width: 50,
            fit: BoxFit.contain,
            color: ColorResources.orangecoor,
          ),

          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Have a Promo Code?",
                  style: PoppinsBold.copyWith(
                    color: ColorResources.blackcolor11,
                  ),
                ),
                Text(
                  "Enter your promo code here",
                  style: PoppinsReguler.copyWith(
                    color: ColorResources.TextColorForGrey,
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _categoryList() {
    return SizedBox(
      height: 45,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategory.value == category;

            return GestureDetector(
              onTap: () => controller.changeCategory(category),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorResources.blueeebutton
                      : ColorResources.whiteColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? ColorResources.blueeebutton
                        : ColorResources.whiteColor,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected
                        ? ColorResources.whiteColor
                        : ColorResources.blackcolor11,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _promoCard(BuildContext contextsss, PromoModel promo) {
    return GestureDetector(
      onTap: () {
        Get.to(
          PromoDetailsScreen(),
          transition: Transition.leftToRight,
          duration: Duration(milliseconds: 0),
        );
        // Navigator.push(
        //   contextsss,
        //   MaterialPageRoute(builder: (_) => PromoDetailsScreen()),
        // );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(promo.image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _blueTags(promo.title, promo.applogo),

              /// _blueTag(promo.title),
              const SizedBox(height: 8),

              /// _blueTags(promo.subtitle,promo.applogo),
              _blueTag(promo.subtitle),

              //_blueTags
              const Spacer(),
              Text(
                promo.discount,
                style: PoppinsExtrabold.copyWith(
                  color: ColorResources.whiteColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color: ColorResources.whiteColor,
                    child: Text(
                      "CODE ",
                      style: PoppinsBold.copyWith(
                        color: ColorResources.blueeebutton,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color: ColorResources.blueeebutton,
                    child: Text(
                      promo.code,
                      style: PoppinsBold.copyWith(
                        color: ColorResources.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageLogo(String images) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorResources.blueeebutton,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          Image.asset(
            images,
            height: 30,
            width: 30,

            color: ColorResources.whiteColor,
          ),
        ],
      ),
    );
  }

  Widget _blueTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: ColorResources.blueeebutton,
      child: Text(
        text,
        style: PoppinsBold.copyWith(color: ColorResources.whiteColor),
      ),
    );
  }

  Widget _blueTags(String text, String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: ColorResources.blueeebutton,
          child: Text(
            text,
            style: PoppinsBold.copyWith(color: ColorResources.whiteColor),
          ),
        ),
        Spacer(),

        _imageLogo(image),
      ],
    );
  }
}
