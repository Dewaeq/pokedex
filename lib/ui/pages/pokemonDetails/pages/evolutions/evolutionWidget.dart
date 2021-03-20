import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EvolutionWidget extends StatelessWidget {
  final Pokemon pokemon;
  EvolutionWidget({@required this.pokemon});

  PokemonState state;
  List<String> evoPokeNames = [];
  List<Pokemon> evoPokemon = [];
  List<Pokemon> megaEvoPokemon = [];
  List<Pokemon> gMaxPokemon = [];
  List<Pokemon> alternatePokemon = [];

  Widget _evolution(BuildContext context, Size size, Pokemon p) {
    var evolution = pokemon.species.evolutions.firstWhere(
      (e) => p.name.contains(e.fromPokemon),
      orElse: () => null,
    );
    int flex = pokemon.species.evolutions.length + 2;
    if (flex > 3) flex = 3;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pokemonItem(context, size, flex, p),
          SizedBox(
            width: evolution == null ? 0 : 10,
          ),
          evolution == null
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Icon(Icons.arrow_forward),
                      SizedBox(height: 8),
                      Text(
                          '${evolution.minLevel ?? Helper.getDisplayName(evolution.itemName) ?? ''}'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _pokemonItem(BuildContext context, Size size, int flex, Pokemon p) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: MaterialButton(
        onPressed: () {
          if (p.name != pokemon.name) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PokemonDetailsPage(pokemon: p)),
            );
          }
        },
        onLongPress: () => Helper.showShortPokemonDetails(context, size, p),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Text(
              Helper.getDisplayName(p.name),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[900].withOpacity(.9),
              ),
            ),
            SizedBox(height: 15),
            CachedNetworkImage(
              imageUrl: p.photoUrl,
              width: (size.width - 100) / flex,
            ),
          ],
        ),
      ),
    );
  }

  Widget _scrollabe(List<Widget> children) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (!state.gotData) return CircularProgressIndicator();

    bool alola = pokemon.name.contains('-alola');
    bool galar = pokemon.name.contains('-galar');

    megaEvoPokemon = state.pokemons
        .where((e) => e.name.contains(pokemon.species.name + '-mega'))
        .toList();

    gMaxPokemon = state.pokemons
        .where((e) =>
            e.species.name == pokemon.species.name && e.name.contains('-gmax'))
        .toList();
    /* gMaxPokemon = state.pokemons
        .where((e) => e.name.contains(pokemon.species.name + '-gmax'))
        .toList(); */

    alternatePokemon = state.pokemons
        .where((e) =>
            e.species.name == pokemon.species.name &&
            !e.name.contains('-gmax') &&
            !e.name.contains('-mega') &&
            e.name != pokemon.name)
        .toList();

    if (pokemon.species.evolutions.isNotEmpty) {
      evoPokeNames = pokemon.species.evolutions
          .map((e) =>
              e.toPokemon +
              (alola
                  ? '-alola'
                  : galar
                      ? '-galar'
                      : ''))
          .toList()
            ..add(pokemon.species.evolutions.first.fromPokemon +
                (alola
                    ? '-alola'
                    : galar
                        ? '-galar'
                        : ''));

      evoPokemon = state.pokemons.where((e) {
        if (e.name.contains('-gmax') || e.name.contains('-mega')) {
          return false;
        }
        if (evoPokeNames.contains(e.name)) {
          return true;
        }
        for (var n in evoPokeNames) {
          if (e.name.contains(n)) return true;
        }
        return false;
      }).toList();
      evoPokemon.sort((a, b) => a.id.compareTo(b.id));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          DetailItem(
            title: 'Evolution Chain',
            child: Container(
              child: evoPokemon.isEmpty
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "${Helper.getDisplayName(pokemon.name)} doesn't have any evolutions",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : _scrollabe(
                      evoPokemon
                          .map((e) => _evolution(context, size, e))
                          .toList(),
                    ),
            ),
          ),
          megaEvoPokemon.isEmpty
              ? Container()
              : DetailItem(
                  title: 'Mega Evolution',
                  child: _scrollabe(
                    megaEvoPokemon
                        .map((e) => _pokemonItem(context, size, 3, e))
                        .toList(),
                  ),
                ),
          gMaxPokemon.isEmpty
              ? Container()
              : DetailItem(
                  title: 'Gigantamax forms',
                  child: _scrollabe(
                    gMaxPokemon
                        .map((e) => _pokemonItem(context, size, 3, e))
                        .toList(),
                  ),
                ),
          SizedBox(height: 20),
          alternatePokemon.isEmpty
              ? Container()
              : DetailItem(
                  title: 'Alternative forms',
                  child: _scrollabe(
                    alternatePokemon
                        .map((e) => _pokemonItem(context, size, 3, e))
                        .toList(),
                  ),
                ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
