import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Update Available!'),
                    content: const Text('Version 1.0.2 is now available.\n\n- Role-based UI Polish\n- Bug fixes\n- Performance improvements'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('LATER')),
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse('https://github.com/Naresh-Selvan/fund-integrity-app/releases'));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10151F)),
                        child: const Text('DOWNLOAD', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              });

              return const AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Checking for updates..."),
                  ],
                ),
              );
            },
          );
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen(role: 'citizen')),
                  );
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
