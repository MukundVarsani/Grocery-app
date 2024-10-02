import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/User_Order/user_order_page.dart';
import 'package:myshop/pages/OrderPage/my_order.dart';
import 'package:myshop/pages/allItemPage/all_items.dart';
import 'package:myshop/pages/homePage/home_page.dart';
import 'package:myshop/pages/myCartPage/my_cart_screen.dart';
import 'package:myshop/pages/profilePage/profile.dart';
import 'package:myshop/utils/colors.dart';

class UserNavigationBar extends StatefulWidget {
  final int index;
  const UserNavigationBar({super.key, this.index = 0});

  @override
  State<UserNavigationBar> createState() => _UserNavigationBarState();
}

class _UserNavigationBarState extends State<UserNavigationBar> {
  late int _selectedIndex;

  static final List<Widget> _widgetOptions = <Widget>[
    const Homepage(),
    const AllItemsPage(),
    const MyCartScreen(),
    MyOrder(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: iconBorder(Icons.home, 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.menu, 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.shopping_cart, 2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.money, 3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.person, 4),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: AppColors.greyColor,
        selectedItemColor: AppColors.whiteColor,
        elevation: 2.0,
        useLegacyColorScheme: true,
        onTap: _onItemTapped,
        showSelectedLabels: false, // Hide selected labels
        showUnselectedLabels: false,
      ),
    );
  }

  Widget iconBorder(IconData icon, int index) {
    return Container(
        height: 48,
        width: 48,
        decoration: _selectedIndex == index
            ? BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(50))
            : null,
        child: Icon(
          icon,
          size: _selectedIndex == index ? 30 : null,
        ));
  }
}
