import 'package:flutter/foundation.dart';
import 'package:pokedex/model/DefaultAbility.dart';
import 'dart:convert';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonEvolution.dart';
import 'package:pokedex/model/PokemonSpecies.dart';
import 'package:flutter/services.dart' show rootBundle;

class PokemonState with ChangeNotifier {
  bool gotData = false;
  bool isBusy = false;
  List<Pokemon> pokemons = [];
  List<DefaultAbility> abilities = [];
  List<String> gotPokemons = [];
  List<String> gotAbilities = [];

  void init() async {
    isBusy = true;
    notifyListeners();
    print('initialising');
    var pokemonDataString =
        await rootBundle.loadString('assets/data/all_pokemon.json');
    Map<String, dynamic> pokemonData = jsonDecode(pokemonDataString);
    var evolutionDataString =
        await rootBundle.loadString('assets/data/all_evolutions.json');
    Map<String, dynamic> evolutionData = jsonDecode(evolutionDataString);
    var speciesDataString =
        await rootBundle.loadString('assets/data/all_species.json');
    Map<String, dynamic> speciesData = jsonDecode(speciesDataString);
    var abilitiesDataString =
        await rootBundle.loadString('assets/data/all_abilities.json');
    Map<String, dynamic> abilitiesData = jsonDecode(abilitiesDataString);

    for (var aData in abilitiesData.values) {
      var a = DefaultAbility.fromData(aData);
      if (!gotAbilities.contains(a.name)) {
        abilities.add(a);
        gotAbilities.add(a.name);
      }
    }

    for (var pData in pokemonData.values) {
      var p = Pokemon.fromData(pData);
      if (!gotPokemons.contains(p.name)) {
        p.species = PokemonSpecies.fromData(speciesData[p.speciesName]);

        var pEvolutions =
            List.from(evolutionData['${p.species.evolutionChainId}']);
        p.species.evolutions =
            pEvolutions.map((e) => PokemonEvolution.fromData(e)).toList();

        for (int i = 0; i < p.abilities.length; i++) {
          var ability = p.abilities[i];
          p.abilities[i].ability =
              abilities.firstWhere((e) => e.name == ability.name);
        }

        p.abilities.sort((a, b) {
          if (!a.isHidden && b.isHidden) return -1;
          if (a.isHidden && !b.isHidden) return 1;
          return 0;
        });

        pokemons.add(p);
        gotPokemons.add(p.name);
      }
    }

    pokemons.sort(((a, b) {
      if (a.order == -1 && b.order == -1) return 0;
      if (a.order == -1) return 1;
      if (b.order == -1) return -1;
      return a.order.compareTo(b.order);
    }));
    gotData = true;
    isBusy = false;
    notifyListeners();
  }
}
