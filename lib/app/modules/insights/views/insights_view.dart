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
  static const double percentageValueWidth = 48;
  static const double percentageColorContainerSize = 10;

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
            items: [
              DropdownMenuItem<String>(
                value: 'TODAY',
                child: Text(appLocalization.insightsToday, style: cardSmallTagStyle,
                  overflow: TextOverflow.ellipsis,),
              ),
              DropdownMenuItem<String>(
                value: 'LAST 7 DAYS',
                child: Text(appLocalization.insightsLast7Days, style: cardSmallTagStyle,
                  overflow: TextOverflow.ellipsis,),
              ),
              DropdownMenuItem<String>(
                value: 'LAST 30 DAYS',
                child: Text(appLocalization.insightsLast30Days, style: cardSmallTagStyle,
                  overflow: TextOverflow.ellipsis,),
              ),
            ],
            value: _insightsController.selectedValue.value,
            onChanged: (value) {
              _insightsController.selectedValue.value = value as String;
              _insightsController
                  .gMICalculator(_insightsController.selectedValue.value);
              _insightsController
                  .tIRCalculator(_insightsController.selectedValue.value);
              _insightsController
                  .addChartDataValues(_insightsController.selectedValue.value);
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
             Padding(
              padding:const EdgeInsets.all(8.0),
              child: Text(
               appLocalization.insightsGlucoseTIR,
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
      padding: const EdgeInsets.fromLTRB(6, 0, 4, 16),
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
      children:  [
        Text(
         appLocalization.insightsVeryHighRange,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          appLocalization.insightsHighRange,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          appLocalization.insightsTargetRange,
          style:const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          appLocalization.insightsLowRange,
          style:const TextStyle(fontSize: 15),
        ),
       const SizedBox(
          height: 25,
        ),
        Text(
         appLocalization.insightsVeryLow,
          style:const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  Widget _stackedColumnRange() {
    return Obx(
      () => SizedBox(
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
                dataSource: _insightsController.chartData.value,
                color: const Color(0xFF851a10),
                xValueMapper: (ChartData ch, _) => ch.x,
                yValueMapper: (ChartData ch, _) => ch.veryLow.value),
            StackedColumnSeries(
                dataSource: _insightsController.chartData.value,
                color: const Color(0xFFce3813),
                xValueMapper: (ChartData ch, _) => ch.x,
                yValueMapper: (ChartData ch, _) => ch.low.value),
            StackedColumnSeries(
                dataSource: _insightsController.chartData.value,
                color: const Color(0xFF30bc5c),
                xValueMapper: (ChartData ch, _) => ch.x,
                yValueMapper: (ChartData ch, _) => ch.targetRange.value),
            StackedColumnSeries(
                dataSource: _insightsController.chartData.value,
                color: const Color(0xFFfdc333),
                xValueMapper: (ChartData ch, _) => ch.x,
                yValueMapper: (ChartData ch, _) => ch.high.value),
            StackedColumnSeries(
                dataSource: _insightsController.chartData.value,
                color: const Color(0xFFfb9531),
                xValueMapper: (ChartData ch, _) => ch.x,
                yValueMapper: (ChartData ch, _) => ch.veryHigh.value),
          ],
        ),
      ),
    );
  }

  _percentageValue1() {
    return Obx(
      () => SizedBox(
        width: percentageValueWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: percentageColorContainerSize,
              width: percentageColorContainerSize,
              color: const Color(0xFFfb9531),
            ),
            Text('${_insightsController.veryHigh.value} %'),
          ],
        ),
      ),
    );
  }

  _percentageValue2() {
    return Obx(
      () => SizedBox(
        width: percentageValueWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: percentageColorContainerSize,
              width: percentageColorContainerSize,
              color: const Color(0xFFfdc333),
            ),
            Text('${_insightsController.high.value} %'),
          ],
        ),
      ),
    );
  }

  _percentageValue3() {
    return Obx(
      () => SizedBox(
        width: percentageValueWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: percentageColorContainerSize,
              width: percentageColorContainerSize,
              color: const Color(0xFF30bc5c),
            ),
            Text('${_insightsController.targetRange.value} %'),
          ],
        ),
      ),
    );
  }

  _percentageValue4() {
    return Obx(
      () => SizedBox(
        width: percentageValueWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: percentageColorContainerSize,
              width: percentageColorContainerSize,
              color: const Color(0xFFce3813),
            ),
            Text('${_insightsController.low.value} %'),
          ],
        ),
      ),
    );
  }

  _percentageValue5() {
    return Obx(
      () => SizedBox(
        width: percentageValueWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: percentageColorContainerSize,
              width: percentageColorContainerSize,
              color: const Color(0xFF851a10),
            ),
            Text('${_insightsController.veryLow.value} %'),
          ],
        ),
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
             Padding(
              padding:const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: Text(
                appLocalization.insightsSummary,
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
      padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 12.0),
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
    return Obx(
      () => GridTile(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${appLocalization.insightsGMI} ${_insightsController.gMIpercentage.value.toStringAsFixed(1)}%')),
          ),
        ),
      ),
    );
  }

  _tileGMIValue() {
    return Obx(
      () => GridTile(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${_insightsController.gMIpercentage.value.toStringAsFixed(1)}%')),
          ),
        ),
      ),
    );
  }

  _tileAverage() {
    return Obx(
      () => GridTile(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${appLocalization.insightsAvgValue} ${_insightsController.averageValue.value.toStringAsFixed(1)}')),
          ),
        ),
      ),
    );
  }

  _tileAverageValue() {
    return Obx(
      () => GridTile(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    _insightsController.averageValue.value.toStringAsFixed(1))),
          ),
        ),
      ),
    );
  }

  _tileCGM() {
    return GridTile(
        child: Container(
            color: Colors.white,
            child:  Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalization.insightsActiveCGM)),
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
