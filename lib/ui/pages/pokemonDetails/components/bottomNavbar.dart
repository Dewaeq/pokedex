import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final Function onPressed;
  final int index;
  BottomNavbar({Key key, @required this.onPressed, @required this.index})
      : super(key: key);
  @override
  _BottomNavbarState createState() =>
      _BottomNavbarState(index: index, onPressed: onPressed);
}

class _BottomNavbarState extends State<BottomNavbar> {
  final Function onPressed;
  int index;
  _BottomNavbarState({@required this.onPressed, @required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        onPressed(value);
        if (value != index) setState(() => index = value);
      },
      currentIndex: index,
      selectedItemColor: Colors.grey[800],
      showUnselectedLabels: false,
      iconSize: 28,
      selectedLabelStyle: TextStyle(
        fontSize: 16,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey[600],
      ),
      selectedIconTheme: IconThemeData(
        color: Colors.grey[800],
      ),
      items: [
        BottomNavigationBarItem(
          label: 'Information',
          icon: Icon(Icons.info_outline),
        ),
        BottomNavigationBarItem(
          label: 'Evolutions',
          icon: Icon(Icons.next_plan_outlined),
        ),
        BottomNavigationBarItem(
          label: 'More',
          icon: Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}
