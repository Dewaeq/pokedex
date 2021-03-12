import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemon_card.dart';
import 'package:pokedex/utils/color_theme.dart';
import 'package:pokedex/extensions/string_extension.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  int cardType = 1;

  Widget _panelRow(String text1, String text2) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 35, right: 15),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Text(
                text1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )),
          Expanded(
            flex: 2,
            child: Text(
              text2,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showShortPokemonDetails(Size size, Pokemon pokemon) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        backgroundColor: setSecondaryColor(pokemon.types[0]),
        isScrollControlled: true,
        builder: (_) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -50,
                  width: size.width,
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 80),
                          width: size.width * 0.5,
                          child: Text(
                            Helper.getDisplayName(pokemon.name),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: CachedNetworkImage(
                            imageUrl: pokemon.photoUrl,
                            width: size.width * 0.4 - 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 110),
                  child: Column(
                    children: [
                      _panelRow("Id", Pokemon.getId(pokemon.order.toString())),
                      if (pokemon.types.length == 1)
                        _panelRow(
                            'Type', pokemon.types[0].capitalizeFirstofEach()),
                      if (pokemon.types.length > 1)
                        _panelRow('Types',
                            '${pokemon.types[0].capitalizeFirstofEach()}, ${pokemon.types[1].capitalizeFirstofEach()}'),
                      _panelRow('Height', '${pokemon.height / 10} m'),
                      _panelRow('Weight', '${pokemon.weight / 10} kg'),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          pokemon.species.description.replaceAll('\n', ' '),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    return Scaffold(
      body: Center(
        child: state == null || !state.gotData
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                child: GridView.count(
                  crossAxisCount: cardType + 1,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: state.pokemons
                      .map(
                        (e) => PokemonCard(
                          cardType: 1,
                          pokemon: e,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PokemonDetailsPage(pokemon: e),
                            ),
                          ),
                          onLongPressed: () => showShortPokemonDetails(size, e),
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
    );
  }
}
