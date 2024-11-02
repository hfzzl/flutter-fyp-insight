
import 'package:flutter/material.dart';
import 'package:insight/src/modules/app/widget/shimmer_load.dart';
import 'package:provider/provider.dart';

import 'quote_model.dart';
import 'quote_view_model.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuoteViewModel>(context);
    return FutureBuilder<QuoteModel>(
      future: viewModel.quote,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerLoad(
            width: double.infinity, 
            height: 200,
            borderRadius: BorderRadius.circular(5),
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(25),
            alignment: Alignment.center,
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage('assets/images/quote_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child:  const Text(
              " \"Man never made any material as resilient as the human spirit.\" \n\nBernard Williams",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontFamily: 'montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),                  
                ],
              ),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(25),
            alignment: Alignment.center,            
            width: 400,
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage('assets/images/quote_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    snapshot.data!.quote,
                    textAlign: TextAlign.center,
                    maxLines: 3, // Allows the text to wrap onto an unlimited number of lines
                    overflow: TextOverflow.ellipsis, // Use an ellipsis to indicate that the text has overflowed
                    style: const TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),                  
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  snapshot.data!.author,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),                  
                ],
              ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}