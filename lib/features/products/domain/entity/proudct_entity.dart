class ProductEntity {
  final String pId;
  final String name;
  final String description;
  final double price;

  final String imageUrl;

  final String category;
  final int stock;

  final bool isFeatured;
  final String sId;
  final DateTime? createdAt;
  final String staffName;
  final int discount;
  ProductEntity({
    required this.discount,
    required this.staffName,
    this.createdAt,
    required this.pId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.isFeatured,
    required this.sId,
  });

  factory ProductEntity.empty() => ProductEntity(
    pId: '',
    name: '',
    imageUrl: '',
    price: 0,
    discount: 0,
    staffName: '',
    createdAt: null,
    description: '',
    category: '',
    stock: 0,
    isFeatured: false,
    sId: '',
  );
}
