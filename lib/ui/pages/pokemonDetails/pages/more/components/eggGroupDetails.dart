import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemonCard.dart';
import 'package:pokedex/utils/colorTheme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class EggGroupDetails extends StatelessWidget {
  final Pokemon pokemon;
  final String eggGroupName;
  EggGroupDetails({@required this.pokemon, @required this.eggGroupName});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (!state.gotData) return CircularProgressIndicator();

    var pokemonInThisGroup = state.pokemons
        .where((e) => e.species.eggGroups.contains(eggGroupName))
        .toList();

    pokemonInThisGroup = Helper.sortPokemon(pokemonInThisGroup);

    return Container(
      height: size.height * 0.85,
      child: CustomScrollView(
        clipBehavior: Clip.none,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 100,
            floating: true,
            title: Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: setPrimaryColor(pokemon.types[0]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    Helper.getDisplayName(eggGroupName),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    Helper.getDisplayName("${pokemon.name}'s egg group"),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(18),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'POKEMON IN THIS EGG GROUP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 10),
                    ]..addAll(pokemonInThisGroup.map((p) {
                        return Container(
                          height: 130,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: PokemonCard(
                            cardType: 1,
                            pokemon: p,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PokemonDetailsPage(pokemon: p),
                              ),
                            ),
                            onLongPressed: () => Helper.showShortPokemonDetails(
                                context, size, p),
                          ),
                        );
                      }).toList()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
