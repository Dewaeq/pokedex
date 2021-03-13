import 'package:flutter/material.dart';
import 'package:pokedex/customIcons/pokedexIcons.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/itemWithDescription.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/more/components/breedingWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/more/components/trainingWidget.dart';
import 'package:pokedex/utils/color_theme.dart';
import 'package:pokedex/utils/helper.dart';

class MoreWidget extends StatelessWidget {
  final Pokemon pokemon;
  MoreWidget({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            TrainingWidget(pokemon: pokemon),
            SizedBox(height: 20),
            BreedingWidget(pokemon: pokemon),
          ],
        ),
      ),
    );
  }
}
