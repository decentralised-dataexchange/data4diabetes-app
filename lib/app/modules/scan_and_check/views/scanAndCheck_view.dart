import 'package:Data4Diabetes/app/modules/scan_and_check/controllers/scanAndCheck_controller.dart';
import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import 'package:flutter/services.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class ScanAndCheckView extends BaseView<ScanAndCheckController> {
  static const double containerHeight = 350.0;
  static const double sizedBoxheight = 50.0;
  static const double sizedBoxwidth = 50.0;
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Food: Scan and Check',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _mobileScanner(context),
            _carboHydrateValue(),
            _glycemicIndexValue(),
            _insulinUnitValue(),
            _confirmRejectWidget(),
          ],
        ),
      ),
    );
  }

  Widget _mobileScanner(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: MobileScanner(
          fit: BoxFit.cover,
          controller: MobileScannerController(
            // facing: CameraFacing.back,
            // torchEnabled: false,
            returnImage: true,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
            if (image != null) {
              showDialog(
                context: context,
                builder: (context) => Image(image: MemoryImage(image)),
              );
              Future.delayed(const Duration(seconds: 5), () {
                Navigator.pop(context);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _carboHydrateValue() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Carbohydrates:'),
            SizedBox(
              width: 13,
            ),
            Text(
              '80',
              style: TextStyle(color: Colors.green),
            )
          ],
        ),
      ),
    );
  }

  Widget _glycemicIndexValue() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Glycemic index:'),
            SizedBox(
              width: 10,
            ),
            Text(
              '94',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
      ),
    );
  }

  Widget _insulinUnitValue() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Recommended insulin units:',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '8',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _confirmRejectWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (){return;},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: sizedBoxheight,
                    width: sizedBoxwidth,
                    child: Image.asset(
                      'images/confirm.png',
                      fit: BoxFit.cover,
                      color: Colors.green,
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text('Confirm'),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              return;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: sizedBoxheight,
                    width: sizedBoxwidth,
                    child: Image.asset(
                      'images/reject.png',
                      fit: BoxFit.cover,
                      color: Colors.red,
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Text('Reject and change'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
