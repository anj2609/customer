import 'package:evfual/app/modules/Deshboard/tipscreen_screen.dart';
import 'package:flutter/material.dart';

class DriverRatingScreen extends StatefulWidget {
  const DriverRatingScreen({super.key});

  @override
  State<DriverRatingScreen> createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen> {
  int selectedRating = 0;

  Widget buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRating = index;
        });
      },
      child: Icon(
        Icons.star,
        size: 40,
        color: index <= selectedRating ? Colors.amber : Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// CLOSE ICON
                Row(children: const [Icon(Icons.close)]),

                const SizedBox(height: 10),

                /// DRIVER IMAGE
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=12",
                  ),
                ),

                const SizedBox(height: 15),

                /// TITLE
                const Text(
                  "How was the driver?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Help MyRide do better by rating this trip",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// ⭐ RATING STARS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => buildStar(index + 1)),
                ),

                const SizedBox(height: 20),

                /// INFO CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: const [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Ride"), Text("Economy (Non-AC)")],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Payment"), Text("MyRide Wallet")],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// FARE SUMMARY
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Trip Fare"), Text("₹ 560")],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Discount (20%)"), Text("- ₹ 112")],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Paid",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹ 448",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Hide details",
                  style: TextStyle(color: Colors.blue),
                ),

                const SizedBox(height: 18),

                /// GIVE RATE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TipScreen()),
                      );
                    },
                    // onPressed: selectedRating == 0
                    //     ? null
                    //     : () {
                    //         print("Rating Given: $selectedRating");
                    //       },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff19A7CE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Give Rate",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



