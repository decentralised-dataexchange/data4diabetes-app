import 'package:Data4Diabetes/app/modules/services/controllers/services_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Constants/Palette.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_values.dart';
import '../../../core/widget/app_bar_title.dart';
import '../../../core/widget/elevated_container.dart';
import '/app/core/base/base_view.dart';

class ServicesView extends BaseView<ServicesController> {
  final ServicesController _servicesController = Get.find();
  // Card and avatar sizing
  final double avatarDiameter = 60;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      iconTheme: const IconThemeData(color: AppColors.appBarIconColor),
      title: AppBarTitle(text: appLocalization.settingsServices),
    );
  }

  @override
  Widget body(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _servicesController.getServices();
    });

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Obx(() {
        // if (_servicesController.servicesList.isEmpty) {
        //   return const SizedBox.shrink();
        // }
        if (_servicesController.isLoading.value) {
          return const Center(
            child: ElevatedContainer(
              padding: EdgeInsets.all(AppValues.margin),
              child: CircularProgressIndicator(
                color: AppColors.colorPrimary,
              ),
            ),
          );
        }
        // Show empty message only if list is empty
        if (_servicesController.servicesList.isEmpty) {
          return const Center(
            child: Text(
              "No services available",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: _servicesController.servicesList.length,
          itemBuilder: (context, index) {
            final service = _servicesController.servicesList[index];

            // Avatar first letter
            String avatarLetter = (service.name?.isNotEmpty ?? false)
                ? service.name![0].toUpperCase()
                : "?";

            return Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // center avatar vertically
                  children: [
                    // Left: Avatar
                    // Left: Avatar
                    SizedBox(
                      width: avatarDiameter,
                      child: Center(
                        child: CircleAvatar(
                          radius: avatarDiameter / 2,
                          backgroundColor: Palette.avatarBackGround,
                          backgroundImage: (service.logoUrl != null && service.logoUrl!.isNotEmpty)
                              ? NetworkImage(service.logoUrl!)
                              : null,
                          child: (service.logoUrl == null || service.logoUrl!.isEmpty)
                              ? Text(
                            avatarLetter,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),

                    // SizedBox(
                    //   width: avatarDiameter,
                    //   child: Center(
                    //     child: CircleAvatar(
                    //       radius: avatarDiameter / 2,
                    //       backgroundColor: Palette.avatarBackGround,
                    //       child: Text(
                    //         avatarLetter,
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 24,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(width: 16),
                    // Right: Texts + button
                    Expanded(
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.purpose ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service.purposeDescription ??
                                  "",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Palette.textColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Subscribe',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
