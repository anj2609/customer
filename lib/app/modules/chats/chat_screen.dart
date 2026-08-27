import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/chat_controller.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerChatScreen extends StatefulWidget {
  final DatTrackRideDetails? acceptData;
  final String? bookingId;

  const CustomerChatScreen({Key? key, this.acceptData, this.bookingId})
    : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  // Was Get.put(ChatController(...)) — constructs and re-registers a brand
  // new instance every time this screen opens, discarding whatever state
  // the existing one already had. ChatController is registered app-wide
  // via Get.lazyPut (get_di.dart), and findingdriver_screen.dart's own
  // Get.find<ChatController>().startChats(...) call — which sets chatId —
  // runs on that same singleton right before navigating here. Re-putting a
  // fresh instance wiped chatId back to null the instant this screen
  // mounted, so chatessagesList() had no real chat_id to query with and
  // the message list came back empty every time, even for a chat that
  // genuinely had history. Get.find reuses the same instance instead.
  final ChatController controller = Get.find<ChatController>();

  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? refreshTimer;

  String customerId = "";
  String driverId = "";
  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    getIds();
    loadChats();
    controller.loadQuickMessages();

    refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await loadChats();
    });
  }

  Future<void> getIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    customerId = prefs.getString(ApiConstants.profileid).toString();

    driverId = widget.acceptData?.driverInfo?.driverid.toString() ?? "";
  }

  Future<void> loadChats() async {
    try {
      await controller.chatessagesList(context: context);

      if (controller.chatId != null) {
        await controller.messageRead(
          context: context,
          chatId: controller.chatId.toString(),
        );
      }

      if (mounted) {
        controller.update();
      }
    } catch (e) {
      debugPrint("Chat Refresh Error: $e");
    }
  }

  /// Shared by the text field's send button and every quick-reply chip —
  /// same request, same clear-and-refresh behaviour, whichever one
  /// actually supplied the text.
  Future<void> _send(String text) async {
    final messageText = text.trim();
    if (messageText.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    messageController.clear();

    try {
      await controller.sendChatMessages(
        context: context,
        bookingId: widget.acceptData?.bookingId.toString() ?? "",
        driverId: driverId,
        customerId: customerId,
        message: messageText,
      );
      await loadChats();
      _scrollToBottom();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driverInfo = widget.acceptData?.driverInfo;
    final hasDriverImage =
        driverInfo?.profileImage != null && driverInfo!.profileImage!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: ColorResources.blueeebutton.withValues(alpha: 0.12),
              backgroundImage: hasDriverImage
                  ? NetworkImage("${ApiConstants.imageurl}${driverInfo.profileImage}")
                  : null,
              child: !hasDriverImage
                  ? Icon(Icons.person_rounded, color: ColorResources.blueeebutton)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                driverInfo?.name?.toString().trim().isNotEmpty == true
                    ? driverInfo!.name.toString()
                    : "Driver",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PoppinsSemiBold.copyWith(fontSize: 15, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFEFF3FF),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                "Keep your account safe — never share personal info in chat",
                style: PoppinsReguler.copyWith(fontSize: 11, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: GetBuilder<ChatController>(
                builder: (controller) {
                  if (controller.isLoading && controller.chatMessagesList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.chatMessagesList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          "No messages yet. Say hello, or use a quick reply below.",
                          textAlign: TextAlign.center,
                          style: PoppinsReguler.copyWith(fontSize: 13, color: Colors.black45),
                        ),
                      ),
                    );
                  }

                  // Scrolled to the bottom once per fresh build of a
                  // genuinely new list length, not on every 2s refresh poll
                  // regardless of whether anything changed — that would
                  // yank the view down out from under someone scrolling
                  // back through history.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!_scrollController.hasClients) return;
                    final atBottom = _scrollController.position.pixels >=
                        _scrollController.position.maxScrollExtent - 40;
                    if (atBottom) _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    itemCount: controller.chatMessagesList.length,
                    itemBuilder: (context, index) {
                      final msg = controller.chatMessagesList[index];
                      final bool isMe = msg.senderId.toString() == customerId.toString();

                      final String dateTime = msg.createdAt ?? "";
                      String msgDate = "";
                      String msgTime = "";
                      if (dateTime.contains(" ")) {
                        msgDate = dateTime.split(" ").first;
                        if (dateTime.length >= 16) {
                          msgTime = dateTime.substring(11, 16);
                        }
                      }

                      bool showDate = index == 0;
                      if (!showDate) {
                        final prevDate =
                            (controller.chatMessagesList[index - 1].createdAt ?? "")
                                .split(" ")
                                .first;
                        showDate = prevDate != msgDate;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showDate)
                            Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  msgDate == DateTime.now().toString().split(" ").first
                                      ? "Today"
                                      : msgDate,
                                  style: PoppinsMedium.copyWith(fontSize: 11, color: Colors.black54),
                                ),
                              ),
                            ),
                          Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              padding: const EdgeInsets.fromLTRB(14, 10, 12, 8),
                              constraints: BoxConstraints(
                                // Relative to the available width, not a
                                // fixed px figure, so this scales sanely
                                // from a small phone to a tablet.
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isMe ? ColorResources.blueeebutton : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(14),
                                  topRight: const Radius.circular(14),
                                  bottomLeft: Radius.circular(isMe ? 14 : 4),
                                  bottomRight: Radius.circular(isMe ? 4 : 14),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg.message ?? "",
                                    style: PoppinsReguler.copyWith(
                                      fontSize: 14.5,
                                      color: isMe ? Colors.white : Colors.black87,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        msgTime,
                                        style: PoppinsReguler.copyWith(
                                          fontSize: 10.5,
                                          color: isMe
                                              ? Colors.white.withValues(alpha: 0.75)
                                              : Colors.black38,
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          controller.messagesSeen ? Icons.done_all : Icons.done,
                                          size: 14,
                                          color: controller.messagesSeen
                                              ? Colors.lightBlueAccent
                                              : Colors.white.withValues(alpha: 0.75),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // ---- Quick replies — /customer-chat-master-list ----
            GetBuilder<ChatController>(
              builder: (controller) {
                if (controller.quickMessages.isEmpty) return const SizedBox.shrink();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: controller.quickMessages.map((text) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: _QuickReplyChip(
                            label: text,
                            enabled: !_isSending,
                            onTap: () => _send(text),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),

            // ---- Composer ----
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, -2))],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 120),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: messageController,
                          minLines: 1,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          style: PoppinsReguler.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "Write a message…",
                            hintStyle: PoppinsReguler.copyWith(fontSize: 14, color: Colors.black38),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onSubmitted: (_) => _send(messageController.text),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _send(messageController.text),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: _isSending
                            ? ColorResources.blueeebutton.withValues(alpha: 0.5)
                            : ColorResources.blueeebutton,
                        child: _isSending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single tappable quick-reply pill. Its own widget purely so the label
/// text can size itself (FittedBox/ellipsis) without every call site
/// repeating the same constraints.
class _QuickReplyChip extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _QuickReplyChip({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: enabled ? onTap : null,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: ColorResources.blueeebutton.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ColorResources.blueeebutton.withValues(alpha: 0.35)),
          ),
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: PoppinsMedium.copyWith(fontSize: 12.5, color: ColorResources.blueeebutton),
          ),
        ),
      ),
    );
  }
}
