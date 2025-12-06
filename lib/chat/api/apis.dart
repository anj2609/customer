import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rxdart/rxdart.dart' as rxDart;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:vivashri/chat/api/direct_chat_controller.dart';
import 'package:vivashri/chat/api/notification_access_token.dart';
import 'package:vivashri/chat/screens/chat_screen.dart';
import '../models/chat_user.dart';
import '../models/message.dart';

class APIs with ChangeNotifier {
  // static final EditProfileController _editProfileController =
  //     Get.put(EditProfileController());

  static String myid = '';
  static String name = "";
  static String email = "";
  static int onlineStatus = 0;
  static int lastActiveStatus = 0;
  static String image = '';

  // for authentication
  // static FirebaseAuth get auth => FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static ChatUser me = ChatUser(
    id: myid,
    name: name,
    email: email,
    about: "Hey, I'm using Chat!",
    image: image,
    createdAt: '',
    isOnline: false,
    onlineStatus: onlineStatus,
    lastActiveStatus: lastActiveStatus,
    lastActive: '',
    pushToken: '',
  );

  // to return current user
  // static User get user => auth.currentUser!;
  //start find another user deatils to user id =====================================================================
  Future<ChatUser?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ChatUser.fromJson(data);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
  //End find another user deatils to user id =====================================================================

  //Start  total unread message  =================================================================================

  // Method to get the total unread messages count as a Stream
  static Stream<int> getTotalUnreadMessagesCount() async* {
    try {
      // Listen to all users the current user has conversations with
      final myUsersSnapshot = await firestore
          .collection('users')
          .doc(myid)
          .collection('my_users')
          .get();

      if (myUsersSnapshot.docs.isEmpty) {
        yield 0;
        return;
      }

      final userIds = myUsersSnapshot.docs.map((doc) => doc.id).toList();
      int totalUnreadCount = 0;

      // Combine all streams of unread counts from different conversations
      List<Stream<int>> unreadStreams = [];

      for (final userId in userIds) {
        final conversationId = getConversationID(userId);

        if (conversationId.isNotEmpty) {
          // Stream the unread message count for each conversation
          unreadStreams.add(
            firestore
                .collection('chats/$conversationId/messages/')
                .where('toId', isEqualTo: myid)
                .where('read', isEqualTo: '') // Assuming '' means unread
                .where('fromId', isNotEqualTo: myid)
                .snapshots()
                .map((snapshot) => snapshot.size),
          );
        }
      }

      // Use rxDart.Rx.combineLatest to combine all streams
      yield* rxDart.Rx.combineLatest(unreadStreams, (counts) {
        return counts.fold<int>(0, (sum, count) => sum + (count as int));
      });
    } catch (e) {
      print('Error fetching unread messages count: $e');
      yield 0;
    }
  }
  // End  total unread message =================================================================================

  //Start Update image ===========================================================================================
  static Future<bool> updateUserImage(String imageurl) async {
    try {
      me.image = await imageurl;

      // String imageUrl =  imageurl;
      await firestore.collection('users').doc(myid).update({'image': me.image});

      print('Image updated successfully');
      return true;
    } catch (e) {
      print('Error updating image: $e');
      return false;
    }
  }
  //End Update image ===========================================================================================

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

    // for handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message data: ${message.data}');
        log(
          'Message also contained a notification: ${message.notification!.title}',
        );
      }
    });
  }

  // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
    ChatUser chatUser,
    String msg,
  ) async {
    try {
      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me.name, //our name should be send
            "body": msg,
          },
          "data": {
            "userId": myid, // Include the userId here in the data section
          },
        },
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'devotee-matrimony-992b1';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;
      log('bearerToken: $bearerToken');

      // handle null token
      if (bearerToken == null) return;

      var res = await post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not? = anujboss
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc('').get()).exists;
  }

  // for checking if chat user exists or not?
  static Future<bool> chatUserExists(String id) async {
    return (await firestore
            .collection('users')
            .doc(myid)
            .collection("my_users")
            .doc(id)
            .get())
        .exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('id', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != myid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(myid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(myid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        APIs.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: myid,
      name: name,
      email: email,
      about: "Hey, I'm using chat",
      image: image,
      createdAt: time,
      isOnline: false,
      onlineStatus: onlineStatus,
      lastActive: time,
      lastActiveStatus: lastActiveStatus,
      pushToken: '',
    );

    return await firestore.collection('users').doc(myid).set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(myid)
        .collection('my_users')
        .orderBy('lasttimestamp', descending: true)
        .snapshots()
        .distinct();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
    List<String> userIds,
  ) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where(
          'id',
          whereIn: userIds.isEmpty ? [''] : userIds,
        ) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for getting single users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSingleUsers(
    String userIds,
  ) {
    log('\nUserIds single: $userIds');

    return firestore
        .collection('users')
        // .where('id',
        //     whereIn: userIds.isEmpty
        //         ? ['']
        //         : userIds) //because empty list throws an error
        .where('id', isEqualTo: userIds)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
    ChatUser chatUser,
    String msg,
    Type type,
  ) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(myid)
        .set({})
        .then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(myid).update({
      // 'name': me.name,
      'about': me.about,
    });
  }

  // for updating online status
  static Future<void> updateOnlineStatus(int onlineStatus) async {
    await firestore.collection('users').doc(myid).update({
      'online_status': onlineStatus,
    });
  }

  // for updating lastActive status
  static Future<void> updateLastActiveStatus(int lastActiveStatus) async {
    await firestore.collection('users').doc(myid).update({
      'last_active_status': lastActiveStatus,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${myid}.$ext');

    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((
      p0,
    ) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(myid).update({'image': me.image});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
    ChatUser chatUser,
  ) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(myid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) =>
      myid.hashCode <= id.hashCode ? '${myid}_$id' : '${id}_${myid}';

  // for getting all messages of a specific conversation from firestore database
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
  //     ChatUser user) {
  //   return firestore
  //       .collection('chats/${getConversationID(user.id)}/messages/')
  //       .orderBy('sent', descending: true)
  //       .snapshots();
  // }

  static Stream<List<Message>> getAllMessages(ChatUser user) {
    final currentUserId = myid;
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => Message.fromJson(doc.data() as Map<String, dynamic>),
              )
              .where((message) => !message.deletedBy.contains(currentUserId))
              .toList();
        });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessagesStream(
    ChatUser user,
    DocumentSnapshot? lastMessage,
  ) {
    var query = firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(20);
    if (lastMessage != null) {
      query = query.startAfterDocument(lastMessage);
    }
    return query.snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
    ChatUser chatUser,
    String msg,
    Type type,
  ) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: myid,
      sent: time,
    );

    final ref = firestore.collection(
      'chats/${getConversationID(chatUser.id)}/messages/',
    );

    await ref
        .doc(time)
        .set(message.toJson())
        .then(
          (value) =>
              sendPushNotification(chatUser, type == Type.text ? msg : 'image'),
        );
    await updateLastTimestamp(chatUser.id);
  }

  // Function to update lasttimestamp for a user in the 'my_users' subcollection
  static Future<void> updateLastTimestamp(String userId) async {
    // Get a reference to the Firestore document
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(myid)
        .collection('my_users')
        .doc(userId);
    final userReceviver = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('my_users')
        .doc(myid);

    try {
      // Update the 'lasttimestamp' field with the current server timestamp
      await userDoc.set({
        'lasttimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await userReceviver.set({
        'lasttimestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating lasttimestamp: $e");
    }
  }

  // Function to set typing status
  static Future<void> setTypingStatus(String userId, bool status) async {
    // Get a reference to the Firestore document
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('my_users')
        .doc(myid);

    try {
      // Update the 'lasttimestamp' field with the current server timestamp
      await userDoc.set({'typingStatus': status}, SetOptions(merge: true));
    } catch (e) {
      print("Error updating lasttimestamp: $e");
    }
  }

  // Function to get typing status
  static Stream<bool> getTypingStatus(String userId) {
    // Get a reference to the Firestore document
    final userDoc = FirebaseFirestore.instance
        .collection('users') // 'users' collection
        .doc(myid) // Main user document
        .collection('my_users') // Sub-collection under the user document
        .doc(userId); // Document within sub-collection

    try {
      // Listen to the document and map the result to the typing_status field
      return userDoc.snapshots().map((snapshot) {
        return snapshot.data()?['typingStatus'] ??
            false; // Default to false if null
      });
    } catch (e) {
      print("Error fetching typing status: $e");
      rethrow; // Optionally rethrow the error
    }
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
    ChatUser user,
  ) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //get only UnreadMessageCount of a specific chat
  static Future<int> getUnreadMessageCount(ChatUser user) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .where('toId', isEqualTo: myid) // Messages sent to the user
        .where('read', isEqualTo: '') // Or check for read status not set
        .get();
    return snapshot.docs.length; // Return the count of unread messages
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
      'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext',
    );
    //uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((
      p0,
    ) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //delete receive message
  static Future<void> deleteMessageR(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  // Mark a message as deleted for the current user
  static Future<void> deleteMessageForUser(
    Message message,
    String userId,
  ) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({
          'deletedBy': FieldValue.arrayUnion([userId]),
        });
  }

  // Mark a message as deleted for the current user
  static Future<void> deleteMessageForSender(
    Message message,
    String userId,
  ) async {
    await firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({
          'deletedBy': FieldValue.arrayUnion([userId]),
        });
  }

  static Future<int> getDeletedByLength(Message message) async {
    try {
      final messageRef = firestore
          .collection('chats/${getConversationID(message.fromId)}/messages/')
          .doc(message.sent);

      // Fetch the document
      final snapshot = await messageRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Get the deletedBy array
        final deletedBy = List<String>.from(data['deletedBy'] ?? []);

        // Return the length of the array
        return deletedBy.length;
      } else {
        // Document does not exist
        return 0;
      }
    } catch (e) {
      print('Error fetching deletedBy length: $e');
      return 0;
    }
  }

  // Filter messages to exclude those deleted by the current user
  static Stream<List<Message>> getMessages(
    String conversationId,
    String userId,
  ) {
    return firestore
        .collection('chats/$conversationId/messages/')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => Message.fromJson(doc.data() as Map<String, dynamic>),
              )
              .where((message) => !message.deletedBy.contains(userId))
              .toList();
        });
  }

  // static Stream<List<Message>> getAllMessages(ChatUser user) {
  //   String conversationId = getConversationID(user.id);
  //   return firestore
  //       .collection('chats/$conversationId/messages/')
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs
  //         .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   });
  // }

  // Mark a chat as deleted for the current user
  static Future<void> deleteChat(String chatId, String userId) async {
    await firestore.collection('chats').doc(chatId).update({
      'deletedBy': FieldValue.arrayUnion([userId]),
    });
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  // //=======================================================================================================
  // direct chat ======================================================================================
  static final DirectChatController directChatController = Get.put(
    DirectChatController(),
  );

  static Future<void> fetchUser(BuildContext context, String userId) async {
    ChatUser? user = await directChatController.getUserById(userId);
    if (await chatUserExists(userId)) {
      if (user != null) {
        Get.to(ChatScreen(user: user, block: false));
      } else {
        // Show a snackbar if unable to fetch the user
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Unable to fetch data')));
      }
    } else {
      await APIs.addChatUser(userId).then((value) {
        if (!value) {
          const SnackBar(content: Text('User does not Exists!'));
        } else {
          if (user != null) {
            Get.to(ChatScreen(user: user, block: false));
          } else {
            // Show a snackbar if unable to fetch the user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to fetch data')),
            );
          }
        }
      });
    }
  }
  //=======================================================================================================

  // Block user
  static Future<void> blockUser(String blockedUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the chat document
    String chatId = getConversationID(blockedUserId);

    // Set block data in Firestore
    await firestore.collection('chats').doc(chatId).set({
      'blocked': {'blockedBy': myid, 'blockedUserId': blockedUserId},
    }, SetOptions(merge: true));
  }

  // unblock user
  static Future<void> unblockUser(String blockedUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the chat document
    String chatId = getConversationID(blockedUserId);

    // Remove the 'blocked' field
    await firestore.collection('chats').doc(chatId).update({
      'blocked': FieldValue.delete(),
    });
  }

  // To get block status
  static Future<bool> isBlocked(String otherUserId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Reference to the chat document
      String chatId = getConversationID(
        otherUserId,
      ); // Ensure this function returns the correct chat ID

      DocumentSnapshot chatSnapshot = await firestore
          .collection('chats')
          .doc(chatId)
          .get();

      // Check if the chat document exists
      if (chatSnapshot.exists) {
        // Cast the data to Map<String, dynamic> for safe access
        var data = chatSnapshot.data() as Map<String, dynamic>?;

        // Safely access 'blocked' data
        var blockedData =
            data?['blocked']
                as Map<String, dynamic>?; // Cast to Map if it exists
        if (blockedData != null) {
          String? blockedBy = blockedData['blockedBy']; // Nullable
          String? blockedUserId = blockedData['blockedUserId']; // Nullable
          // Check if the current user (myId) is either blocking or blocked
          return (blockedBy == myid || blockedUserId == myid);
        }
      }
    } catch (e) {
      print('Error checking block status: $e'); // Log any errors
    }
    return false; // Not blocked or an error occurred
  }

  // start get all online user =========================================================================================>
  static Stream<List<Map<String, dynamic>>> getAllOnlineUsersWithLastActive() {
    return firestore
        .collection('users')
        .where('is_online', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final oneHourAgo = now - (60 * 60 * 1000); // 1 hour in milliseconds

          return snapshot.docs.map((doc) => doc.data()).where((data) {
            final lastActive = int.tryParse(data['last_active'] ?? '0') ?? 0;
            return lastActive >= oneHourAgo;
          }).toList();
        });
  }

  static Future<String> getAllOnlineUserIdsString() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourAgo = now - ((60 * 12) * 60 * 1000); // 1 hour ago

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('is_online', isEqualTo: true)
        .get();

    final filteredUserIds = snapshot.docs
        .where((doc) {
          final data = doc.data();
          final lastActive = int.tryParse(data['last_active'] ?? '0') ?? 0;
          return lastActive >= oneHourAgo;
        })
        .map((doc) => doc.data()['id'] ?? '')
        .where((id) => id.isNotEmpty)
        .join(','); // Join into a comma-separated string

    return filteredUserIds;
  }

  // end get all online user =========================================================================================>.
}
