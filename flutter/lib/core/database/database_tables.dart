class DatabaseTables {
  // Table names
  static const String properties = 'properties';
  static const String clients = 'clients';
  static const String viewings = 'viewings';
  static const String tags = 'tags';
  static const String cacheMetadata = 'cache_metadata';

  // Cache TTL (5 minutes in milliseconds)
  static const int cacheTtlMs = 300000;

  // Metadata Columns
  static const String colMetadataTable = 'table_name';
  static const String colMetadataLastUpdated = 'last_updated';

  // Property Columns
  static const String colPropId = 'id';
  static const String colPropTitle = 'title';
  static const String colPropDescription = 'description';
  static const String colPropLocation = 'location';
  static const String colPropImageUrl = 'imageUrl';
  static const String colPropPrice = 'price';
  static const String colPropBeds = 'beds';
  static const String colPropBaths = 'baths';
  static const String colPropSqft = 'sqft';
  static const String colPropIsAvailable = 'isAvailable';
  static const String colPropTags = 'tags'; // JSON array of strings

  // Client Columns
  static const String colClientId = 'id';
  static const String colClientName = 'name';
  static const String colClientPhone = 'phone';
  static const String colClientPriority = 'priority';
  static const String colClientInterest = 'interest';
  static const String colClientArea = 'area';
  static const String colClientBudget = 'budget';
  static const String colClientImage = 'image';
  static const String colClientTags = 'tags'; // JSON array of strings

  // Viewing Columns
  static const String colViewingId = 'id';
  static const String colViewingPropertyId = 'propertyId';
  static const String colViewingClientId = 'clientId';
  static const String colViewingPropertyTitle = 'propertyTitle';
  static const String colViewingClientName = 'clientName';
  static const String colViewingImageUrl = 'imageUrl';
  static const String colViewingDate = 'date';
  static const String colViewingStatus = 'status';
  static const String colViewingPrice = 'price';
  static const String colViewingNotes = 'notes';

  // Tag Columns
  static const String colTagId = 'id';
  static const String colTagName = 'name';
  static const String colTagColor = 'color';
  static const String colTagPropertyCount = 'propertyCount';
}
