class DonationModel {
  final String id;
  final String category;
  final String title;
  final double amount;
  final String date;
  final String status;
  final String? transactionId;
  final String? description;

  DonationModel({
    required this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    this.transactionId,
    this.description,
  });
}

// Mock donations data
List<DonationModel> mockDonations = [
  DonationModel(
    id: '1',
    category: 'Blood Donation',
    title: 'Red Cross Blood Drive',
    amount: 0.00,
    date: '2024-01-15',
    status: 'Completed',
    transactionId: 'TXN123456',
    description: 'Donated blood at the local Red Cross center',
  ),
  DonationModel(
    id: '2',
    category: 'Money Donation',
    title: 'Emergency Relief Fund',
    amount: 250.00,
    date: '2024-01-10',
    status: 'Completed',
    transactionId: 'TXN123457',
    description: 'Contributed to earthquake relief fund',
  ),
  DonationModel(
    id: '3',
    category: 'Food Donation',
    title: 'Local Food Bank',
    amount: 0.00,
    date: '2024-01-08',
    status: 'Completed',
    description: 'Donated canned goods and non-perishable items',
  ),
  DonationModel(
    id: '4',
    category: 'Education',
    title: 'School Supplies Campaign',
    amount: 100.00,
    date: '2024-01-05',
    status: 'Pending',
    transactionId: 'TXN123458',
  ),
  DonationModel(
    id: '5',
    category: 'Medicine',
    title: 'Medical Aid for Children',
    amount: 500.00,
    date: '2024-01-03',
    status: 'Completed',
    transactionId: 'TXN123459',
  ),
];