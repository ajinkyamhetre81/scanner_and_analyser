
import 'package:flutter/material.dart';
import 'package:scanner_and_analyser/modules/ocr/screens/lens_scan.dart';
import 'package:scanner_and_analyser/modules/upload_pdf/upload_pdf.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _uploadDocument(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadDocument()),
    );
  }

  Future<void> _scanDocument(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DocumentScanner()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        title: const Text(
          'Document Scanner',
          style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 26,
              color: Colors.black54),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Welcome to document scanner! 😊",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 20,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 100,
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
              onPressed: () => _uploadDocument(context),
              child: Icon(
                size: 30,
                Icons.upload_file,
                color: Colors.deepPurple.shade100,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                iconSize: const MaterialStatePropertyAll(30),
                backgroundColor: const MaterialStatePropertyAll(Colors.black),
              ),
              onPressed: () => _scanDocument(context),
              child: Icon(
                size: 30,
                Icons.document_scanner,
                color: Colors.deepPurple.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
