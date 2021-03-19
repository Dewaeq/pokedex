import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final Function onPressed;
  final int index;
  final Color backgroundColor;
  BottomNavbar({
    Key key,
    @required this.onPressed,
    @required this.index,
    @required this.backgroundColor,
  }) : super(key: key);
  @override
  _BottomNavbarState createState() => _BottomNavbarState(
        index: index,
        onPressed: onPressed,
        backGroundColor: backgroundColor,
      );
}

class _BottomNavbarState extends State<BottomNavbar> {
  final Function onPressed;
  final Color backGroundColor;
  int index;
  _BottomNavbarState(
      {@required this.onPressed,
      @required this.index,
      @required this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      /* decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ]), */
      child: BottomNavigationBar(
        onTap: (value) {
          onPressed(value);
          if (value != index) setState(() => index = value);
        },
        currentIndex: index,
        selectedItemColor: Colors.grey[800],
        backgroundColor: backGroundColor,
        showUnselectedLabels: false,
        iconSize: 24,
        selectedLabelStyle: TextStyle(fontSize: 16),
        unselectedIconTheme: IconThemeData(color: Colors.grey[700]),
        selectedIconTheme: IconThemeData(color: Colors.grey[800]),
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
      ),
    );
  }
}
