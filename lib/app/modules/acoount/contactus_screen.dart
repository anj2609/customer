import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/custom_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.settingDetails(context: context);
  }

  Future<void> launchURL(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> launchEmail(String email) async {
    final Uri uri = Uri.parse("mailto:$email");
    await launchUrl(uri);
  }

  Future<void> launchWhatsApp(String number) async {
    final Uri uri = Uri.parse("https://wa.me/${number.replaceAll("+", "")}");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Contact Support",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          if (controller.isCmsLoading) {
            return  Center(child: PremiumBlurLoader());
          }


              

          final data = controller.settingDetail?.data;

          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.info_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Support information not available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          /// ✅ If data available
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02,
            ),
            child: Column(
              children: [
                if ((data.email ?? "").isNotEmpty)
                  supportTile(
                    icon: Icons.support_agent,
                    title: data.email!,
                    color: Colors.blue,
                    onTap: () => launchEmail(data.email!),
                  ),

                if ((data.websiteUrl ?? "").isNotEmpty)
                  supportTile(
                    icon: Icons.language,
                    title: "Website",
                    color: Colors.blue,
                    onTap: () => launchURL(data.websiteUrl!),
                  ),

                if ((data.mobile ?? "").isNotEmpty)
                  supportTile(
                    icon: Icons.chat,
                    title: "WhatsApp",
                    color: Colors.green,
                    onTap: () => launchWhatsApp(data.mobile!),
                  ),

                if ((data.facebookUrl ?? "").isNotEmpty)
                  supportTile(
                    icon: Icons.facebook,
                    title: "Facebook",
                    color: Colors.blue,
                    onTap: () => launchURL(data.facebookUrl!),
                  ),

                if ((data.instagramUrl ?? "").isNotEmpty)
                  supportTile(
                    icon: Icons.camera_alt,
                    title: "Instagram",
                    color: Colors.purple,
                    onTap: () => launchURL(data.instagramUrl!),
                  ),

                if ((data.twitterUrl ?? "").isNotEmpty)
                  supportTile(
                    icon: Icons.close,
                    title: "X (Formally Twitter)",
                    color: Colors.black,
                    onTap: () => launchURL(data.twitterUrl!),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget supportTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
