class Stock {
  final int id;
  final String name;
  final String symbol;
  final String industry;
  final String sector;
  final double marketCap;
  final int employees;
  final String description;
  final String? website;
  final String? imageUrl;
  final double? price;

  Stock({
    required this.id,
    required this.name,
    required this.symbol,
    required this.industry,
    required this.sector,
    required this.marketCap,
    required this.employees,
    required this.description,
    this.website,
    this.imageUrl,
    this.price,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      industry: json['industry'],
      sector: json['sector'],
      marketCap: double.parse(json['market_cap']), // Parse String to double
      employees: json['employees'],
      description: json['description'],
      website: json['website'],
      imageUrl: json['image']?['url'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
    );
  }
}
