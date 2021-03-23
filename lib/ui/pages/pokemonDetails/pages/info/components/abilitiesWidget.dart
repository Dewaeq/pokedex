import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonAbility.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/utils/colorTheme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AbilitiesWidget extends StatelessWidget {
  final Pokemon pokemon;
  PokemonState state;
  AbilitiesWidget({@required this.pokemon});

  Widget _abilityWidget(Size size, PokemonAbility ability) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 40,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ability.isHidden
            ? Colors.white60
            : setPrimaryColor(pokemon.types.first),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: setPrimaryColor(pokemon.types.first)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () => Helper.showAbilityDetails(
          ability.ability,
          setPrimaryColor(pokemon.types[0]),
          pokemon,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: setPrimaryColor(pokemon.types.first),
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  ability.isHidden ? 'Hidden' : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                Helper.getDisplayName(ability.name),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ability.isHidden
                      ? setPrimaryColor(pokemon.types.first)
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.info_outline,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    state ??= Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (!state.gotData) return CircularProgressIndicator();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      child: Column(
        children:
            pokemon.abilities.map((e) => _abilityWidget(size, e)).toList(),
      ),
    );
  }
}
