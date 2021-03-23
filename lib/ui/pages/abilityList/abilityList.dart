import 'package:flutter/material.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/abilityList/components/abilityCard.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class AbilityList extends StatefulWidget {
  @override
  _AbilityListState createState() => _AbilityListState();
}

class _AbilityListState extends State<AbilityList> {
  PokemonState state;

  @override
  Widget build(BuildContext context) {
    state ??= Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (state == null || !state.gotData) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          itemCount: state.abilities.length,
          itemBuilder: (context, index) {
            return AbilityCard(
              onPressed: () {
                Helper.showAbilityDetails(
                  state.abilities[index],
                  Color(0xff8BCDB4),
                );
              },
              ability: state.abilities[index],
            );
          },
        ),
      ),
    );
  }
}
