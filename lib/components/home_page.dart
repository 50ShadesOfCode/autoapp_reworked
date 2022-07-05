import 'package:auto_app/components/favorite.dart';
import 'package:auto_app/components/search.dart';
import 'package:auto_app/components/settings.dart';
import 'package:auto_app/components/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

//HomePage просто каркас приложения, в котором уже рендерятся все страницы. В себе содержит только нижнюю панель навигации.
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //контроллер для отслеживания состояния нижней панели
  PersistentTabController _controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider provider = Provider.of<ThemeProvider>(context);
    //сама панель с заданными параметрами и темой
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

//список экранов для нижней панели
List<Widget> _buildScreens() {
  return <Widget>[
    Favorite(),
    Search(),
    Settings(),
  ];
}

//элементы панели навигации: настройки, поиск и избранное.
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
