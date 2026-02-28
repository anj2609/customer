
import 'package:flutter/material.dart';

class SettingModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingModel({required this.icon, required this.title, required this.onTap});
}

////////////////////////////////////////////////////////////
/// MAIN SCREEN
////////////////////////////////////////////////////////////

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 DYNAMIC SETTINGS LIST
    final List<SettingModel> settings = [
      SettingModel(
        icon: Icons.location_on_outlined,
        title: "Saved Addresses",
        onTap: () => _open(context, "Saved Addresses"),
      ),
      SettingModel(
        icon: Icons.notifications_none,
        title: "Notifications",
        onTap: () => _open(context, "Notifications"),
      ),
      SettingModel(
        icon: Icons.credit_card,
        title: "Payment n Methods",
        onTap: () => _open(context, "Payment Methods"),
      ),
      SettingModel(
        icon: Icons.shield_outlined,
        title: "Account & Security",
        onTap: () => _open(context, "Account & Security"),
      ),
      SettingModel(
        icon: Icons.sync_alt,
        title: "Linked Accounts",
        onTap: () => _open(context, "Linked Accounts"),
      ),
      SettingModel(
        icon: Icons.remove_red_eye_outlined,
        title: "App Appearance",
        onTap: () => _open(context, "App Appearance"),
      ),
      SettingModel(
        icon: Icons.bar_chart,
        title: "Data & Analytics",
        onTap: () => _open(context, "Data & Analytics"),
      ),
      SettingModel(
        icon: Icons.help_outline,
        title: "Help & Support",
        onTap: () => _open(context, "Help & Support"),
      ),
      SettingModel(
        icon: Icons.star_border,
        title: "Rate us",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Open Play Store Rating")),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ////////////////////////////////////////////////////////////
              /// 🔹 TOP BAR
              ////////////////////////////////////////////////////////////
              Row(
                children: const [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Text(
                      "My Ride",
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Activity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert),
                ],
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              /// 🔹 PROFILE + WALLET CARD
              ////////////////////////////////////////////////////////////
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                            "assets/images/profile.png",
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ansh Saxena",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "+91 987-654-3210",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹ 3582.67",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Available balance",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Text("Top Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              /// 🔹 SETTINGS LIST (DYNAMIC)
              ////////////////////////////////////////////////////////////
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    ...settings.map((e) => SettingTile(model: e)).toList(),
                    const LogoutTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// NAVIGATION HELPER
  ////////////////////////////////////////////////////////////

  void _open(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DummyPage(title: title)),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 SETTING TILE
////////////////////////////////////////////////////////////

class SettingTile extends StatelessWidget {
  final SettingModel model;

  const SettingTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(model.icon),
      title: Text(
        model.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: model.onTap,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 LOGOUT TILE
////////////////////////////////////////////////////////////

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Logged out")));
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 DUMMY PAGE (FOR NAVIGATION TEST)
////////////////////////////////////////////////////////////

class DummyPage extends StatelessWidget {
  final String title;

  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
