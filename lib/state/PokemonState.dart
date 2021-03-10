import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonEvolution.dart';
import 'package:pokedex/model/PokemonSpecies.dart';
import 'package:flutter/services.dart' show rootBundle;

class PokemonState with ChangeNotifier {
  bool gotPokemon = false;
  bool isBusy = false;
  List<Pokemon> pokemons = [];
  List<String> gotPokemons = [];

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

    for (var pData in pokemonData.values) {
      var p = Pokemon.fromData(pData);
      if (!gotPokemons.contains(p.name)) {
        p.species = PokemonSpecies.fromData(speciesData[p.speciesName]);

        var pEvolutions =
            List.from(evolutionData['${p.species.evolutionChainId}']);
        p.species.evolutions =
            pEvolutions.map((e) => PokemonEvolution.fromData(e)).toList();

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
    gotPokemon = true;
    isBusy = false;
    notifyListeners();
  }
}
