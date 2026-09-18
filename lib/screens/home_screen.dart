import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'project_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({super.key, this.role = 'citizen'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'admin';
    
    var baseProjects = isAdmin 
      ? mockProjects.where((p) => p.status == 'Flagged' || p.status == 'In Progress').toList()
      : mockProjects;

    if (isAdmin) {
      baseProjects.sort((a, b) => b.riskScore.compareTo(a.riskScore));
    }

    final filteredProjects = baseProjects.where((p) {
      final s = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(s) ||
             p.district.toLowerCase().contains(s) ||
             p.state.toLowerCase().contains(s) ||
             p.contractor.toLowerCase().contains(s) ||
             p.id.toLowerCase().contains(s);
    }).take(100).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Field Authority Dashboard' : 'Citizen Portal'),
        backgroundColor: isAdmin ? const Color(0xFF1E3A5F) : Colors.white,
        foregroundColor: isAdmin ? Colors.white : Colors.black,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: isAdmin ? const Color(0xFF10151F) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
            child: Column(
              children: [
                Text(
                  isAdmin ? 'Your Assigned Inspections' : 'Find a project near you', 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isAdmin ? Colors.white : const Color(0xFF10151F))
                ),
                const SizedBox(height: 8),
                Text(
                  isAdmin ? 'Upload compliance photos and clear ML-flagged anomalies.' : 'Track public infrastructure and ensure accountability.', 
                  textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 15, color: isAdmin ? const Color(0xFFD8DCE2) : const Color(0xFF5B6472))
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(color: isAdmin ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: isAdmin ? 'Search by project ID or contractor...' : 'Search by area, district, or project name...',
                    hintStyle: TextStyle(color: isAdmin ? Colors.white54 : Colors.black54),
                    prefixIcon: Icon(Icons.search, color: isAdmin ? Colors.white54 : const Color(0xFF5B6472)),
                    filled: isAdmin,
                    fillColor: isAdmin ? Colors.white.withValues(alpha: 0.1) : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: isAdmin ? Colors.transparent : const Color(0xFFD8DCE2), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: isAdmin ? Colors.white : const Color(0xFF1E3A5F), width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isAdmin) Container(height: 1, color: const Color(0xFFD8DCE2)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                final p = filteredProjects[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: isAdmin && p.riskScore > 70 ? Colors.red.withValues(alpha: 0.5) : const Color(0xFFD8DCE2)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF10151F)))),
                        if (isAdmin && p.riskScore > 70)
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                             decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                             child: const Text('HIGH RISK', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                           )
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF5B6472)),
                              const SizedBox(width: 4),
                              Text('${p.district}, ${p.state}', style: const TextStyle(color: Color(0xFF5B6472), fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('BUDGET: ₹${(p.budget/10000000).toStringAsFixed(2)} CR', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Color(0xFF10151F), letterSpacing: 1.2)),
                              if (isAdmin) Text('SCORE: ${p.riskScore}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: p.riskScore > 70 ? Colors.red : Colors.green, letterSpacing: 1.2)),
                            ]
                          )
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF5B6472)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProjectDetailScreen(project: p, role: widget.role)),
                      );
                    },
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
