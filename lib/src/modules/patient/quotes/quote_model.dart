class QuoteModel {
  final String quote;
  final String author;
  final String category;

  const QuoteModel({
    required this.quote,
    required this.author,
    required this.category,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      quote: json['quote'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quote': quote,
      'author': author,
      'category': category,
    };
  }
}
