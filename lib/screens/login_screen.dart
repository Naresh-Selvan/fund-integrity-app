import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both username and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network auth
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(role: 'admin')),
      );
    } else if (username == 'citizen' && password == 'citizen123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen(role: 'citizen')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials. Try admin/admin123 or citizen/citizen123')),
      );
    }
  }

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
            if (!mounted) return;
            Navigator.pop(context); // Close loading dialog
            
            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              final latestVersion = data['latestVersionName'];
              const currentVersion = "1.0.3";

              if (latestVersion != currentVersion) {
                if (!mounted) return;
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
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are on the latest version.')));
              }
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update check failed (404).')));
            }
          } catch (e) {
            if (!mounted) return;
            Navigator.pop(context); // Close loading dialog on error
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to connect to update server.')));
          }
        },
        backgroundColor: const Color(0xFF10151F),
        child: const Icon(Icons.system_update_alt, color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  const SizedBox(height: 48),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username (citizen or admin)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10151F),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'SECURE LOGIN',
                          style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                        ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Demo Credentials:\nCitizen: citizen / citizen123\nAdmin: admin / admin123',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
