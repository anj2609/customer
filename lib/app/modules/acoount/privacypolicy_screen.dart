import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final String privacyPolicyHtml = """
  

  <p><strong>Effective Date: December 19, 2024</strong></p>

  <p>
  My Ride ("My Ride", "we", "us", or "our") respects the privacy of our users 
  ("you" or "your"). This Privacy Policy describes how we collect, use, disclose, 
  and protect your information when you use our mobile application ("App") and 
  related services ("Services").
  </p>

  <h3>1. Information We Collect:</h3>

  <p><strong>• Account Information:</strong> 
  When you create a My Ride account, we collect your name, phone number, 
  email address, and profile picture (optional).
  </p>

  <p><strong>• Location Information:</strong> 
  We collect your location information, including your pick-up and drop-off 
  locations, to facilitate ride bookings and track your driver’s arrival.
  </p>

  <p><strong>• Payment Information:</strong> 
  We collect your payment information, such as credit card details, when you 
  top up your My Ride Wallet or pay for rides.
  </p>

  <p><strong>• Device Information:</strong> 
  We collect information about your device, such as model, operating system, 
  and unique device identifier, to improve app functionality.
  </p>
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Html(
            data: privacyPolicyHtml,
            style: {
              "body": Style(
                fontSize: FontSize(14),
                lineHeight: const LineHeight(1.6),
                color: Colors.black87,
              ),
              "h2": Style(
                fontSize: FontSize(18),
                fontWeight: FontWeight.w600,
                margin: Margins.only(bottom: 12),
              ),
              "h3": Style(
                fontSize: FontSize(16),
                fontWeight: FontWeight.bold,
                margin: Margins.only(top: 16, bottom: 8),
              ),
              "p": Style(margin: Margins.only(bottom: 12)),
              "strong": Style(fontWeight: FontWeight.w600),
            },
          ),
        ),
      ),
    );
  }
}
