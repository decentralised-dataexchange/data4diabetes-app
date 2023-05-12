import 'package:Data4Diabetes/app/core/values/app_colors.dart';
import 'package:Data4Diabetes/app/core/values/text_styles.dart';
import 'package:Data4Diabetes/app/core/widget/app_bar_with_logo.dart';
import 'package:Data4Diabetes/app/modules/insights/controllers/insights_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsView extends BaseView<InsightsController> {
  static const double toolbarHeight = 80;
  static const double stackedChartWidth = 60;
  static const double circleContainerWidth = 50;
  static const double cardRadius = 20;
  static const double circleContainerHeight = 50;
  static const double buttonStyleHeight = 50;
  static const double buttonStyleRadius = 10;
  static const double dropdownStyleRadius = 14;
  static const double percentageContainerHeight = 250;
  static const double percentageValueWidth = 40;
  static const double percentageColorContainerSize = 10;

  final List<ChartData> chartData = [ChartData('', 14, 50, 15, 5, 8)];
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBarWithLogo(
      title: controller.appLocalization.homeYourVirtualPancreas,
    );
  }

  final InsightsController _insightsController = Get.find();
  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _dropdownWidget(context),
            _gloucoseTimeInRange(context),
            _summaryWidget(),
          ],
        ),
      ),
    );
  }

  Widget _dropdownWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            items: _insightsController.items
                .map<DropdownMenuItem<String>>(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            value: _insightsController.selectedValue.value,
            onChanged: (value) {
              _insightsController.selectedValue.value = value as String;
            },
            buttonStyleData: buttonStyle(context),
            iconStyleData: iconStyle(),
            dropdownStyleData: dropdownStyle(context),
            menuItemStyleData: menuItemStyle(),
          ),
        ),
      ),
    );
  }

  buttonStyle(BuildContext context) {
    return ButtonStyleData(
      height: buttonStyleHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 14, right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonStyleRadius),
        border: Border.all(
          color: Colors.black26,
        ),
        color: AppColors.pageBackground,
      ),
      elevation: 0,
    );
  }

  iconStyle() {
    return const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 25,
        iconEnabledColor: Colors.black45,
        iconDisabledColor: Colors.black);
  }

  dropdownStyle(BuildContext context) {
    return DropdownStyleData(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dropdownStyleRadius),
        color: AppColors.pageBackground,
      ),
      elevation: 2,
      offset: const Offset(0, 0),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(40),
        thickness: MaterialStateProperty.all<double>(6),
        thumbVisibility: MaterialStateProperty.all<bool>(true),
      ),
    );
  }

  menuItemStyle() {
    return const MenuItemStyleData(
      height: 40,
      padding: EdgeInsets.only(left: 14, right: 14),
    );
  }
  //
  // Widget _gloucoseTimeInRange() {
  //   return SizedBox(
  //     width: toolbarHeight,
  //
  //     child: SfCartesianChart(
  //
  //       plotAreaBorderWidth: 0,
  //
  //       primaryXAxis: CategoryAxis(
  //         //Hide the gridlines of x-axis
  //         majorGridLines: const MajorGridLines(width: 0),
  //
  //         //Hide the axis line of x-axis
  //         axisLine: const AxisLine(width: 0),
  //       ),
  //
  //       primaryYAxis: CategoryAxis(
  //         //Hide the gridlines of y-axis
  //           majorGridLines: const MajorGridLines(width: 0),
  //
  //           //Hide the axis line of y-axis
  //         axisLine: const AxisLine(width: 0)
  //       ),
  //
  //       series: [
  //         StackedColumnSeries(
  //           dataLabelSettings: const DataLabelSettings(isVisible: true,labelAlignment: ChartDataLabelAlignment.middle,textStyle: TextStyle(color: Colors.white)),
  //
  //             dataSource: chartData,
  //             xValueMapper: (ChartData ch, _) => ch.x,
  //             yValueMapper: (ChartData ch, _) => ch.y1),
  //         StackedColumnSeries(
  //             dataLabelSettings:const DataLabelSettings(isVisible: true,labelAlignment: ChartDataLabelAlignment.middle,textStyle: TextStyle(color: Colors.white)),
  //             dataSource: chartData,
  //             xValueMapper: (ChartData ch, _) => ch.x,
  //             yValueMapper: (ChartData ch, _) => ch.y2),
  //         StackedColumnSeries(
  //             dataLabelSettings:const DataLabelSettings(isVisible: true,labelAlignment: ChartDataLabelAlignment.middle,textStyle: TextStyle(color: Colors.white)),
  //             dataSource: chartData,
  //             xValueMapper: (ChartData ch, _) => ch.x,
  //             yValueMapper: (ChartData ch, _) => ch.y3),
  //         StackedColumnSeries(
  //             dataLabelSettings: const DataLabelSettings(isVisible: true,labelAlignment: ChartDataLabelAlignment.middle,textStyle: TextStyle(color: Colors.white)),
  //             dataSource: chartData,
  //             xValueMapper: (ChartData ch, _) => ch.x,
  //             yValueMapper: (ChartData ch, _) => ch.y4),
  //         StackedColumnSeries(
  //             dataLabelSettings: const DataLabelSettings(isVisible: true,labelAlignment: ChartDataLabelAlignment.middle,textStyle: TextStyle(color: Colors.white)),
  //             dataSource: chartData,
  //             xValueMapper: (ChartData ch, _) => ch.x,
  //             yValueMapper: (ChartData ch, _) => ch.y5),
  //
  //
  //
  //       ],
  //     ),
  //   );
  // }

  Widget _gloucoseTimeInRange(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 1,
        color: AppColors.pageBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Glucose - Time in range',
                style: descriptionTextStyle,
              ),
            ),
            Row(
              children: [
                _percentageSection(context),
                _rangeDetailsSection(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _percentageSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 4, 16),
      child: Container(
        height: percentageContainerHeight,
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            _stackedColumnRange(),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 25,
                ),
                _percentageValue1(),
                const SizedBox(
                  height: 25,
                ),
                _percentageValue2(),
                const SizedBox(
                  height: 25,
                ),
                _percentageValue3(),
                const SizedBox(
                  height: 25,
                ),
                _percentageValue4(),
                const SizedBox(
                  height: 25,
                ),
                _percentageValue5(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rangeDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Very high > 13.9 mmol/l',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'High 10.1-13.9 mmol/l',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Target range 3.9 10 mmol/l',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Low 3-3.8 mmol/',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Very low < 3 mmol/l',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget _stackedColumnRange() {
    return SizedBox(
      width: stackedChartWidth,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
          //Hide the gridlines of x-axis
          majorGridLines: const MajorGridLines(width: 0),

          //Hide the axis line of x-axis
          axisLine: const AxisLine(width: 0),
        ),
        primaryYAxis: CategoryAxis(
            //Hide the gridlines of y-axis
            majorGridLines: const MajorGridLines(width: 0),

            //Hide the axis line of y-axis
            axisLine: const AxisLine(width: 0)),
        series: [
          StackedColumnSeries(
              // dataLabelSettings: const DataLabelSettings(
              //     isVisible: true,
              //     labelAlignment: ChartDataLabelAlignment.middle,
              //     textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y1),
          StackedColumnSeries(
              // dataLabelSettings: const DataLabelSettings(
              //     isVisible: true,
              //     labelAlignment: ChartDataLabelAlignment.middle,
              //     textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y2),
          StackedColumnSeries(
              // dataLabelSettings: const DataLabelSettings(
              //     isVisible: true,
              //     labelAlignment: ChartDataLabelAlignment.middle,
              //     textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y3),
          StackedColumnSeries(
              // dataLabelSettings: const DataLabelSettings(
              //     isVisible: true,
              //     labelAlignment: ChartDataLabelAlignment.middle,
              //     textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y4),
          StackedColumnSeries(
              // dataLabelSettings: const DataLabelSettings(
              //     isVisible: true,
              //     labelAlignment: ChartDataLabelAlignment.middle,
              //     textStyle: TextStyle(color: Colors.white)),
              dataSource: chartData,
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y5),
        ],
      ),
    );
  }

  _percentageValue1() {
    return SizedBox(
      width: percentageValueWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: percentageColorContainerSize,
            width: percentageColorContainerSize,
            color:const Color(0XFF74B49A),
          ),
          const Text('3%'),
        ],
      ),
    );
  }

  _percentageValue2() {
    return SizedBox(
      width: percentageValueWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: percentageColorContainerSize,
            width: percentageColorContainerSize,
            color: const Color(0XFFFAB093),
          ),
          const Text('6%'),
        ],
      ),
    );
  }

  _percentageValue3() {
    return SizedBox(
      width: percentageValueWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: percentageColorContainerSize,
            width: percentageColorContainerSize,
            color:  const Color(0XFFF67280),
          ),
          const Text('22%'),
        ],
      ),
    );
  }

  _percentageValue4() {
    return SizedBox(
      width: percentageValueWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: percentageColorContainerSize,
            width: percentageColorContainerSize,
            color: const Color(0XFFC06C84),
          ),
          const Text('38%'),
        ],
      ),
    );
  }

  _percentageValue5() {
    return SizedBox(
      width: percentageValueWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: percentageColorContainerSize,
            width: percentageColorContainerSize,
            color: const Color(0XFF4B87B9),
          ),
          const Text('8%'),
        ],
      ),
    );
  }

  _summaryWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 1,
        color: AppColors.pageBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0,8.0,8.0,0),
              child: Text(
                'Summary',
                style: descriptionTextStyle,
              ),
            ),
            _gridViewSummaryWidget(),
          ],
        ),
      ),
    );
  }

  _gridViewSummaryWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0,5.0,12.0,12.0),
      child: Container(
        decoration: const BoxDecoration(
          //  color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 3,
            shrinkWrap: true,
            children: [
              _tileGMI(),
              _tileGMIValue(),
              _tileAverage(),
              _tileAverageValue(),
              _tileCGM(),
              _tileCGMValue(),
            ],
          ),
        ),
      ),
    );
  }

  _tileGMI() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft, child: Text('GMI 7.3%')),
            )));
  }

  _tileGMIValue() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child:
                  Align(alignment: Alignment.centerLeft, child: Text('7.3%')),
            )));
  }

  _tileAverage() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Average Value 9.3')),
            )));
  }

  _tileAverageValue() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(alignment: Alignment.centerLeft, child: Text('9.3')),
            )));
  }

  _tileCGM() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('% Active time with CGM')),
            )));
  }

  _tileCGMValue() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child: const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('90.8% (27.2 days)')),
            )));
  }
}

class ChartData {
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
  final int y5;
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4, this.y5);
}
