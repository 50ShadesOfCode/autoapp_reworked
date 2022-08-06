import 'package:auto_app/features/favourite/favorite.dart';
import 'package:auto_app/features/search/search.dart';
import 'package:auto_app/features/settings/settings.dart';
import 'package:core_ui/src/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
      final ThemeProvider provider = Provider.of<ThemeProvider>(context);
      return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navbarsItems(),
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        navBarStyle: NavBarStyle.style1,
      );
    });
  }
}

List<Widget> _buildScreens() {
  return <Widget>[
    Favorite(),
    Search(),
    Settings(),
  ];
}

List<PersistentBottomNavBarItem> _navbarsItems() {
  return <PersistentBottomNavBarItem>[
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.bookmark),
      title: 'Избранное',
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.search),
      title: 'Поиск',
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.settings_solid),
      title: 'Настройки',
      activeColorPrimary: CupertinoColors.activeBlue,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];
}
