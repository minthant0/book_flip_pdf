import 'package:book_flip_pdf/app_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';


class AppBinding implements Bindings {
  @override
  Future<void> dependencies() async {

    Get.put(
      AppController(),
    );

  }
}
