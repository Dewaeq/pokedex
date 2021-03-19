import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ItemWithDescription extends StatelessWidget {
  final Widget child;
  final String description;
  Color backgroundColor;
  bool padding;
  ItemWithDescription({
    @required this.child,
    @required this.description,
    this.backgroundColor,
    this.padding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: !padding
              ? null
              : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: backgroundColor ?? Colors.grey.withOpacity(.25),
            ),
            color: backgroundColor,
          ),
          child: child,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(.7),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
