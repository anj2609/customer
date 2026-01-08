import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/employee/deshboard/employ_desh.dart';
import 'package:vivashri/widgets/employ_drawer.dart';

class MyLeadsScreen extends StatefulWidget {
  final bool? initialIndex;
  final String? hide;
  MyLeadsScreen({super.key, this.initialIndex = true, this.hide});

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  bool isAddLeadSelected = true;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAddLeadSelected = widget.initialIndex!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EmployeeScreen(),
      key: _scaffoldKey1,
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        elevation: 0,
        leading: widget.hide == "Hide"
            ? GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 22,
                ),
              )
            : GestureDetector(
                onTap: () {
                  _scaffoldKey1.currentState?.openDrawer();
                },
                child: Icon(Icons.menu, color: Colors.white, size: 26),
              ),

        title: Text(
          "My Leads",
          style: opensansSemiBold.copyWith(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _outlineButton(
                    text: "Add Lead",
                    isActive: isAddLeadSelected,
                    onTap: () {
                      setState(() {
                        isAddLeadSelected = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _outlineButton(
                    text: "View Lead",
                    isActive: !isAddLeadSelected,
                    onTap: () {
                      setState(() {
                        isAddLeadSelected = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: isAddLeadSelected ? _addLeadWidget() : _viewLeadWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BUTTON =================

  Widget _outlineButton({
    required String text,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive ? Colors.white : const Color(0xFFF2F2F2),
        side: BorderSide(
          color: isActive ? const Color(0xFFE91E63) : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: opensansSemiBold.copyWith(
          color: isActive ? Color(0xFFE91E63) : Colors.black,
        ),
      ),
    );
  }

  Widget _addLeadWidget() {
    return Column(
      children: [
        _label("Name", isRequired: true),
        _textField(),

        _label("Email"),
        _textField(),

        _label("Mobile", isRequired: true),
        _textField(keyboardType: TextInputType.phone),

        _label("State", isRequired: true),
        _dropdown(),

        _label("City", isRequired: true),
        _dropdown(),

        _label("Address"),
        _textField(maxLines: 3),

        _label("Details"),
        _textField(maxLines: 4),

        const SizedBox(height: 24),

        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 140,
            height: 45,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
                ),

                color: Colors.grey.shade400,
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: opensansMedium.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= VIEW LEAD WIDGET =================

  Widget _viewLeadWidget() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: LeadCard(
            name: index == 0 ? "Santosh Kumar" : "Amitabh Singh Rathod",
            id: "#786 2548",
            email: "santosh@gmail.com",
            phone: "+91-9873985748",
            date: "June 12, 2025",
            status: index == 0 ? "Pending" : "In process",
          ),
        );
      },
    );
  }

  // ================= COMMON WIDGETS =================

  Widget _label(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: text,
            style: opensansSemiBold.copyWith(
              color: ColorResources.blackgrey,
              fontSize: 14,
            ),
            children: isRequired
                ? const [
                    TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
      ),
    );
  }

  Widget _textField({
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1.2),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      items: const [],
      onChanged: (v) {},
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
