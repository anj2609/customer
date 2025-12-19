
import 'package:flutter/material.dart';
import 'package:vivashri/call_parent/chat/api/apis.dart';
import 'package:vivashri/call_parent/chat/models/chat_user.dart';

class TestPage extends StatefulWidget {
  final String userId;

  TestPage({required this.userId});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  ChatUser? _chatUser;
  final APIs _userService = APIs();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    ChatUser? user = await _userService.getUserById(widget.userId);
    setState(() {
      _chatUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatUser?.name ?? 'User Profile'),
      ),
      body: _chatUser == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.network(_chatUser!.image),
                  SizedBox(height: 16.0),
                  Text(
                    _chatUser!.name,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text('Email: ${_chatUser!.email}'),
                  SizedBox(height: 8.0),
                  Text('About: ${_chatUser!.about}'),
                  SizedBox(height: 8.0),
                  Text('Last Active: ${_chatUser!.lastActive}'),
                  SizedBox(height: 8.0),
                  Text(
                      'Online Status: ${_chatUser!.isOnline ? "Online" : "Offline"}'),
                ],
              ),
            ),
    );
  }
}
