import 'package:flutter/material.dart';
import 'package:pokedex/model/DefaultAbility.dart';
import 'package:pokedex/utils/helper.dart';

class AbilityCard extends StatelessWidget {
  final DefaultAbility ability;

  final Function onPressed;

  AbilityCard({
    @required this.ability,
    @required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        color: Color(0xFFA4B4EE),
        height: 70,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Helper.getDisplayName(ability.name),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              ability.description ?? 'Unkown',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
