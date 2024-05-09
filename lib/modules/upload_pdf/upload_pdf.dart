


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner_and_analyser/modules/ocr/widgets/pdf_viewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UploadDocument extends StatefulWidget {
  const UploadDocument({Key? key}) : super(key: key);

  @override
  _UploadDocumentState createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  File? selectedFile;
  String extractedText = '';
  bool isClicked = false;

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _viewPdf() async {
    if (selectedFile == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PdfViewerPage(filePath: selectedFile!.path),
    ));
  }

  Future<void> _extractData() async {
    if (selectedFile == null) {
      return;
    }
    extractedText = '';
    final document = PdfDocument(
      inputBytes: selectedFile!.readAsBytesSync(),
    );
    final extractor = PdfTextExtractor(document);
    for (int i = 0; i < document.pages.count; i++) {
      final pageText = await extractor.extractText(startPageIndex: i);
      extractedText += pageText;
    }
    setState(() {
      isClicked = true;
    });
  }
  
  
  Future<void> _downloadJsonData() async {
    if (extractedText.isNotEmpty) {
      // Convert extracted text to JSON format
      final jsonData = {'extractedText': extractedText};
      final jsonString = jsonEncode(jsonData);

      // Get the directory where the JSON file will be saved
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Create the file
        File jsonFile = File('${directory.path}/extracted_data.json');

        // Write JSON data to the file
        await jsonFile.writeAsString(jsonString);

        // Show a message that JSON file is saved
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('JSON file saved to ${directory.path}'),
          ),
        );
      } else {
        // Unable to access directory
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Unable to access directory'),
          ),
        );
      }
    } else {
      // No extracted text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No text extracted'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        title: const Text('PDF Upload and Read'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _openFileExplorer,
              child: Text(
                'Select PDF File',
                style: TextStyle(
                  color: Colors.deepPurple.shade100,
                ),
              ),
            ),
            if (selectedFile != null) ...[
              SizedBox(height: 20),
              Text(
                'Selected File:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                selectedFile!.path.split('/').last,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _viewPdf,
                child: Text(
                  'View PDF',
                  style: TextStyle(
                    color: Colors.deepPurple.shade100,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _extractData,
                child: Text(
                  'Extract Data',
                  style: TextStyle(
                    color: Colors.deepPurple.shade100,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: isClicked
                    ? Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade600,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade200,
                                  Colors.teal.shade200
                                ],
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
                                  SizedBox(height: 10),
                                  Text(
                                    'Extracted Text:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: extractedText.isNotEmpty
                                          ? Text(
                                              extractedText,
                                              style: TextStyle(fontSize: 16),
                                            )
                                          : Container(),
                                    ),
                                  ),
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
                                Clipboard.setData(
                                    ClipboardData(text: extractedText));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 4),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Text copied to clipboard...',
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue.shade100,
                              tooltip: 'Copy Text',
                              child: Icon(
                                Icons.content_copy,
                                size: 20,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: FloatingActionButton(
                              mini: true,
                              onPressed: _downloadJsonData,
                              backgroundColor: Colors.blue.shade100,
                              tooltip: 'Download JSON',
                              child: Icon(
                                Icons.file_download,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
