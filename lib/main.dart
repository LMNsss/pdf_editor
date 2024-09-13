import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PdfControllerPinch pdfControllerPinch;
  int totalPageCount = 0;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với Future<PdfDocument>
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openAsset('assets/test_pdf.pdf'),
    );
  }

  @override
  void dispose() {
    pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PDF Viewer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Total Pages: $totalPageCount"),
            IconButton(
              onPressed: () {
                pdfControllerPinch.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Text("$currentPage/$totalPageCount"),
            IconButton(
              onPressed: () {
                pdfControllerPinch.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        Expanded(
          child: PdfViewPinch(
            controller: pdfControllerPinch,
            scrollDirection: Axis.vertical,
            onDocumentLoaded: (document) {
              setState(() {
                totalPageCount = document.pagesCount;
              });
            },
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
              });
            },
          ),
        ),
      ],
    );
  }
}




