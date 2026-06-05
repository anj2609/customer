
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PromoCodeScreen extends StatefulWidget {
  final String? promo_id;
   PromoCodeScreen({super.key, this.promo_id});

  @override
  State<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _handleRedeem() {
    String code = _controller.text.trim();

    if (code == "EOYP25") {
      _showSuccessSheet();
    } else {
      _showErrorSheet();
    }
  }

  void _showErrorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration:  BoxDecoration(
            color: ColorResources.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: ColorResources.primarycolor2,
                child: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),
              const Text(
                "Whoops!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "It looks like the promo code you entered is invalid or expired.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }


  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.teal,
                child: const Icon(Icons.check, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 20),
              const Text(
                "Promo Code Applied!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your promo code has been successfully redeemed. Enjoy your discounted ride!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Use Later"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      onPressed: () {},
                      child: const Text("Use Now"),
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: width * 0.06,
          right: width * 0.06,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height - MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// Close Button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.05),

                /// Image
                Image.asset(
                  'assets/images/promocode.png',
                  height: height * 0.20,
                ),

                SizedBox(height: height * 0.05),

                /// Title
                Text(
                  "Have a Promo Code?",
                  style: PoppinsSemiBold.copyWith(
                  color: ColorResources.blackcolor11,
                ),
                ),

                SizedBox(height: height * 0.04),

                /// TextField
                Container(
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "EOYP25",
                      border: InputBorder.none,
                      hintStyle:  PoppinsSemiBold.copyWith(
                  color: ColorResources.blackcolor11,
                ),
                    ),
                  ),
                ),

                const Spacer(),

                /// Redeem Button
                /// 
                /// 
                 /// Redeem Button
              CustomPrimaryButton(text: "Redeem", onTap: () => _handleRedeem,
              
               ),
              



                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
 
}