class Product {
  String id;
  String name;
  String obs;
  String category;
  bool isKilograms;
  double? price;
  double? amount;
  bool isPurchased;

  Product({
    required this.id,
    required this.name,
    required this.obs,
    required this.category,
    required this.isKilograms,
    required this.isPurchased,
    this.price,
    this.amount,
  });

  Product.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        obs = map["obs"],
        category = map["category"],
        isKilograms = map["isKilograms"],
        isPurchased = map["isPurchased"],
        price = (map["price"] != null && map["price"].runtimeType == int)
            ? double.parse(map["price"].toString())
            : map["price"],
        amount = (map["amount"] != null && map["amount"].runtimeType == int)
            ? double.parse(map["amount"].toString())
            : map["amount"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "obs": obs,
      "category": category,
      "isKilograms": isKilograms,
      "isPurchased": isPurchased,
      "price": price,
      "amount": amount,
    };
  }
}
