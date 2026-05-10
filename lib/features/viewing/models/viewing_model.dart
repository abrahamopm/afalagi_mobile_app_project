class Viewing {
  final String id;
  final String propertyId;
  final String clientId;
  final String propertyTitle;
  final String clientName;
  final String imageUrl;
  final String date;
  final String status;
  final String price;
  final String notes;

  Viewing({
    required this.id,
    required this.propertyId,
    required this.clientId,
    required this.propertyTitle,
    required this.clientName,
    required this.imageUrl,
    required this.date,
    required this.status,
    required this.price,
    this.notes = '',
  });

  Viewing copyWith({
    String? id,
    String? propertyId,
    String? clientId,
    String? propertyTitle,
    String? clientName,
    String? imageUrl,
    String? date,
    String? status,
    String? price,
    String? notes,
  }) {
    return Viewing(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      clientId: clientId ?? this.clientId,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      clientName: clientName ?? this.clientName,
      imageUrl: imageUrl ?? this.imageUrl,
      date: date ?? this.date,
      status: status ?? this.status,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }
}
