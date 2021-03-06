import 'package:auto_app/features/favourite/favorite.dart';
import 'package:auto_app/features/search/search.dart';
import 'package:auto_app/features/settings/settings.dart';
import 'package:core_ui/src/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navbarsItems(),
      confineInSafeArea: true,
      backgroundColor: provider.isDarkMode ? Colors.black : Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      navBarStyle: NavBarStyle.style9,
    );
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
