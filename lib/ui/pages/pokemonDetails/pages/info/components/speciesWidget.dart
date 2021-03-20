import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/itemWithDescription.dart';

class SpeciesWidget extends StatelessWidget {
  final Pokemon pokemon;
  SpeciesWidget({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: ItemWithDescription(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    pokemon.species.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey[900].withOpacity(.9),
                    ),
                  ),
                ),
                description: 'Pokédex description (from Pokémon Sword)'),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ItemWithDescription(
                  child: Text(
                    '${pokemon.height / 10} m',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey[900].withOpacity(.9),
                    ),
                  ),
                  description: 'Height',
                ),
              ),
              SizedBox(width: 25),
              Expanded(
                child: ItemWithDescription(
                  child: Text(
                    '${pokemon.weight / 10} kg',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey[900].withOpacity(.9),
                    ),
                  ),
                  description: 'Weight',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
