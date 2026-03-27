// import 'package:evfual/data/controller/plan_list.dart';
// import 'package:evfual/data/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:evfual/config/utils/style.dart';
// import 'package:evfual/widgets/drawer.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class MyPlanScreen extends StatefulWidget {
//   const MyPlanScreen({super.key});

//   @override
//   State<MyPlanScreen> createState() => _MyPlanScreenState();
// }

// class _MyPlanScreenState extends State<MyPlanScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   final controller = Get.put(PlanController());
//   final profileecontroller = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: CustomAppDrawer(),
//       body: Stack(
//         children: [
//           /// 🔹 Background Image
//           Positioned.fill(
//             child: Image.asset("assets/images/iPhone2.png", fit: BoxFit.cover),
//           ),

//           Column(
//             children: [
//               /// 🔹 HEADER
//               SizedBox(
//                 height: 160,
//                 width: double.infinity,
//                 child: SafeArea(
//                   bottom: false,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.menu,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                               onPressed: () {
//                                 _scaffoldKey.currentState!.openDrawer();
//                               },
//                             ),
//                             Image.asset(
//                               'assets/images/logo.png',
//                               height: 60,
//                               width: 100,
//                             ),

//                             CircleAvatar(
//                                         radius: 18,
//                                         backgroundImage:
//                                             profileecontroller.profileimagee == null
//                                             ? AssetImage(
//                                                 "assets/images/user 1.png",
//                                               )
//                                             : NetworkImage(
//                                                 'https://evfuel.akslearning.in/${profileecontroller.profileimagee}',
//                                               ),
//                                       ),
//                           ],
//                         ),
//                         SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15),
//                           child: Center(
//                             child: Text(
//                               "My Plan",
//                               style: opensansSemiBold.copyWith(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               /// 🔹 LIST
//               Expanded(
//                 child: Obx(() {
//                   if (controller.isLoading.value) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (controller.plan.value == null) {
//                     return const Center(child: Text("No Plan Available"));
//                   }

//                   final item = controller.plan.value!;

//                   return Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SubscriptionCard(
//                       title: item.planName,
//                       usedText: item.totalSwap.toString(),
//                       expiryText: item.validDateTill,
//                       headerColor: Colors.red,
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SubscriptionCard extends StatelessWidget {
//   final String title;
//   final String usedText;
//   final String expiryText;
//   final Color headerColor;

//   const SubscriptionCard({
//     super.key,
//     required this.title,
//     required this.usedText,
//     required this.expiryText,
//     required this.headerColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 28),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.12),
//                   blurRadius: 16,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 /// 🔹 HEADER
//                 Container(
//                   height: 60,
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   decoration: BoxDecoration(
//                     color: headerColor,
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(8),
//                     ),
//                   ),
//                   child: Center(
//                     child: Text(
//                       "PACKAGE NAME: $title",
//                       style: opensansSemiBold.copyWith(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 26),

//                 Text(
//                   '$usedText Batteries Consumed',
//                   style: opensansSemiBold.copyWith(
//                     fontSize: 18,
//                     color: Colors.black,
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),

//           Positioned(
//             top: 135,

//             left: 0,
//             right: 0,
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFD8431E),
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.access_time,
//                       color: Colors.white,
//                       size: 15,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Expired In ',
//                       style: opensansSemiBold.copyWith(
//                         color: Colors.white,
//                         fontSize: 13,
//                       ),
//                     ),
//                     Text(
//                       DateFormat(
//                         'dd-MM-yyyy',
//                       ).format(DateTime.parse(expiryText)),
//                       style: opensansSemiBold.copyWith(
//                         color: Colors.white,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
