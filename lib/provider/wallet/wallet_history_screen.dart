import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/background_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/wallet_history_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/wallet/components/wallet_widget.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletHistoryScreen extends StatefulWidget {
  @override
  WalletHistoryScreenState createState() => WalletHistoryScreenState();
}

class WalletHistoryScreenState extends State<WalletHistoryScreen> {
  List<WalletHistory> walletHistoryList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  bool hasError = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  init() async {
    appStore.setLoading(true);
    await getWalletHistory(currentPage).then((value) {
      appStore.setLoading(false);
      hasError = false;
      totalItems = value.pagination!.totalItems!;

      if (currentPage == 1) {
        walletHistoryList.clear();
      }
      if (totalItems >= 1) {
        walletHistoryList.addAll(value.data!);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context.translate.lblWalletHistory, backWidget: BackWidget(), elevation: 0, color: primaryColor, textColor: Colors.white),
      body: Stack(
        children: [
          if (walletHistoryList.isNotEmpty)
            AnimatedListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
              padding: EdgeInsets.all(8),
              itemCount: walletHistoryList.length,
              itemBuilder: (_, i) => WalletWidget(walletHistoryList[i]),
              onNextPage: () {
                if (currentPage <= totalPage) {
                  currentPage++;
                  init();
                }
              },
            ),
          Observer(builder: (_) => BackgroundComponent().center().visible(!appStore.isLoading && walletHistoryList.isEmpty && !hasError)),
          Text(errorSomethingWentWrong, style: secondaryTextStyle()).center().visible(hasError),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
