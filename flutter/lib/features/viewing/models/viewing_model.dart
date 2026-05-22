import '../domain/entities/viewing_entity.dart';

class Viewing extends ViewingEntity {
  const Viewing({
    required super.id,
    required super.propertyId,
    required super.clientId,
    required super.propertyTitle,
    required super.clientName,
    required super.imageUrl,
    required super.date,
    required super.status,
    required super.price,
    super.notes,
  });

  factory Viewing.fromJson(Map<String, dynamic> json) {
    String propId = '';
    String propTitle = 'Unknown Property';
    String propImg = 'assets/images/generic_property.png';
    String propPrice = '';

    if (json['property'] != null) {
      if (json['property'] is Map<String, dynamic>) {
        final propMap = json['property'] as Map<String, dynamic>;
        propId = propMap['id'] ?? propMap['_id'] ?? '';
        propTitle = propMap['title'] ?? 'Unknown Property';
        propImg = propMap['imageUrl'] ?? 'assets/images/generic_property.png';
        propPrice = propMap['price'] != null ? '\$${propMap['price']}' : '';
      } else {
        propId = json['property'].toString();
      }
    }

    String cliId = '';
    String cliName = 'Unknown Client';
    if (json['client'] != null) {
      if (json['client'] is Map<String, dynamic>) {
        final cliMap = json['client'] as Map<String, dynamic>;
        cliId = cliMap['id'] ?? cliMap['_id'] ?? '';
        cliName = cliMap['name'] ?? 'Unknown Client';
      } else {
        cliId = json['client'].toString();
      }
    }

    return Viewing(
      id: json['id'] ?? json['_id'] ?? '',
      propertyId: propId,
      clientId: cliId,
      propertyTitle: propTitle,
      clientName: cliName,
      imageUrl: propImg,
      date: json['date'] ?? '',
      status: json['status'] ?? 'Recent',
      price: propPrice,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property': propertyId,
      'client': clientId,
      'date': date,
      'status': status,
      'notes': notes,
    };
  }

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
