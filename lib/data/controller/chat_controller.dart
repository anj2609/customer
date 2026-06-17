import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/data/modal/chatmessages_model.dart';

import 'package:myrideuser/data/repository/chat_repo.dart';

class ChatController extends GetxController {
  final ChatRepo chatRepo;

  ChatController({required this.chatRepo});

  String? chatId;
  String? chatIds;
  String? senderId;
  String? messagesDate;
  int? isRead;

  bool isLoading = false;
  bool messagesSeen = false;

  List<ChatMessagesModel> chatMessagesList = [];
  Future<Response> startChats({
    required BuildContext context,
    required String bookingId,
    required String driverId,
    required String customerId,
  }) async {
    isLoading = true;
    update();

    try {

      print('text |||||||||||||| $customerId');
      Response response = await chatRepo.startChat(
        bookingId: bookingId,
        driverId: driverId,
        customerId: customerId,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'] == '200') {
        if (response.body['data'] != null &&
            response.body['data']['id'] != null) {
          chatId = response.body['data']['id'].toString();

          print("Created Chat Id: $chatId");
        }

        update();
        return response;
      } else if (response.body != null && response.body['code'] == '401') {
        print("Unauthorized request");
        return response;
      } else {
        print("Chat creation failed");
        return response;
      }
    } catch (e) {
      print("Start Chat Error: $e");

      return Response(statusCode: 500, statusText: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<Response> sendChatMessages({
    required BuildContext context,
    required String bookingId,
    required String driverId,
    required String customerId,
    required String message,
  }) async {
    isLoading = true;
    update();

    try {
      print('chat id |||||  $bookingId');
      print('chat id |||||  $driverId');
      print('chat id |||||  $customerId');
      print('chat id |||||  $chatId');
      print(message);
      Response response = await chatRepo.sendChat(
        bookingId: bookingId.toString(),
        driverId: driverId.toString(),
        customerId: customerId.toString(),
        chatId: chatId ?? '',
        messages: message.toString(),
      );

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == '200') {
        var resp = response.body;

        chatId = resp['data']?['chat_id']?.toString();
        senderId = resp['data']?['sender_id']?.toString();
        messagesDate = resp['data']?['created_at']?.toString();
        isRead = resp['data']?['is_read'];

        await chatessagesList(context: context);

        update();
      }

      return response;
    } catch (e) {
      print("Send Message Error: $e");
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  /////===============  Chat Messages Lists  =============================
  Future<Response> chatessagesList({required BuildContext context}) async {
    isLoading = chatMessagesList.isEmpty;
    update();

    try {
      Response response = await chatRepo.chatMessagesLists(
        chatId: chatId,
        lastid: '1',
      );
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == "200") {
        MessagesModel messagesModel = MessagesModel.fromJson(response.body);

        chatMessagesList.clear();
        chatMessagesList.addAll(messagesModel.data ?? []);

        update();

        return response;
      } else if (response.body != null &&
          response.body['code'].toString() == "401") {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<Response> chatMessageListingSeen({
    required BuildContext context,
  }) async {
    isLoading = true;
    update();

    try {
      Response response = await chatRepo.chatLists();
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == "200") {
        update();

        return response;
      } else if (response.body != null &&
          response.body['code'].toString() == "401") {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<Response> messageRead({
    required BuildContext context,
    required String chatId,
  }) async {
    try {
      Response response = await chatRepo.chatRead(chatId: chatId);

      if (response.statusCode == 200 && response.body['code'] == '200') {
        messagesSeen = true;
        update();

        print("Messages Seen Successfully");
      }

      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
