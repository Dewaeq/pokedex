import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/info/components/abilitiesWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/info/components/speciesWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/info/components/statWidget.dart';

class InfoWidget extends StatelessWidget {
  final Pokemon pokemon;
  InfoWidget({@required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DetailItem(title: 'Species', child: SpeciesWidget(pokemon: pokemon)),
          DetailItem(
              title: 'Abilities', child: AbilitiesWidget(pokemon: pokemon)),
          DetailItem(title: 'Base Stats', child: StatWidget(pokemon: pokemon)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
