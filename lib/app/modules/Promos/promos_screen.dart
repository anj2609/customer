import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/promolist_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/custom_loader.dart';
import 'package:shimmer/shimmer.dart';

class PromoScreen extends StatefulWidget {

  PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {

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
          child: CircleAvatar(
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

        // actions: [
        //   Icon(Icons.more_vert, color: ColorResources.blackcolor),
        //   SizedBox(width: 10),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _promoCodeCard(),

            const SizedBox(height: 20),

            _categoryList(),

            const SizedBox(height: 20),

            Expanded(
              child: GetBuilder<ProfileController>(
                builder: (controller) {
                  if (controller.isPromoLoading) {
                    return  Center(child: PremiumBlurLoader());
                  }

                  if (controller.promoCategoryListData.isEmpty) {
                    return const Center(child: Text("No Promos Available"));
                  }

                  return ListView.builder(
                    itemCount: controller.promoCategoryListData.length,
                    itemBuilder: (context, index) {
                      final promo = controller.promoCategoryListData[index];

                      return _promoCard(context, promo);
                    },
                  );
                },
              ),
            ),
            // Expanded(
            //   child: Obx(
            //     () => ListView.builder(
            //       itemCount: controller.filteredList.length,
            //       itemBuilder: (context, index) {
            //         final promo = controller.filteredList[index];
            //         return _promoCard(context, promo);
            //       },
            //     ),
            //   ),
            // ),
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
    return GetBuilder<ProfileController>(
      builder: (controller) {
        if (controller.isCategoryLoading) {
          return _categoryShimmer();
        }

        if (controller.promoCategoryList.isEmpty) {
          return const SizedBox(
            height: 45,
            child: Center(
              child: Text(
                "No Categories Found",
                style: TextStyle(fontSize: 14),
              ),
            ),
          );
        }

        if (controller.selectedCategory.isEmpty) {
          controller.selectedCategory =
              controller.promoCategoryList.first.name ?? "";
        }

        /// ✅ DATA SHOW
        return SizedBox(
          height: 45,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.promoCategoryList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final categoryModel = controller.promoCategoryList[index];

              final category = categoryModel.name ?? "";

              if (category.isEmpty) {
                return const SizedBox();
              }

              final isSelected = controller.selectedCategory == category;

              return GestureDetector(
                onTap: () {
                  controller.getPromoListByCategory(
                    category: category,
                    context: context,
                  );
                  controller.changeCategory(context, category);

                  //getPromoListByCategory
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorResources.blueeebutton
                        : ColorResources.whiteColor,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? ColorResources.blueeebutton
                          : Colors.grey.shade300,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? ColorResources.whiteColor
                          : ColorResources.blackcolor11,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _categoryShimmer() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _promoCard(BuildContext context, PromoolistDataModel promo) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RouteHelper.getpromoDetailsScreen(),
          arguments: {"id": promo.id.toString()},
        );
        Get.find<ProfileController>()
       .promoDetials(id: promo.id.toString(), context: context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage("assets/images/Rectangle.png"),
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
              _blueTags(
                promo.title ?? "",
                "assets/images/splashscreen.png" ?? "",
              ),

              const SizedBox(height: 8),

              _blueTag(promo.title ?? ""),

              const Spacer(),

              Text(
                promo.priceOff ?? "",
                style: PoppinsExtrabold.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color: Colors.white,
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
                      promo.code ?? "",
                      style: PoppinsBold.copyWith(color: Colors.white),
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

  // Widget _promoCard(BuildContext contextsss, PromoModel promo) {
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
