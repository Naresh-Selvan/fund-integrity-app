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
    final filteredProjects = mockProjects.where((p) {
      final s = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(s) ||
             p.district.toLowerCase().contains(s) ||
             p.state.toLowerCase().contains(s) ||
             p.contractor.toLowerCase().contains(s) ||
             p.id.toLowerCase().contains(s);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.role == 'admin' ? 'Field Authority Dashboard' : 'Citizen Portal'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
            child: Column(
              children: [
                const Text('Find a project near you', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF10151F))),
                const SizedBox(height: 8),
                const Text('Track public infrastructure and ensure accountability.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Color(0xFF5B6472))),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search by area, district, or project name...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF5B6472)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: const Color(0xFFD8DCE2)),
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
                      side: const BorderSide(color: Color(0xFFD8DCE2)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF10151F))),
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
                          Text('BUDGET: ₹${(p.budget/10000000).toStringAsFixed(2)} CR', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: Color(0xFF10151F), letterSpacing: 1.2)),
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
