import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';

class SpeciesWidget extends StatelessWidget {
  final Pokemon pokemon;
  SpeciesWidget({@required this.pokemon});

  Widget item(Widget child, String description) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(13),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(.4)),
          ),
          child: child,
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: item(
                Text(
                  pokemon.species.description,
                  textAlign: TextAlign.center,
                ),
                'Pokédex description (from Pokémon Sword)'),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: item(
                  Text(
                    '${pokemon.height / 10} m',
                    textAlign: TextAlign.center,
                  ),
                  'Height',
                ),
              ),
              SizedBox(width: 25),
              Expanded(
                child: item(
                  Text(
                    '${pokemon.weight / 10} kg',
                    textAlign: TextAlign.center,
                  ),
                  'Weight',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
