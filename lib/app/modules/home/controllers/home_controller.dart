import 'package:flutter/services.dart';

import '/app/core/base/base_controller.dart';

class HomeController extends BaseController {
  var platform = const MethodChannel('io.igrant.data4diabetes.channel');
}
