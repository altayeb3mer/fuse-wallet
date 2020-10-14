import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:bit2c/models/app_state.dart';
import 'package:bit2c/models/views/splash.dart';
import 'package:bit2c/screens/splash/create_wallet.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashViewModel>(
        onInitialBuild: (viewModel) {
          Segment.screen(screenName: '/splash-screen');
        },
        distinct: true,
        converter: SplashViewModel.fromStore,
        builder: (_, viewModel) {
          List pages = [CreateWallet()];
          return WillPopScope(
              onWillPop: () async {
                ExtendedNavigator.root.pop<bool>(false);
                return false;
              },
              child: Scaffold(
                  body: Container(
                      child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 20,
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              PageView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: pages.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        pages[index % pages.length],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              ))));
        });
  }
}
