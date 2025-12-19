import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivashri/call_parent/chat/helper/my_date_util.dart';
import 'package:vivashri/config/utils/style.dart';

class LastOnline {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get the is_online status based on user_id
  Future<bool> getUserIsOnline(String userId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourAgo = now - ((60 * 12) * 60 * 1000); // 1 hour ago
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;
        final lastActive = int.tryParse(data?['last_active'] ?? '0') ?? 0;
        return ((data?['is_online'] ?? false) && lastActive >= oneHourAgo);
      } else {
        print("User not found");
        return false;
      }
    } catch (e) {
      print("Error fetching is_online status: $e");
      return false;
    }
  }

  // Function to get the last_active time based on user_id
  Future<String> getUserLastActive(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;
        return data?['last_active'] ?? 'Unknown';
      } else {
        print("User not found");
        return 'Unknown';
      }
    } catch (e) {
      print("Error fetching last_active time: $e");
      return 'Unknown';
    }
  }
}

class UserStatusWidget extends StatelessWidget {
  final String userId;
  final int onlineStatus;
  final int lastSeenStatus;
  final Color? color;
  final LastOnline lastOnlineService = LastOnline();
  UserStatusWidget({
    required this.userId,
    required this.onlineStatus,
    required this.lastSeenStatus,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: lastOnlineService.getUserIsOnline(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is being resolved
          return Text(
            'Loading...',
            style: opensansMedium.copyWith(fontSize: 13),
          );
        } else if (snapshot.hasError) {
          // If an error occurred
          return Text(
            'Error: ${snapshot.error}',
            style: opensansMedium.copyWith(fontSize: 13),
          );
        } else if (snapshot.hasData) {
          // If the future returned a value
          bool isOnline = snapshot.data ?? false;

          if (isOnline && onlineStatus == 0) {
            return Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  'Online',
                  style: opensansMedium.copyWith(
                    fontSize: 13,
                    color: Colors.green,
                  ),
                ),
              ],
            );
          } else if (lastSeenStatus == 0) {
            // If the user is not online, show the last active time
            return FutureBuilder<String>(
              future: lastOnlineService.getUserLastActive(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Loading...',
                    style: opensansMedium.copyWith(
                      fontSize: 13,
                      color: color ?? Colors.grey,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: opensansMedium.copyWith(
                      fontSize: 13,
                      color: color ?? Colors.grey,
                    ),
                  );
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: color ?? Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${MyDateUtil.getLastActiveTime(context: context, lastActive: "${snapshot.data}")}',
                          style: opensansMedium.copyWith(
                            fontSize: 13,
                            color: color ?? Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else {
            return Text("");
          }
        } else {
          return Text('Unknown status');
        }
      },
    );
  }
}
