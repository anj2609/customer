import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/widgets/drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CustomAppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 10),
            _onlineMatchesSection(),
            _chatTabs(),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [_chatList(), _chatList(), _chatList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------- TOP BAR ---------------------------------
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: ColorResources.blackcolor11,
                  size: 28,
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 245, 242),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "My Chats",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Image.asset(
              //   'assets/images/search-alt_svgrepo.com.png',
              //   height: 25,
              //   color: ColorResources.blackcolor11,
              // ),
              const SizedBox(width: 16),
              Image.asset('assets/images/bell.png', height: 30),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------- ONLINE MATCHES SECTION --------------------
  Widget _onlineMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Online Matches",
            style: opensansSemiBold.copyWith(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "Invite a chat with your matches to get faster response",
            style: opensansMedium.copyWith(fontSize: 13, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 95,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15),
            children: [
              _onlineUser("assets/images/image 11.png", "Minaxi lekhi"),
              _onlineUser("assets/images/image 12.png", "Urmila Rana"),
              _onlineUser("assets/images/image 13.png", "Kajol Gupta"),
              _onlineUser("assets/images/image 14.png", "Rekha Mishra"),
              _onlineUser("assets/images/image 11.png", "Minaxi lekhi"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _onlineUser(String img, String name) {
    return Container(
      margin: const EdgeInsets.only(right: 18),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 28, backgroundImage: AssetImage(img)),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: opensansMedium.copyWith(
              fontSize: 12,
              color: ColorResources.blackgrey,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- TAB BAR ----------------------------
  Widget _chatTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Text(
            "Online Chat",
            style: opensansSemiBold.copyWith(fontSize: 16),
          ),
        ),
        TabBar(
          controller: tabController,
          labelColor: ColorResources.primarycolor3,
          unselectedLabelColor: Colors.black54,
          indicatorColor: ColorResources.primarycolor3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Unread"),
            Tab(text: "Call"),
          ],
        ),
      ],
    );
  }

  // ---------------------- CHAT LIST ----------------------------
  Widget _chatList() {
    return ListView(
      children: [
        _chatTile(
          "assets/images/image 11.png",
          "Kimmy k",
          "Hello How are you",
          "9:05 AM",
          "5",
        ),
        _divider(),
        _chatTile(
          "assets/images/image 12.png",
          "Kimmy k",
          "Hello How are you",
          "9:05 PM",
          "0",
        ),
        _divider(),
        _chatTile(
          "assets/images/image 13.png",
          "Kimmy k",
          "Hello How are you",
          "25 Oct",
          "4",
        ),
        _divider(),
        _chatTile(
          "assets/images/image 11.png",
          "Kimmy k",
          "Hello How are you",
          "15 Oct",
          "2",
        ),
        _divider(),
        _chatTile(
          "assets/images/image 12.png",
          "Kimmy k",
          "Hello How are you",
          "14 Oct",
          "0",
        ),
        _divider(),
        _chatTile(
          "assets/images/image 13.png",
          "Kimmy k",
          "Hello How are you",
          "13 Oct",
          "9",
        ),
        _divider(),
      ],
    );
  }

  Widget _chatTile(
    String img,
    String name,
    String msg,
    String time,
    String unread,
  ) {
    return ListTile(
      leading: CircleAvatar(radius: 26, backgroundImage: AssetImage(img)),
      title: Text(name, style: opensansSemiBold.copyWith(fontSize: 15)),
      subtitle: Text(
        msg,
        style: opensansMedium.copyWith(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: opensansMedium.copyWith(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          unread != "0"
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: ColorResources.primarycolor3,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    unread,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: Divider(color: Colors.grey.shade400, thickness: 1),
    );
  }
}
