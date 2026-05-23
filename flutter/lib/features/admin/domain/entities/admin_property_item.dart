class AdminPropertyItem {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final double price;
  final int beds;
  final int baths;
  final int sqft;
  final bool isAvailable;
  final List<String> tags;
  final String agentName;
  final String agentEmail;

  const AdminPropertyItem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.isAvailable,
    required this.tags,
    required this.agentName,
    this.agentEmail = '',
  });

  String get formattedPrice {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }

  AdminPropertyItem copyWith({bool? isAvailable}) {
    return AdminPropertyItem(
      id: id,
      title: title,
      description: description,
      location: location,
      imageUrl: imageUrl,
      price: price,
      beds: beds,
      baths: baths,
      sqft: sqft,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags,
      agentName: agentName,
      agentEmail: agentEmail,
    );
  }
}
