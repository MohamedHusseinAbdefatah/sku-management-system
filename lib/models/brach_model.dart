class InventoryBranch {
  final String id;
  final String name;
  final String location;
  final String contact;

  InventoryBranch({
    required this.id,
    required this.name,
    required this.location,
    required this.contact,
  });

  // Keep existing serialization methods if needed elsewhere
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contact': contact,
    };
  }

  factory InventoryBranch.fromMap(Map<String, dynamic> map) {
    return InventoryBranch(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      contact: map['contact'],
    );
  }
}
