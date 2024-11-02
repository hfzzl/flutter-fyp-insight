import 'package:flutter/material.dart';
import 'package:insight/src/modules/patient/quotes/quote_model.dart';

import 'quote_service.dart';

class QuoteViewModel extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();

  Future<QuoteModel>? quote;

  QuoteViewModel() {
    quote = _quoteService.fetchQuote();
  }
}
