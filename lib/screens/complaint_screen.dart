import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/project.dart';

class ComplaintScreen extends StatefulWidget {
  final Project project;

  const ComplaintScreen({super.key, required this.project});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _category;
  bool _submitted = false;
  String _trackingId = '';
  bool _isSubmitting = false;

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      if (_category == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category')));
        return;
      }
      
      setState(() {
        _isSubmitting = true;
      });

      final newId = 'COMP-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      
      final catMap = {
        'quality': 'Poor Material Quality',
        'delay': 'Unexplained Delay / Abandoned',
        'ghost': 'Ghost Project (Does not exist)',
        'corruption': 'Suspected Corruption',
        'other': 'Other'
      };

      try {
        final getRes = await http.get(Uri.parse('https://api.restful-api.dev/objects/ff808181a09d98f701a0a96e9e7918bc'));
        final getData = json.decode(getRes.body);
        List complaints = getData['data']['complaints'] ?? [];
        
        complaints.insert(0, {
          'id': newId,
          'projectId': widget.project.id,
          'projectName': widget.project.name,
          'category': catMap[_category] ?? 'Other',
          'status': 'New',
          'date': DateTime.now().toIso8601String().split('T')[0],
          'evidence': true
        });

        await http.put(
          Uri.parse('https://api.restful-api.dev/objects/ff808181a09d98f701a0a96e9e7918bc'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': 'sih-complaints-db',
            'data': {'complaints': complaints}
          })
        );
      } catch (e) {
        print(e);
      }
      
      setState(() {
        _trackingId = newId;
        _submitted = true;
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 24),
                const Text('Complaint Lodged', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Your report has been securely submitted to the Vigilance Department.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('YOUR TRACKING ID', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      Text(_trackingId, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A5F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('BACK TO DIRECTORY', style: TextStyle(color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lodge Complaint'),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your identity remains completely anonymous unless you choose to provide contact details.', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 24),
              _buildLabel('SELECTED PROJECT'),
              TextFormField(
                initialValue: '${widget.project.name} (${widget.project.district})',
                readOnly: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              _buildLabel('COMPLAINT CATEGORY *'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text('-- Select Category --'),
                initialValue: _category,
                items: const [
                  DropdownMenuItem(value: 'quality', child: Text('Poor Material Quality')),
                  DropdownMenuItem(value: 'delay', child: Text('Unexplained Delay / Abandoned')),
                  DropdownMenuItem(value: 'ghost', child: Text('Ghost Project (Does not exist)')),
                  DropdownMenuItem(value: 'corruption', child: Text('Suspected Corruption')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (val) => setState(() => _category = val),
                validator: (val) => val == null ? 'Category is required' : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('DETAILED DESCRIPTION *'),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please describe what you observed...',
                ),
                validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildLabel('PHOTO EVIDENCE'),
                  const Text(' *', style: TextStyle(color: Color(0xFFB23A3A), fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  border: Border.all(color: const Color(0xFFD8DCE2), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFF5B6472)),
                    SizedBox(height: 12),
                    Text('Upload Photos', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF10151F))),
                    SizedBox(height: 4),
                    Text('JPG, PNG up to 10MB', style: TextStyle(color: Color(0xFF5B6472), fontSize: 11, fontFamily: 'monospace')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel('GPS LOCATION'),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.my_location),
                label: const Text('AUTO-CAPTURE LOCATION'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10151F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('SUBMIT ANONYMOUS COMPLAINT', style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10151F), letterSpacing: 1.2)),
    );
  }
}
