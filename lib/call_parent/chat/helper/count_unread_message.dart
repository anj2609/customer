import 'package:flutter/material.dart';
import 'package:vivashri/call_parent/chat/api/apis.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class CountUnreadMessage extends StatelessWidget {
  CountUnreadMessage();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: APIs.getTotalUnreadMessagesCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            '0',
            style: opensansRegular.copyWith(
              fontSize: 22,
              color: ColorResources.primarycolor2,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
            '0',
            style: opensansRegular.copyWith(
              fontSize: 22,
              color: ColorResources.primarycolor2,
            ),
          );
          print('Error: ${snapshot.error}');
        }
        final unreadCount = snapshot.data ?? 0;
        return Text(
          '$unreadCount',
          style: opensansRegular.copyWith(
            fontSize: 22,
            color: ColorResources.primarycolor2,
          ),
        );
      },
    );
  }
}
