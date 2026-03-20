import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    String htmlData = """
    <h4>Effective Date: December 20, 2024</h4>

    <p>
    These Terms of Service (“Terms”) govern your access to and use of the 
    My Ride mobile application (“App”) and related services (“Services”) 
    offered by My Ride (“My Ride”, “we”, “us”, or “our”).
    </p>

    <h3>1. User Agreement:</h3>
    <p>
    By accessing or using the GoRide Services, you agree to be bound by these Terms. 
    If you do not agree to all of these Terms, do not access or use the Services.
    </p>

    <h3>2. Account Creation:</h3>
    <p>
    You must be at least 18 years old and have the legal capacity to enter into 
    a binding contract to use the Services.
    </p>

    <h3>3. Your Responsibilities:</h3>
    <ul>
      <li>
      You are responsible for maintaining the confidentiality of your account login 
      information and for all activities that occur under your account.
      </li>
      <li>
      You agree to use the Services only for lawful purposes and in accordance with these Terms.
      </li>
    </ul>
    """;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Term of Services",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: 20,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Html(
              data: htmlData,
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  lineHeight: LineHeight(1.6),
                  color: Colors.black87,
                ),
                "h3": Style(
                  fontSize: FontSize(16),
                  fontWeight: FontWeight.bold,
                ),
                "h4": Style(
                  fontSize: FontSize(15),
                  fontWeight: FontWeight.w600,
                ),
                "li": Style(
                  margin: Margins.only(bottom: 8),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}