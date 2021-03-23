import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemonCard.dart';
import 'package:pokedex/utils/colorTheme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatelessWidget {
  final Pokemon pokemon;
  MenuWidget({@required this.pokemon});

  Widget _pokemonCard(
      BuildContext context, Size size, bool previousPokemon, Pokemon p) {
    if (p == null) return Container();

    return Column(
      children: [
        Row(
          mainAxisAlignment:
              previousPokemon ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            previousPokemon
                ? Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.arrow_back,
                      color: setPrimaryColor(p.types.first),
                    ),
                  )
                : Container(),
            Text(
              previousPokemon ? 'Previous Pokémon' : 'Next Pokémon',
              style: TextStyle(
                color: setPrimaryColor(p.types.first),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            previousPokemon
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Icon(
                      Icons.arrow_forward,
                      color: setPrimaryColor(p.types.first),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: PokemonCard(
            cardType: 1,
            pokemon: p,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PokemonDetailsPage(pokemon: p)),
            ),
            onLongPressed: () =>
                Helper.showShortPokemonDetails(context, pokemon),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (!state.gotData) return CircularProgressIndicator();

    final previousIndex = state.pokemons.indexOf(pokemon) - 1;
    final nextIndex = previousIndex + 2;

    final nextPokemon = nextIndex == -1 || nextIndex >= state.pokemons.length
        ? null
        : state.pokemons[nextIndex];

    final previousPokemon =
        previousIndex < 0 ? null : state.pokemons[previousIndex];

    return Container(
      width: double.infinity,
      child: DetailItem(
        title: 'Menu',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              MaterialButton(
                onPressed: () {},
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(.25),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'HOME',
                        style: TextStyle(
                          color: setPrimaryColor(pokemon.types.first),
                          fontSize: 16,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Icon(
                          Icons.home,
                          color: setPrimaryColor(pokemon.types.first),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _pokemonCard(context, size, false, nextPokemon),
              SizedBox(height: 15),
              _pokemonCard(context, size, true, previousPokemon),
              SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}
