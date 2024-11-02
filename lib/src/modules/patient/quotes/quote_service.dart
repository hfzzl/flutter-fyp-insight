import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:insight/src/modules/patient/quotes/quote_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class QuoteService {
  Future<QuoteModel> fetchQuote() async {
    final apiKey = dotenv.env['QUOTE_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found');
    }
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes?category=inspirational'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return QuoteModel.fromJson(body.first as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
