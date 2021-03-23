import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/model/DefaultAbility.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemonCard.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class AbilityDetails extends StatelessWidget {
  final Pokemon pokemon;
  final DefaultAbility ability;
  final Color backGroundColor;
  AbilityDetails(
      {@required this.pokemon,
      @required this.ability,
      @required this.backGroundColor});

  Widget _detailItem(String title, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            text.replaceAll('  ', ' '),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey[900],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (!state.gotData) return CircularProgressIndicator();

    final pokemonWithThisAbility = Helper.sortPokemon(
        state.pokemons.where((e) => ability.pokemon.contains(e.name)).toList());

    return Container(
      height: size.height * 0.85,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 100,
            floating: true,
            backgroundColor: backGroundColor,
            title: Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Helper.getDisplayName(ability.name),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  pokemon == null
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            Helper.getDisplayName("${pokemon.name}'s ability"),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _detailItem('GAME DESCRIPTION',
                    ability.description ?? 'Description not available'),
                _detailItem(
                    'EFFECT',
                    ability.shortEffectDescription ??
                        'Description not available'),
                _detailItem('IN-DEPTH EFFECT',
                    ability.effectDescription ?? 'Description not available'),
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
                              'POKEMON WITH THIS ABILITY',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                            SizedBox(height: 10),
                          ] +
                          (ability.pokemon.isEmpty
                              ? [Text('There are no pokémon with this ability')]
                              : pokemonWithThisAbility.map((p) {
                                  return Container(
                                    height: 130,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 8),
                                    child: PokemonCard(
                                      cardType: 1,
                                      pokemon: p,
                                      onPressed: () =>
                                          navigatorKey.currentState.push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PokemonDetailsPage(pokemon: p),
                                        ),
                                      ),
                                      onLongPressed: () =>
                                          Helper.showShortPokemonDetails(p),
                                    ),
                                  );
                                }).toList())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
