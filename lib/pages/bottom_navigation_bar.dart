import 'package:flutter/material.dart';
import 'package:myshop/pages/allItemPage/all_items.dart';
import 'package:myshop/pages/homePage/home_page.dart';
import 'package:myshop/pages/myCartPage/my_cart_screen.dart';
import 'package:myshop/pages/profilePage/profile.dart';
import 'package:myshop/utils/colors.dart';

class BottomNavigationBare extends StatefulWidget {
  const BottomNavigationBare({super.key});

  @override
  State<BottomNavigationBare> createState() => _BottomNavigationBareState();
}

class _BottomNavigationBareState extends State<BottomNavigationBare> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    AllItemsPage(),
    MyCartScreen(),
    ProfileScreen(),
    // Text('Profile Page',
    //     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

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
            icon:iconBorder(Icons.menu, 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.shopping_cart, 2),
            label: '',
          ),
          //  BottomNavigationBarItem(
          //   icon: iconBorder(Icons.notification_add, 3),
          //   label: '',
          // ),
           BottomNavigationBarItem(
            icon: iconBorder(Icons.person, 3),
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
        decoration: _selectedIndex==index?   BoxDecoration(
            color: AppColors.themeColor,
            borderRadius: BorderRadius.circular(50)): null,
        child:  Icon(
          icon,
          size: _selectedIndex == index? 30 : null,
        ));
  }
}
