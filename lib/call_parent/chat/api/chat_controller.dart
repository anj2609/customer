import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatController extends GetxController {
  // Store the current chatId
  var currentChatId = Rx<String?>(null);

  // Set the current chatId when navigating to a chat screen
  void setCurrentChatId(String chatId) {
    currentChatId.value = chatId;
  }

  // Reset the current chatId when leaving the chat screen
  void resetChatId() {
    currentChatId.value = null;
  }
}
