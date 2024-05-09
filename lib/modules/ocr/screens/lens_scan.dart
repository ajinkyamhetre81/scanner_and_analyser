import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:scanner_and_analyser/modules/ocr/widgets/result_container.dart';

class DocumentScanner extends StatefulWidget {
  const DocumentScanner({super.key});
  @override
  State<DocumentScanner> createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  String? text;
  bool isClicked = false;
  String extractedText = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal.shade200,
        title: const Text("Document scanner"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ScalableOCR(
            paintboxCustom: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4.0
              ..color = Colors.white,
            boxLeftOff: 5,
            boxBottomOff: 5,
            boxRightOff: 5,
            boxTopOff: 5,
            boxHeight: MediaQuery.of(context).size.height / 4,
            getRawData: (value) {
              inspect(value);
            },
            getScannedText: (value) {
              setText(value);
            },
          ),
          ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                backgroundColor: const MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () {
                setState(() {
                  isClicked = true;
                });
              },
              child: Text(
                'Scan Document',
                style: TextStyle(
                  color: Colors.deepPurple.shade100,
                ),
              )),
          StreamBuilder<String>(
            stream: controller.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              extractedText = snapshot.data ?? "";
              if(extractedText.isEmpty){
                isClicked=false;
              }
              return extractedText.isNotEmpty && isClicked
                  ? ResultContainer(
                      isClicked: isClicked,
                      text: extractedText,
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
