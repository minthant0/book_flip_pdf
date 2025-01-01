import 'dart:async';import 'dart:typed_data';import 'package:flutter/material.dart';import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';import 'package:page_flip/page_flip.dart';class TestPdfPage extends StatefulWidget {  const TestPdfPage({super.key});  @override  State<TestPdfPage> createState() => _TestPdfPageState();}class _TestPdfPageState extends State<TestPdfPage> { // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();  final Completer<PDFViewController> _pdfViewController =  Completer<PDFViewController>();  final StreamController<String> _pageCountController =  StreamController<String>();  late  int currentPage=0;  late int? pageCount=0;  @override  void initState() {  //  _pdfViewerKey.currentState?.openBookmarkView();    super.initState();  }  @override  Widget build(BuildContext context) {    return Scaffold(      floatingActionButton: FutureBuilder<PDFViewController>(        future: _pdfViewController.future,        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {          if (snapshot.hasData && snapshot.data != null) {            return Row(              mainAxisSize: MainAxisSize.max,              mainAxisAlignment: MainAxisAlignment.spaceAround,              children: <Widget>[                FloatingActionButton(                  heroTag: '-',                  child:  Text('-',style: TextStyle(fontSize: 21),),                  onPressed: ()  async {                    final PDFViewController pdfController = snapshot.data!;                    currentPage =                    (await pdfController.getCurrentPage())! - 1;                    if (currentPage >= 0) {                    await pdfController.setPage(currentPage);                    }                  },                ),                Text(currentPage.toString()+" / "+pageCount.toString(),style: TextStyle(fontSize: 19,color: Colors.black),),                FloatingActionButton(                  heroTag: '+',                  child:  Text('+',style: TextStyle(fontSize: 21),),                  onPressed: ()  async {                    final PDFViewController pdfController = snapshot.data!;                    final int currentPage =                    (await pdfController.getCurrentPage())! + 1;                    final int numberOfPages =                    await pdfController.getPageCount() ?? 0;                    if (numberOfPages > currentPage) {                    await pdfController.setPage(currentPage);                    }                  },                ),              ],            );          }          return const SizedBox();        },      ),      appBar: AppBar(        title: const Text('Cached PDF From Url'),      ),      body: PDF(        enableSwipe: true,        swipeHorizontal: true,        autoSpacing: false,        pageFling: false,        onPageChanged: (int? current, int? total) {          setState(() {            currentPage=current!;            pageCount=total;            _pageCountController.add('${current! + 1} - $total');          });        },        onViewCreated: (PDFViewController pdfViewController) async {          print("View");         /* _pdfViewController.complete(pdfViewController);          currentPage = await pdfViewController.getCurrentPage() ?? 0;          pageCount = await pdfViewController.getCurrentPage();          _pageCountController.add('${currentPage + 1} - $pageCount');*/        },      ).cachedFromUrl(        "http://www.pdf995.com/samples/pdf.pdf",        placeholder: (double progress) => Center(child: Text('$progress %')),        errorWidget: (dynamic error) => Center(child: Text(error.toString())),      ),    );  }}class BookFlipReader extends StatefulWidget {  final String pdfUrl;  const BookFlipReader({Key? key, required this.pdfUrl}) : super(key: key);  @override  _BookFlipReaderState createState() => _BookFlipReaderState();}class _BookFlipReaderState extends State<BookFlipReader> {  final _pageFlipController = GlobalKey<PageFlipWidgetState>();  int _totalPages = 0;  int _currentPage = 0;  int _indicatorPage = 0;  int initTotalPage=0;  @override  void initState() {    super.initState();  }  /// Builds a single PDF page widget.  Widget _buildPDFPage(int pageIndex) {    return Container(      color: Colors.white,      child: PDF(        autoSpacing: false,        pageFling: false,        swipeHorizontal: true,        defaultPage: pageIndex,        fitPolicy: FitPolicy.BOTH,        onPageChanged: (currentPage, totalPages) {          setState(() {            //_currentPage = currentPage!;            /*if(currentPage==0){              _currentPage=currentPage!;            }*/            _totalPages = totalPages!;            print("TotalPage>>>"+_totalPages.toString());          });        },      ).cachedFromUrl(        whenDone: (String done){          print("Done");        },        "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",       // "http://www.pdf995.com/samples/pdf.pdf",        placeholder: (progress) => Center(child: Text('$progress% Loading...')),        errorWidget: (error) => Center(child: Text('Error: $error')),      ),    );  }  @override  Widget build(BuildContext context) {    return Column(      children: [        Flexible(child: initTotalPage!=0?PageFlipWidget(          key: _pageFlipController,          children: List.generate(            _totalPages,                (pageIndex) => _buildPDFPage(pageIndex),          ),        ):Center(          child: CircularProgressIndicator(),        )),      ],    );  }}