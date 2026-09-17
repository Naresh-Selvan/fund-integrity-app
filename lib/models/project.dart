class Project {
  final String id;
  final String name;
  final String scheme;
  final String state;
  final String district;
  final String contractor;
  final String status;
  final double budget;
  final double spent;
  final String startDate;
  final String endDate;

  Project({
    required this.id,
    required this.name,
    required this.scheme,
    required this.state,
    required this.district,
    required this.contractor,
    required this.status,
    required this.budget,
    required this.spent,
    required this.startDate,
    required this.endDate,
  });
}
