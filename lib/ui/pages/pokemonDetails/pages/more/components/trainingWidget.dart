import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/itemWithDescription.dart';
import 'package:pokedex/utils/color_theme.dart';
import 'package:pokedex/utils/helper.dart';

class TrainingWidget extends StatelessWidget {
  final Pokemon pokemon;
  TrainingWidget({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return DetailItem(
      title: 'Training',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            ItemWithDescription(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: pokemon.species.captureRate == 0
                          ? 'Unknown'
                          : '${pokemon.species.captureRate}',
                      style: TextStyle(
                        color: setPrimaryColor(pokemon.types.first),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: '  (5.9% - Pokéball - Full HP)',
                    )
                  ],
                ),
              ),
              description: 'Catch Rate',
            ),
            SizedBox(height: 15),
            ItemWithDescription(
              child: Text(
                pokemon.species.growthRate == null
                    ? 'Unknown'
                    : Helper.getDisplayName(pokemon.species.growthRate),
                style: TextStyle(
                  color: setPrimaryColor(pokemon.types.first),
                  fontWeight: FontWeight.w600,
                ),
              ),
              description: 'Growth Rate',
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ItemWithDescription(
                    child: Text(
                      pokemon.species.baseHappiness == 0
                          ? 'Unknown'
                          : '${pokemon.species.baseHappiness}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: setPrimaryColor(pokemon.types.first),
                      ),
                    ),
                    description: 'Base Happiness',
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                  child: ItemWithDescription(
                    child: Text(
                      '${pokemon.species.baseExperience ?? 'Unknown'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: setPrimaryColor(pokemon.types.first),
                      ),
                    ),
                    description: 'Base Experience',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
