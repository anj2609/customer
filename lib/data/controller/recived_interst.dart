import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/data/modal/inbox/accept_by_me.dart';
import 'package:vivashri/data/modal/inbox/accpet_bypartner.dart';
import 'package:vivashri/data/modal/inbox/declined.dart';
import 'package:vivashri/data/modal/inbox/pending.dart';
import 'package:vivashri/data/modal/inbox/received.dart';
import 'package:vivashri/data/modal/inbox/shortlisted_profile.dart';

class InboxReceivedController extends GetxController {
  var isLoading = false.obs;
  RxList<InboxData> inboxList = <InboxData>[].obs;
  RxList<PendinginboxData> pendingList = <PendinginboxData>[].obs;
  RxList<DeclinedinboxData> declinedList = <DeclinedinboxData>[].obs;

  RxList<AcceptedbymeinboxData> acceptedbymeList =
      <AcceptedbymeinboxData>[].obs;
  RxList<AcceptedpartnerinboxData> acceptedbypartnerlist =
      <AcceptedpartnerinboxData>[].obs;

  RxList<ShortlistedProfileinboxData> shotlisttedList =
      <ShortlistedProfileinboxData>[].obs;
  Future<void> fetchInboxData() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/inbox-received",
      );

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"member_id": ""}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var model = InboxReceivedModel.fromJson(jsonData);

        inboxList.value = model.data ?? [];
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pendinginboxdata() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/inbox-sent-pending",
      );

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"member_id": ""}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var model = InboxPenidngModel.fromJson(jsonData);

        pendingList.value = model.data ?? [];
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptedbyme() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/inbox-accepted-me",
      );

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"member_id": ""}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var model = InboxAcceptedbymeModel.fromJson(jsonData);

        acceptedbymeList.value = model.data ?? [];
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptedbypartner() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/inbox-accepted-partner",
      );

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"member_id": "", "pageType": ""}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var model = InboxAcceptedbypartnerModel.fromJson(jsonData);

        acceptedbypartnerlist.value = model.data ?? [];
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> declinedinboxdata() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/inbox-sent-decline",
      );

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"member_id": "", "pageType": ""}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var model = InboxDeclinedModel.fromJson(jsonData);

        declinedList.value = model.data ?? [];
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }

  //=-=-=-=-=-==-=
  Future<void> shortlistedprofileinboxdata() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/shortlist-list",
      );

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"pageType": ""}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var model = InboxShortlistProfileModel.fromJson(jsonData);

        shotlisttedList.value = model.data ?? [];
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
