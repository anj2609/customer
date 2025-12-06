import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  //get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

// get date===============================================================
  static String getFormattedDate(
      {required BuildContext context, required String timestampString}) {
    // Convert timestamp string to integer
    int timestamp = int.parse(timestampString);

    // Convert integer to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Get the current date
    DateTime now = DateTime.now();

    // Normalize dates to remove time component for comparison
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime startOfWeek =
        today.subtract(Duration(days: today.weekday - 1)); // Start of this week

    // Normalize the dateTime for comparison
    DateTime normalizedDateTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day);

    // Calculate the difference in days
    int differenceInDays = normalizedDateTime.difference(today).inDays;

    // Determine the format based on the difference
    if (normalizedDateTime.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (normalizedDateTime.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else if (differenceInDays >= -6 && differenceInDays <= 0) {
      // This is within the current week
      return DateFormat('EEEE')
          .format(dateTime); // Full name of the day (e.g., "Monday")
    } else {
      // Format the date as "dd MMM yyyy" for older dates
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

// time stamp to date and time
  static String getTimestampToDateFormat(
      {required BuildContext context, String? timestamp}) {
    if (timestamp != null) {
      if (timestamp.isNotEmpty) {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        DateTime dateTime = dateFormat.parse(timestamp);
        String timestampString = dateTime.millisecondsSinceEpoch.toString();
        String time = getFormattedTime(context: context, time: timestampString);
        return "$time ${getFormattedDate(context: context, timestampString: timestampString)}";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

// compare date to timestamp ==================================================
  static bool shouldShowDate(String timestamp1, String? timestamp2) {
    if (timestamp2 == null) return true;
    DateTime dateTime1 =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp1));
    DateTime dateTime2 =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp2));

    return !(dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day);
  }

//=============================================================================

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
