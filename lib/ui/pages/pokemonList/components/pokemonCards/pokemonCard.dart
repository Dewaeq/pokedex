import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemonCard1.dart';

class PokemonCard extends StatelessWidget {
  final int cardType;
  final Pokemon pokemon;
  final Function onPressed;
  final Function onLongPressed;

  PokemonCard({
    Key key,
    @required this.cardType,
    @required this.pokemon,
    @required this.onPressed,
    @required this.onLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cardType == 1)
      return PokemonCard1(
        pokemon: pokemon,
        onPressed: onPressed,
        onLongPressed: onLongPressed,
      );
    else
      return Text('ERROR');
  }
}
