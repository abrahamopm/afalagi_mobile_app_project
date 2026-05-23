import '../../domain/entities/viewing_entity.dart';
import '../../../../Core/database/database_tables.dart';

class ViewingModel extends ViewingEntity {
  const ViewingModel({
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
    super.interestScore,
  });

  factory ViewingModel.fromJson(Map<String, dynamic> json) {
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

    return ViewingModel(
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
      interestScore: json['interestScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property': propertyId,
      'client': clientId,
      'date': date,
      'status': status,
      'notes': notes,
      'interestScore': interestScore,
    };
  }

  factory ViewingModel.fromMap(Map<String, dynamic> map) {
    return ViewingModel(
      id: map[DatabaseTables.colViewingId] ?? '',
      propertyId: map[DatabaseTables.colViewingPropertyId] ?? '',
      clientId: map[DatabaseTables.colViewingClientId] ?? '',
      propertyTitle: map[DatabaseTables.colViewingPropertyTitle] ?? '',
      clientName: map[DatabaseTables.colViewingClientName] ?? '',
      imageUrl: map[DatabaseTables.colViewingImageUrl] ?? '',
      date: map[DatabaseTables.colViewingDate] ?? '',
      status: map[DatabaseTables.colViewingStatus] ?? '',
      price: map[DatabaseTables.colViewingPrice] ?? '',
      notes: map[DatabaseTables.colViewingNotes] ?? '',
      interestScore: map[DatabaseTables.colViewingInterestScore] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseTables.colViewingId: id,
      DatabaseTables.colViewingPropertyId: propertyId,
      DatabaseTables.colViewingClientId: clientId,
      DatabaseTables.colViewingPropertyTitle: propertyTitle,
      DatabaseTables.colViewingClientName: clientName,
      DatabaseTables.colViewingImageUrl: imageUrl,
      DatabaseTables.colViewingDate: date,
      DatabaseTables.colViewingStatus: status,
      DatabaseTables.colViewingPrice: price,
      DatabaseTables.colViewingNotes: notes,
      DatabaseTables.colViewingInterestScore: interestScore,
    };
  }

  factory ViewingModel.fromEntity(ViewingEntity entity) {
    return ViewingModel(
      id: entity.id,
      propertyId: entity.propertyId,
      clientId: entity.clientId,
      propertyTitle: entity.propertyTitle,
      clientName: entity.clientName,
      imageUrl: entity.imageUrl,
      date: entity.date,
      status: entity.status,
      price: entity.price,
      notes: entity.notes,
      interestScore: entity.interestScore,
    );
  }
}
