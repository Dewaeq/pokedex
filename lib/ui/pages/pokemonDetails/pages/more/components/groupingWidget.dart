import 'package:flutter/material.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/itemWithDescription.dart';
import 'package:pokedex/utils/colorTheme.dart';
import 'package:pokedex/utils/helper.dart';

class GroupingWidget extends StatelessWidget {
  final Pokemon pokemon;
  GroupingWidget({@required this.pokemon});
  @override
  Widget build(BuildContext context) {
    return DetailItem(
      title: 'Groups',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            ItemWithDescription(
              child: Text(
                Helper.getDisplayName(pokemon.species.region ?? 'Unknown'),
                style: TextStyle(
                  color: setPrimaryColor(pokemon.types.first),
                  fontWeight: FontWeight.w600,
                ),
              ),
              description: 'Region',
            ),
            SizedBox(height: 15),
            ItemWithDescription(
              child: Text(
                Helper.getGenerationName(GENERATIONS.firstWhere(
                    (e) => e['id'] == pokemon.species.generationId)['name']),
                style: TextStyle(
                  color: setPrimaryColor(pokemon.types.first),
                  fontWeight: FontWeight.w600,
                ),
              ),
              description: 'Generation',
            ),
          ],
        ),
      ),
    );
  }
}
