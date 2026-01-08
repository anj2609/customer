import 'package:flutter/material.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/widgets/employ_drawer.dart';

class MembersListScreen extends StatelessWidget {
  const MembersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey1 = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: EmployeeScreen(),
      key: _scaffoldKey1,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorResources.primarycolor2,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey1.currentState?.openDrawer();
          },
          child: Icon(Icons.menu, color: Colors.white, size: 26),
        ),
        title: Text(
          "Members List",
          style: opensansSemiBold.copyWith(fontSize: 18, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showFilterBottomSheet(context);
            },
            child: Icon(Icons.filter_alt_outlined, color: Colors.white),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const MemberCard();
        },
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
            top: 16,
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

              const SizedBox(height: 12),

              /// From & To Date
              Row(
                children: [
                  Expanded(
                    child: _textField(
                      hint: "From Date",
                      icon: Icons.calendar_month,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      hint: "To Date",
                      icon: Icons.calendar_month,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Name
              _textField(hint: "Name"),

              const SizedBox(height: 12),

              /// Mobile & Profile ID
              Row(
                children: [
                  Expanded(child: _textField(hint: "Mobile")),
                  const SizedBox(width: 12),
                  Expanded(child: _textField(hint: "Profile ID")),
                ],
              ),

              const SizedBox(height: 24),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "CANCEL",
                      style: opensansSemiBold.copyWith(color: Colors.pink),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      // Apply filter logic here
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: opensansSemiBold.copyWith(color: Colors.pink),
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

  Widget _textField({required String hint, IconData? icon}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: opensansSemiBold.copyWith(fontSize: 15),
        suffixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBDFFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
              ),
              const SizedBox(width: 12),

              /// Name + ID
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Santosh Kumar",
                      style: opensansSemiBold.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "ID: #786 2548",
                      style: opensansSemiBold.copyWith(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.more_vert, color: Colors.blue),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(),

          /// Details
          detailRow("Email ID", "santosh@gmail.com"),
          detailRow("Mobile No.", "+91-9873985748"),
          detailRow("Created Date", "June 12, 2025"),
          detailRow("Membership Plan", "Premium Plan"),
        ],
      ),
    );
  }

  static Widget detailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(title, style: opensansSemiBold.copyWith(fontSize: 14)),
          ),
          const Text(":  "),
          Expanded(
            child: Text(
              value,
              style: opensansMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackgrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
