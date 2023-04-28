import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ResponsiveValue on num {
  double get w => ScreenUtil().setWidth(this.toDouble());

  double get h => ScreenUtil().setHeight(this.toDouble());

  double get f => ScreenUtil().setSp(this.toDouble());
}
