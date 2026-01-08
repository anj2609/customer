import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/employee/deshboard/employ_desh.dart';
import 'package:vivashri/widgets/employ_drawer.dart';

class ConvertedLeads extends StatefulWidget {
  const ConvertedLeads({super.key});

  @override
  State<ConvertedLeads> createState() => _ConvertedLeadsState();
}

class _ConvertedLeadsState extends State<ConvertedLeads> {
  bool isAddLeadSelected = true;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EmployeeScreen(),
      key: _scaffoldKey1,
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),

        title: Text(
          "Converted Leads",
          style: opensansSemiBold.copyWith(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              showFilterBottomSheet(context);
            },
            child: Icon(Icons.filter_alt, color: Colors.white),
          ),
          SizedBox(width: 10),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: _viewLeadWidget())),
          ],
        ),
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter By",
                    style: opensansSemiBold.copyWith(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: _textField(
                      label: "From Date",
                      hint: "",
                      icon: Icons.calendar_month,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      label: "To Date",
                      hint: "",
                      icon: Icons.calendar_month,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Name
              _textField(label: "Name", hint: ""),

              const SizedBox(height: 12),

              Text(
                "Lead ID",
                style: opensansSemiBold.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration(),
                hint: const Text("Select"),
                items: const [
                  DropdownMenuItem(value: "1", child: Text("Lead 1")),
                  DropdownMenuItem(value: "2", child: Text("Lead 2")),
                ],
                onChanged: (value) {},
              ),

              const SizedBox(height: 12),

              /// Status
              Text(
                "Status",
                style: opensansSemiBold.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 0,
                runSpacing: 0,
                children: [
                  _statusButton("Pending"),
                  _statusButton("In Process"),
                  _statusButton("Not Interested"),
                  _statusButton("Paid"),
                ],
              ),

              const SizedBox(height: 24),

              /// Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      // Apply filter
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: opensansSemiBold.copyWith(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: _inputDecoration(hint: hint, icon: icon),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _statusButton(String title) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: opensansSemiBold.copyWith(fontSize: 11),
        textAlign: TextAlign.center,
      ),
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
}
