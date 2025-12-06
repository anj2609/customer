import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivashri/config/utils/colors.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';
import '../widgets/chat_user_card.dart';

//home screen -- where all available contacts are shown
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot<Map<String, dynamic>>>? _userStream;

  // for storing all users
  List<String> _lists = [];
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _userStream = APIs.getMyUsersId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });
  }

  void initializeData() async {
    APIs.getSelfInfo();
    // await userProfileController.userDetails(context).then((_) {
    //   if ((userProfileController.member?.member?.accountType ?? 0) != 1) {
    //     //  DialogConstant.packageDialog(context, 'chat feature');
    //   }
    // });

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (APIs.myid != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.amber,
        //app bar
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: ColorResources.primarycolor2,

          //view profile
          // leading: IconButton(
          //   icon: SvgPicture.asset("assets/images/menu.svg"),
          //   onPressed: () {
          //     scaffoldKey.currentState?.openDrawer();
          //   },
          // ),
          //title
          // title: _isSearching
          //     ? TextField(
          //         decoration: const InputDecoration(
          //             border: InputBorder.none,
          //             hintText: 'Search......',
          //             hintStyle: TextStyle(color: AppColors.constColor)),
          //         autofocus: true,
          //         style: const TextStyle(
          //             fontSize: 17,
          //             letterSpacing: 0.5,
          //             color: AppColors.constColor),
          //         //when search text changes then updated search list
          //         onChanged: (val) {
          //           //search logic
          //           _searchList.clear();

          //           val = val.toLowerCase();

          //           for (var i in _list) {
          //             if (i.name.toLowerCase().contains(val) ||
          //                 i.email.toLowerCase().contains(val)) {
          //               _searchList.add(i);
          //             }
          //           }
          //           setState(() => _searchList);
          //         },
          //       )
          //     : const Text('My Chat'),
          actions: [
            // IconButton(
            //   tooltip: 'View Profile',
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (_) => ProfileScreen(user: APIs.me)));
            //   },
            //   icon: ProfileImage(
            //     size: 40,
            //     url: APIs.me.image,
            //   ),
            //   padding: EdgeInsets.all(0),
            // ),
            //search user button
            // IconButton(
            //     tooltip: 'Search',
            //     onPressed: () => setState(() => _isSearching = !_isSearching),
            //     icon: Icon(_isSearching
            //         ? CupertinoIcons.clear_circled_solid
            //         : CupertinoIcons.search)),
          ],
        ),

        //body
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.topRight,
              child: Image.asset("assets/images/background.png"),
            ),
            StreamBuilder(
              stream: _userStream,
              //get id of only known users
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorResources.primarycolor2,
                      ),
                    );

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    _lists =
                        snapshot.data?.docs.map((e) => e.id).toList() ?? [];
                    // return StreamBuilder(
                    //   stream: APIs.getAllUsers(
                    //       snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //   //get only those user, who's ids are provided
                    //   builder: (context, snapshot) {
                    //     switch (snapshot.connectionState) {
                    //       //if data is loading
                    //       case ConnectionState.waiting:
                    //       case ConnectionState.none:
                    //       // return const Center(
                    //       //     child: CircularProgressIndicator());

                    //       //if some or all data is loaded then show it
                    //       case ConnectionState.active:
                    //       case ConnectionState.done:
                    //         _list = data
                    //                 ?.map((e) => ChatUser.fromJson(e.data()))
                    //                 .toList() ??
                    //             [];

                    if (_lists.isNotEmpty) {
                      // here i want one by one user get information
                      return ListView.builder(
                        itemCount: _lists.length,
                        padding: const EdgeInsets.only(top: 10),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                            // user: _isSearching
                            //     ? _searchList[index]
                            //     : _list[index],
                            ids: _lists[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No user Found!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
                //       },
                //     );
                // }
              },
            ),
          ],
        ),
        //  drawer: CustomDrawer(scaffoldKey: scaffoldKey),
      ),
      // ),
    );
  }
}
