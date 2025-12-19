import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:vivashri/call_parent/chat/widgets/Snackbar.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../models/message.dart';

DateTime parseDate(String dateString) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    // Handle parsing error, e.g., log the error or return a default date
    return DateTime.now(); // or a default DateTime
  }
}

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message, this.previousMessage});

  final Message message;
  final Message? previousMessage;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool shouldShowDate = MyDateUtil.shouldShowDate(
      widget.message.sent,
      widget.previousMessage?.sent,
    );
    bool isMe = APIs.myid == widget.message.fromId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shouldShowDate)
          DateSeparator(
            date: MyDateUtil.getFormattedDate(
              context: context,
              timestampString: widget.message.sent,
            ),
          ),
        GestureDetector(
          onLongPress: () => _showBottomSheet(isMe, context),
          child: isMe ? _greenMessage() : _blueMessage(),
        ),
      ],
    );
  }

  // sender or another user message
  Widget _blueMessage() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //message content
        Container(
          padding: EdgeInsets.all(
            widget.message.type == Type.image
                ? screenWidth * .02
                : screenWidth * .03,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * .04,
            vertical: screenHeight * .01,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 221, 245, 255),
            border: Border.all(color: Colors.lightBlue),
            //making borders curved
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: widget.message.type == Type.text
              ?
                //show text
                Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                )
              :
                //show image
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.msg,
                    width: screenWidth * 0.6,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image, size: 70),
                  ),
                ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(left: screenWidth * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(
            widget.message.type == Type.image
                ? screenWidth * .02
                : screenWidth * .03,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * .04,
            vertical: screenHeight * .01,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 218, 255, 176),
            border: Border.all(color: Colors.lightGreen),
            //making borders curved
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: widget.message.type == Type.text
              ?
                //show text
                Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                )
              :
                //show image
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.msg,
                    width: screenWidth * 0.6,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image, size: 70),
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * .04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //for adding some space
              SizedBox(width: screenWidth * .04),

              //double tick blue icon for message read
              if (widget.message.read.isNotEmpty)
                const Icon(
                  Icons.done_all_rounded,
                  color: Colors.blue,
                  size: 20,
                ),

              //for adding some space  getFormattedTime
              const SizedBox(width: 2),
              // MyDateUtil.getMessageTime(context: context, time: widget.message.sent)
              //sent time
              Text(
                MyDateUtil.getFormattedTime(
                  context: context,
                  time: widget.message.sent,
                ),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            //black divider
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: screenHeight * .015,
                horizontal: screenWidth * .4,
              ),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),

            widget.message.type == Type.text
                ?
                  //copy option
                  _OptionItem(
                    icon: const Icon(
                      Icons.copy_all_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.message.msg),
                      ).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, 'Text Copied!');
                      });
                    },
                  )
                :
                  //save option
                  _OptionItem(
                    icon: const Icon(
                      Icons.download_rounded,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Save Image',
                    onTap: () async {
                      try {
                        log('Image Url: ${widget.message.msg}');
                        // await GallerySaver.saveImage(
                        //   widget.message.msg,
                        //   albumName: 'We Chat',
                        // ).then((success) {
                        //   //for hiding bottom sheet
                        //   Navigator.pop(context);
                        //   if (success != null && success) {
                        //     Dialogs.showSnackbar(
                        //       context,
                        //       'Image Successfully Saved!',
                        //     );
                        //   }
                        // });
                      } catch (e) {
                        log('ErrorWhileSavingImg: $e');
                      }
                    },
                  ),

            //separator or divider
            if (isMe)
              Divider(
                color: Colors.black54,
                endIndent: screenWidth * .04,
                indent: screenWidth * .04,
              ),

            //edit option
            if (widget.message.type == Type.text && isMe)
              _OptionItem(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                name: 'Edit Message',
                onTap: () {
                  //for hiding bottom sheet
                  Navigator.of(context).pop();

                  _showMessageUpdateDialog(context);
                },
              ),

            //delete option
            _OptionItem(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 26,
              ),
              name: 'Delete for me',
              onTap: () async {
                final currentUserId = APIs.myid;
                if (isMe) {
                  // await APIs.deleteMessageR(widget.message).then((value) {
                  //   //for hiding bottom sheet
                  //   Navigator.pop(context);
                  // });
                  await APIs.deleteMessageForUser(
                    widget.message,
                    currentUserId,
                  ).then((value) {
                    // For hiding bottom sheet
                    Navigator.pop(context);
                  });
                } else {
                  await APIs.deleteMessageForSender(
                    widget.message,
                    currentUserId,
                  ).then((value) {
                    // For hiding bottom sheet
                    Navigator.pop(context);
                  });
                }
              },
            ),

            if (isMe)
              _OptionItem(
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 26,
                ),
                name: 'Delete for everyone',
                onTap: () async {
                  await APIs.deleteMessage(widget.message).then((value) {
                    //for hiding bottom sheet
                    Navigator.pop(context);
                  });
                },
              ),

            //separator or divider
            Divider(
              color: Colors.black54,
              endIndent: screenWidth * .04,
              indent: screenWidth * .04,
            ),

            //sent time
            _OptionItem(
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
              name:
                  'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),

            //read time
            _OptionItem(
              icon: const Icon(Icons.remove_red_eye, color: Colors.green),
              name: widget.message.read.isEmpty
                  ? 'Read At: Not seen yet'
                  : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  //dialog for updating message content
  void _showMessageUpdateDialog(BuildContext context) {
    String updatedMsg = widget.message.msg;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: 10,
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),

        //title
        title: const Row(
          children: [
            Icon(Icons.message, color: Colors.blue, size: 28),
            Text(' Update Message'),
          ],
        ),

        //content
        content: TextFormField(
          initialValue: updatedMsg,
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),

        //actions
        actions: [
          //cancel button
          MaterialButton(
            onPressed: () {
              //hide alert dialog
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),

          //update button
          MaterialButton(
            onPressed: () {
              //hide alert dialog
              Navigator.pop(context);
              APIs.updateMessage(widget.message, updatedMsg);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * .05,
          top: screenHeight * .015,
          bottom: screenHeight * .015,
        ),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          date,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
    );
  }
}
