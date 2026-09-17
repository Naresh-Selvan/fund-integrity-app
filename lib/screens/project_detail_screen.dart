import 'package:flutter/material.dart';
import '../models/project.dart';
import 'complaint_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  final String role;

  const ProjectDetailScreen({super.key, required this.project, this.role = 'citizen'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Overview')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF10151F))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Color(0xFF5B6472)),
                      const SizedBox(width: 4),
                      Text('${project.district}, ${project.state}', style: const TextStyle(fontSize: 14, color: Color(0xFF5B6472))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow('PROJECT ID', project.id),
                  _buildInfoRow('SCHEME', project.scheme),
                  _buildInfoRow('CONTRACTOR', project.contractor),
                  _buildInfoRow('STATUS', project.status, isStatus: true),
                ],
              ),
            ),
            const SizedBox(height: 1), // Hairline divider effect via Scaffold background
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Financials & Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10151F))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniCard('BUDGET', '₹${(project.budget/10000000).toStringAsFixed(2)} Cr'),
                      _buildMiniCard('SPENT', '₹${(project.spent/10000000).toStringAsFixed(2)} Cr'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniCard('START DATE', project.startDate),
                      _buildMiniCard('TARGET END', project.endDate),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Public Progress Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10151F))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 4/3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FA),
                              border: Border.all(color: const Color(0xFFD8DCE2)),
                            ),
                            child: const Icon(Icons.image_outlined, color: Color(0xFF5B6472), size: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 4/3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FA),
                              border: Border.all(color: const Color(0xFFD8DCE2)),
                            ),
                            child: const Icon(Icons.image_outlined, color: Color(0xFF5B6472), size: 32),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.verified_user_outlined, color: Color(0xFF1E3A5F)),
                      SizedBox(width: 8),
                      Text('Verify This Work', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF10151F))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('GROUND-TRUTH STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF5B6472), letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    hint: const Text('Matches records'),
                    items: const [
                      DropdownMenuItem(value: 'matches', child: Text('Matches records')),
                      DropdownMenuItem(value: 'not_started', child: Text('Not started despite records')),
                      DropdownMenuItem(value: 'incomplete', child: Text('Incomplete / poor quality')),
                      DropdownMenuItem(value: 'location', child: Text('Different location than listed')),
                    ],
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 16),
                  const Text('ATTACH EVIDENCE PHOTO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF5B6472), letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('UPLOAD PHOTO'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (role == 'citizen') ...[
                    const Text('Help maintain transparency in MPLADS works.', style: TextStyle(color: Color(0xFF5B6472))),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ComplaintScreen(project: project)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10151F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('LODGE COMPLAINT', style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ] else ...[
                    const Text('Submit your physical verification report.', style: TextStyle(color: Color(0xFF5B6472))),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification submitted to Dashboard.')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D5B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('SUBMIT VERIFICATION REPORT', style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF10151F)),
                        ),
                        child: const Text('FLAG FOR INVESTIGATION', style: TextStyle(color: Color(0xFF10151F), letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(32),
              color: const Color(0xFF1E3A5F).withOpacity(0.05),
              child: Column(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 40, color: Color(0xFF1E3A5F)),
                  const SizedBox(height: 16),
                  const Text('Notice something wrong?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF10151F))),
                  const SizedBox(height: 8),
                  const Text('If you observe poor material quality, unexplainable delays, or ghost projects, report it securely to the vigilance department.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF5B6472), height: 1.5)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ComplaintScreen(project: project)),
                      );
                    },
                    icon: const Icon(Icons.chevron_right),
                    label: const Text('REPORT AN ISSUE'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF5B6472), fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(
              fontSize: 15,
              fontWeight: isStatus ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'monospace',
              color: isStatus ? Colors.amber[800] : const Color(0xFF10151F),
            )),
          )
        ],
      ),
    );
  }

  Widget _buildMiniCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          border: Border.all(color: const Color(0xFFD8DCE2)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF5B6472), fontWeight: FontWeight.w600, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF10151F), fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }
}
