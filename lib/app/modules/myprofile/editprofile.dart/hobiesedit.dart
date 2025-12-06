import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/complecxion.dart';
import 'package:vivashri/data/controller/dietcontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/hobbies.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditHobbies extends StatefulWidget {
  const EditHobbies({super.key});

  @override
  State<EditHobbies> createState() => _EditHobbiesState();
}

class _EditHobbiesState extends State<EditHobbies> {
  StaperfromController stapercontroller = Get.put(StaperfromController());
  final cityC = Get.put(CityController());

  final hobbyC = Get.put(HobbyController());
  final dietC = Get.put(DietController());

  List<String> selectedHobbies = [];
  final complexionC = Get.put(ComplexionController());

  String? diet;
  String? cityOfBirth;
  String manglik = "";
  String? weight;
  String? height;
  String? complexion;
  String? healthInfo;
  String disability = "";
  String? bloodGroup;
  String? selectedHour;
  String? selectedMin;
  String? selectedAmPm = "AM";
  final usercontroller = Get.put(UserDetailController());

  @override
  void initState() {
    super.initState();

    getdata();
  }

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    await hobbyC.fetchHobbies();
    hobbyC.setSelectedHobbiesFromApi(u.hobbies);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Hobbies & Interests',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- HOBBIES ----------------
                    _label("Hobbies:"),
                    hobbiesScrollableBox(),

                    const SizedBox(height: 30),
                    _buttons(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: opensansMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackgrey,
              ),
            ),
         
          ],
        ),
      ),
    );
  }

  Widget hobbiesScrollableBox() {
    return Obx(() {
      return Container(
        height: 250,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 5,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children: hobbyC.hobbyList.map((h) {
                bool selected = hobbyC.selectedHobbyIds.contains(h.id);

                return InkWell(
                  onTap: () {
                    hobbyC.toggleHobby(h.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selected ? Colors.pink.shade50 : Colors.white,
                      border: Border.all(
                        color: selected
                            ? ColorResources.primarycolor3
                            : Colors.grey.shade400,
                        width: 1.3,
                      ),
                    ),
                    child: Text(
                      h.name, // Name show
                      style: opensansSemiBold.copyWith(
                        fontSize: 13,
                        color: selected
                            ? ColorResources.primarycolor3
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              stapercontroller.updatehobbies(
                formData: {},
                selected: hobbyC.selectedHobbyIds,
              );
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFBE266B), Color(0xFFEB1D7B)],
                ),
              ),
              child: Text(
                "Update",
                style: opensansMedium.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
