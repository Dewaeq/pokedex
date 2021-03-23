import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/bottomNavbar.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/headerWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/evolutions/evolutionWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/info/infoWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/menu/MenuWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/more/moreWidget.dart';
import 'package:pokedex/utils/colorTheme.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;
  PokemonDetailsPage({@required this.pokemon});
  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState(pokemon);
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  final Pokemon pokemon;
  _PokemonDetailsPageState(this.pokemon);

  final PageController controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: setPrimaryColor(pokemon.types[0]),
      bottomNavigationBar: BottomNavbar(
        index: index,
        backgroundColor: setPrimaryColor(pokemon.types.first),
        key: UniqueKey(),
        onPressed: (value) {
          controller.animateToPage(
            value,
            duration: Duration(milliseconds: 300),
            curve: Curves.linearToEaseOut,
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(pokemon: pokemon),
            Expanded(
              child: PageView(
                onPageChanged: (value) => setState(() => index = value),
                controller: controller,
                children: [
                  InfoWidget(pokemon: pokemon),
                  EvolutionWidget(pokemon: pokemon),
                  MoreWidget(pokemon: pokemon),
                  MenuWidget(pokemon: pokemon),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
