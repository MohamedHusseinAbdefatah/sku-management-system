class SKU {
  final String code;
  final String itemName;
  final String category;

  bool isActive;

  DateTime? deactivationDate;

  final DateTime creationDate;

  int quantity;

  int reservedStock;

  int reorderThreshold;

  SKU({
    required this.code,
    required this.itemName,
    required this.category,
    required this.creationDate,
    this.isActive = true,
    this.deactivationDate,
    this.quantity = 0,
    this.reservedStock = 0,
    this.reorderThreshold = 10,
  });

  // Maintain existing serialization methods
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'itemName': itemName,
      'category': category,
      'isActive': isActive ? 1 : 0,
      'quantity': quantity,
      'reservedStock': reservedStock,
      'reorderThreshold': reorderThreshold,
      'creationDate': creationDate.toIso8601String(),
      'deactivationDate': deactivationDate?.toIso8601String(),
    };
  }

  factory SKU.fromMap(Map<String, dynamic> map) {
    return SKU(
      code: map['code'],
      itemName: map['itemName'],
      category: map['category'],
      isActive: map['isActive'] == 1,
      quantity: map['quantity'],
      reservedStock: map['reservedStock'],
      reorderThreshold: map['reorderThreshold'],
      creationDate: DateTime.parse(map['creationDate']),
      deactivationDate: map['deactivationDate'] != null
          ? DateTime.parse(map['deactivationDate'])
          : null,
    );
  }
}
