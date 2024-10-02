import 'package:flutter/material.dart';
import 'package:myshop/Admin/Pages/User_Order/all_user_order_page.dart';
import 'package:myshop/Admin/Pages/admin_home_page.dart';
import 'package:myshop/Admin/Pages/see_all_items_page.dart';
import 'package:myshop/utils/colors.dart';

class AdminNavigationBar extends StatefulWidget {
  final int index;
  const AdminNavigationBar({super.key, this.index = 0});

  @override
  State<AdminNavigationBar> createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {
  late int _selectedIndex;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminHomePage(),
    SeeAllItemsPage(),
    AllUserOrderPage(),
    Text("Home 4"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: iconBorder(Icons.home, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.menu, 1),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.shopping_cart, 2),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: iconBorder(Icons.person, 3),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,

        // Make sure this does not interfere with custom label and icon colors
        selectedItemColor: Colors.transparent, // No automatic color changes
        unselectedItemColor: AppColors.greyColor,

        // Ensure selected label turns green
        selectedLabelStyle: TextStyle(
          color: Colors.green, // Green for active label
        ),
        unselectedLabelStyle: TextStyle(
          color: AppColors.greyColor, // Grey for inactive labels
        ),

        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 2.0,
      ),
    );
  }

  // Customize the icon appearance based on the selection state
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
          color: _selectedIndex == index
              ? AppColors.whiteColor
              : AppColors
                  .greyColor, // White when selected, grey when unselected
          size: 30,
        ));
  }
}
