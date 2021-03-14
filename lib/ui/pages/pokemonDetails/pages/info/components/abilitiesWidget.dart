import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonAbility.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pages/info/components/abilityDetails.dart';
import 'package:pokedex/utils/color_theme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AbilitiesWidget extends StatelessWidget {
  final Pokemon pokemon;
  PokemonState state;
  AbilitiesWidget({@required this.pokemon});

  void showAbilityDetails(
      BuildContext context, Size size, PokemonAbility ability) {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        isDismissible: true,
        builder: (_) => AbilityDetails(pokemon: pokemon, ability: ability));
  }

  Widget _abilityWidget(
      Size size, BuildContext context, PokemonAbility ability) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 40,
      decoration: BoxDecoration(
        color: ability.isHidden
            ? Colors.white60
            : setPrimaryColor(pokemon.types.first),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: setPrimaryColor(pokemon.types.first)),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () => showAbilityDetails(context, size, ability),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  color: setPrimaryColor(pokemon.types.first),
                ),
                height: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  ability.isHidden ? 'Hidden' : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[850]),
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
                      : Colors.grey[850],
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.info_outline,
                color: Colors.grey[700],
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

    state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (!state.gotData) return CircularProgressIndicator();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      child: Column(
        children: pokemon.abilities
            .map((e) => _abilityWidget(size, context, e))
            .toList(),
      ),
    );
  }
}
