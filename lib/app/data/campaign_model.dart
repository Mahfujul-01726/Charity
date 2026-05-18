class CampaignModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final double goal;
  final double raised;
  final int daysLeft;
  final String imageUrl;
  final String organizer;

  CampaignModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.goal,
    required this.raised,
    required this.daysLeft,
    required this.imageUrl,
    required this.organizer,
  });
}

// Mock saved campaigns data
List<CampaignModel> savedCampaigns = [
  CampaignModel(
    id: '1',
    title: 'Clean Water Initiative',
    category: 'Environment',
    description: 'Providing clean and safe drinking water to rural communities in developing nations.',
    goal: 50000,
    raised: 32500,
    daysLeft: 15,
    imageUrl: 'assets/images/water_campaign.jpg',
    organizer: 'Water For All Foundation',
  ),
  CampaignModel(
    id: '2',
    title: 'Education for Every Child',
    category: 'Education',
    description: 'Building schools and providing educational resources to underprivileged children.',
    goal: 100000,
    raised: 78900,
    daysLeft: 30,
    imageUrl: 'assets/images/education_campaign.jpg',
    organizer: 'Global Education Initiative',
  ),
  CampaignModel(
    id: '3',
    title: 'Emergency Medical Aid',
    category: 'Medical',
    description: 'Providing emergency medical supplies and support to disaster-affected areas.',
    goal: 75000,
    raised: 45000,
    daysLeft: 7,
    imageUrl: 'assets/images/medical_campaign.jpg',
    organizer: 'Medics Without Borders',
  ),
  CampaignModel(
    id: '4',
    title: 'Save the Rainforest',
    category: 'Environment',
    description: 'Protecting endangered rainforest areas and wildlife habitats from deforestation.',
    goal: 200000,
    raised: 125000,
    daysLeft: 45,
    imageUrl: 'assets/images/forest_campaign.jpg',
    organizer: 'Green Earth Alliance',
  ),
  CampaignModel(
    id: '5',
    title: 'Disaster Relief Fund',
    category: 'Disaster Relief',
    description: 'Emergency relief for victims of natural disasters including food, shelter, and medical care.',
    goal: 150000,
    raised: 135000,
    daysLeft: 5,
    imageUrl: 'assets/images/disaster_relief.jpg',
    organizer: 'Emergency Response Team',
  ),
];