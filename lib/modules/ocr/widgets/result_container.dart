import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class ResultContainer extends StatelessWidget {
  final bool isClicked;
  final String text;

  const ResultContainer({
    Key? key,
    required this.isClicked,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade600,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade200, Colors.teal.shade200],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Scanned Data:",
                        style: TextStyle(fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'CormorantGaramond'),
                      ),
                      const SizedBox(height: 5),
                      isClicked?
                      Expanded(
                        child: SingleChildScrollView(
                          child: SelectableText(
                            text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ):Container(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Durations.long4,
                        behavior: SnackBarBehavior.floating,
                        content: Text('Text copied to clipboard...'),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue.shade100,
                  tooltip: 'Copy Text',
                  child: const Icon(
                    Icons.content_copy,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade600,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade200, Colors.teal.shade200],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: isClicked
                          ? Text(
                              "Sentiment: ${analyzeSentiment(text)}",
                              style: const TextStyle(fontSize: 16),
                            )
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String analyzeSentiment(String text) {
    final analysisResult = Sentiment.analysis(text);

    if (analysisResult.score < 0) {
      return ('Negative sentiment');
    } else if (analysisResult.score > 0) {
      return ('Positive sentiment');
    } else {
      return ('Neutral sentiment');
    }
  }
}
