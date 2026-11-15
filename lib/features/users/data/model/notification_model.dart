class NotificationModel {
  const NotificationModel({
    required this.title,
    required this.description,
    required this.date,
    this.productId,
    this.imageUrl,
  });

  final String title;
  final String description;
  final DateTime date;
  final String? productId;
  final String? imageUrl;
}
