import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';

class SpeciesWidget extends StatelessWidget {
  final Pokemon pokemon;
  SpeciesWidget({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
    Widget item(Widget child) {
      return Container(
        padding: EdgeInsets.all(13),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(.4)),
        ),
        child: child,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          item(Text(pokemon.species.description)),
          SizedBox(height: 15),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(.4)),
                  ),
                  child: Text('Height: ${pokemon.height / 10} m'),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(.4)),
                  ),
                  child: Text('Weight: ${pokemon.weight / 10} kg'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
