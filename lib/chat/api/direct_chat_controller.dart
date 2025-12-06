import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:vivashri/chat/models/chat_user.dart';

class DirectChatController extends GetxController {
  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reactive variables
  var isLoading = false.obs;
  var user = Rxn<ChatUser>();
  var error = RxnString();

  // Method to fetch user by ID
  Future<ChatUser?> getUserById(String userId) async {
    try {
      isLoading.value = true; // Set loading state

      DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        user.value = ChatUser.fromJson(data); // Set user data
        return ChatUser.fromJson(data);
      } else {
        error.value = 'User not found'; // Set error message
        user.value = null; // Clear user data
        return null;
      }
    } catch (e) {
      error.value = 'Error fetching user: $e'; // Set error message
      user.value = null; // Clear user data
      return null;
    } finally {
      isLoading.value = false; // Clear loading state
    }
  }
}
