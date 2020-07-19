import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusecash/generated/i18n.dart';
import 'package:fusecash/models/app_state.dart';
import 'package:fusecash/models/views/bottom_bar.dart';

class BottomBar extends StatelessWidget {
  final int tabIndex;
  final void Function(int) onTap;
  const BottomBar({Key key, this.tabIndex = 0, this.onTap}) : super(key: key);

  BottomNavigationBarItem bottomBarItem(String title, String imgSvg) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 3),
          child: SvgPicture.asset('assets/images/$imgSvg\.svg'),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 3),
          child: SvgPicture.asset('assets/images/$imgSvg\_selected.svg'),
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: new Text(title,
              style: new TextStyle(
                  fontSize: 13.0, color: const Color(0xFF292929))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, BottomBarViewModel>(
        distinct: true,
        converter: BottomBarViewModel.fromStore,
        builder: (_, vm) {
          return BottomNavigationBar(
            selectedFontSize: 13,
            unselectedFontSize: 13,
            type: BottomNavigationBarType.fixed,
            currentIndex: tabIndex,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            showUnselectedLabels: true,
            items: [
              bottomBarItem(I18n.of(context).home, 'home'),
              bottomBarItem(I18n.of(context).send_button, 'send'),
              vm.isDefaultCommunity
                  ? bottomBarItem(
                      I18n.of(context).fuse_volts, 'fuse_points_tab')
                  : bottomBarItem(I18n.of(context).buy, 'buy'),
              bottomBarItem(I18n.of(context).receive, 'receive'),
            ],
            onTap: onTap,
          );
        });
  }
}
