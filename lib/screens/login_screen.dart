import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Checking for updates..."),
                ],
              ),
            ),
          );

          try {
            final response = await http.get(Uri.parse('https://raw.githubusercontent.com/Naresh-Selvan/fund-integrity-app/master/version.json'));
            if (!context.mounted) return;
            Navigator.pop(context); // Close loading dialog
            
            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              final latestVersion = data['latestVersionName'];
              const currentVersion = "1.0.3";

              if (latestVersion != currentVersion) {
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Update Available!'),
                    content: Text('Version $latestVersion is now available.\n\n${data['changelog']}'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('LATER')),
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(data['updateUrl']), mode: LaunchMode.externalApplication);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10151F)),
                        child: const Text('DOWNLOAD', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are on the latest version.')));
              }
            } else {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update check failed (404).')));
            }
          } catch (e) {
            if (!context.mounted) return;
            Navigator.pop(context); // Close loading dialog on error
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to connect to update server.')));
          }
        },
        backgroundColor: const Color(0xFF10151F),
        child: const Icon(Icons.system_update_alt, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.account_balance, size: 80, color: Color(0xFF10151F)),
              const SizedBox(height: 24),
              const Text(
                'INTEGRITY\nLEDGER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Color(0xFF10151F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'MPLADS Monitoring Portal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: Color(0xFF5B6472),
                ),
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen(role: 'citizen')),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10151F),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                ),
                child: const Text(
                  'CONTINUE AS CITIZEN',
                  style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen(role: 'admin')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: const BorderSide(color: Color(0xFF10151F), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                ),
                child: const Text(
                  'LOGIN AS AUTHORITY',
                  style: TextStyle(color: Color(0xFF10151F), letterSpacing: 1.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
