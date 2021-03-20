import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String title;
  final Widget child;
  DetailItem({@required this.title, @required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blueGrey[900].withOpacity(.8),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
