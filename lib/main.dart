import 'package:book_flip_pdf/app_controller.dart';
import 'package:book_flip_pdf/test_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      locale: Locale('en', 'US'), // translations will be displayed in that locale
      home: MyHomePage(title: ""), // specify the fallback locale in case an invalid locale is selected.
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppController appController=Get.put(AppController());

  @override
  void initState() {
    appController.totalPage.value=0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(title: Text("Book Flip Reader"),),
        body: Obx(()=>controller.totalPage.value!=0?BookFlipReader(pdfUrl: ""):PDF(
          autoSpacing: false,
          pageFling: false,
          swipeHorizontal: true,
          fitPolicy: FitPolicy.BOTH,

          onPageChanged: (currentPage, totalPages) {
            setState(() {

              controller.totalPage.value= totalPages!;
            });
          },
        ).cachedFromUrl(
          whenDone: (String done){
            print("Done");
          },
          "https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf",
          // "http://www.pdf995.com/samples/pdf.pdf",
          placeholder: (progress) => Center(child: Text('$progress% Loading...')),
          errorWidget: (error) => Center(child: Text('Error: $error')),
        )),
      );
    });
  }
}
