import 'package:flutter/material.dart';
import 'package:vivashri/chat/api/apis.dart';
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
            style: opensansMedium.copyWith(
              fontSize: 22,
              color: ColorResources.primarycolor2,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(
            '0',
            style: opensansMedium.copyWith(
              fontSize: 22,
              color: ColorResources.primarycolor2,
            ),
          );
        }
        final unreadCount = snapshot.data ?? 0;
        return Text(
          '$unreadCount',
          style: opensansMedium.copyWith(
            fontSize: 22,
            color: ColorResources.primarycolor2,
          ),
        );
      },
    );
  }
}
