import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/more/components/breedingWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/more/components/groupingWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/more/components/trainingWidget.dart';

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
            SizedBox(height: 20),
            GroupingWidget(pokemon: pokemon),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
