import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NewUpdateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.width() - 16,
          constraints: BoxConstraints(maxHeight: context.height() * 0.6),
          child: AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              60.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.translate.lblNewUpdate, style: boldTextStyle(size: 20)),
                  Text(isAndroid ? remoteConfigDataModel.android!.versionName.validate() : remoteConfigDataModel.iOS!.versionName.validate(), style: boldTextStyle()),
                ],
              ),
              8.height,
              ////TODO: Translate the String in Next Update
              Text('An Update to $APP_NAME is available. Would you like to update?', style: secondaryTextStyle(size: 12), textAlign: TextAlign.left),
              24.height,
              UL(
                children: remoteConfigDataModel.changeLogs!.map((e) {
                  return Text(e.validate(), style: primaryTextStyle(size: 14));
                }).toList(),
              ),
              24.height,
              Row(
                children: [
                  AppButton(
                    child: Text(context.translate.lblCancel, style: boldTextStyle(color: primaryColor)),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: primaryColor)),
                    elevation: 0,
                    onTap: () async {
                      if (remoteConfigDataModel.isForceUpdate!) {
                        exit(0);
                      } else {
                        finish(context);
                      }
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(context.translate.lblUpdate, style: boldTextStyle(color: white)),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      getPackageName().then((value) {
                        String package = '';
                        if (isAndroid) package = value;

                        commonLaunchUrl(
                          '${isAndroid ? getSocialMediaLink(LinkProvider.PLAY_STORE) : getSocialMediaLink(LinkProvider.APPSTORE)}$package',
                          launchMode: LaunchMode.externalApplication,
                        );

                        if (remoteConfigDataModel.isForceUpdate!) {
                          exit(0);
                        } else {
                          finish(context);
                        }
                      });
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),
        Positioned(
          top: -42,
          child: Image.asset(imgForceUpdate, height: 100, width: 100, fit: BoxFit.cover),
        ),
      ],
    );
  }
}
