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
  final List<Pokemon> pokemons = [];
  List<DefaultAbility> abilities = [];
  List<String> _gotPokemons = [];
  List<String> _gotAbilities = [];

  Map<String, dynamic> _pokemonData;
  Map<String, dynamic> _evolutionData;
  Map<String, dynamic> _speciesData;
  Map<String, dynamic> _abilitiesData;

  void init() async {
    isBusy = true;
    notifyListeners();

    var pokemonDataString =
        await rootBundle.loadString('assets/data/all_pokemon.json');
    _pokemonData = jsonDecode(pokemonDataString);
    var evolutionDataString =
        await rootBundle.loadString('assets/data/all_evolutions.json');
    _evolutionData = jsonDecode(evolutionDataString);
    var speciesDataString =
        await rootBundle.loadString('assets/data/all_species.json');
    _speciesData = jsonDecode(speciesDataString);
    var abilitiesDataString =
        await rootBundle.loadString('assets/data/all_abilities.json');
    _abilitiesData = jsonDecode(abilitiesDataString);

    _loadAbilities();
    _loadPokemon();

    _fixPokemonOrder();
    _sortPokemon();

    gotData = true;
    isBusy = false;
    notifyListeners();
  }

  void _loadAbilities() {
    for (var aData in _abilitiesData.values) {
      var a = DefaultAbility.fromData(aData);
      if (!_gotAbilities.contains(a.name)) {
        abilities.add(a);
        _gotAbilities.add(a.name);
      }
    }
  }

  void _loadPokemon() {
    for (var pData in _pokemonData.values) {
      var p = Pokemon.fromData(pData);
      if (!_gotPokemons.contains(p.name)) {
        p.species = PokemonSpecies.fromData(_speciesData[p.speciesName]);

        var pEvolutions =
            List.from(_evolutionData['${p.species.evolutionChainId}']);
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
        _gotPokemons.add(p.name);
      }
    }
  }

  void _fixPokemonOrder() {
    for (var p in pokemons) {
      if (p.name.contains('-gmax') ||
          p.name.contains('-mega') ||
          p.name.contains('-alola') ||
          p.name.contains('-galar')) {
        p.order = pokemons
            .firstWhere((e) =>
                e.speciesName == p.speciesName &&
                !e.name.contains('-gmax') &&
                !e.name.contains('-galar') &&
                !e.name.contains('-alola') &&
                !e.name.contains('-mega'))
            .id;
        p.id = p.order;
      }
    }
  }

  void _sortPokemon() {
    pokemons.sort(((a, b) {
      if (a.species.name == b.species.name) {
        if (a.name.contains('-mega') || a.name.contains('-gmax')) {
          return 1;
        }
        return -1;
      }
      /* This sorts by family
       if (a.order == -1 && b.order == -1) return 0;
      if (a.order == -1) return 1;
      if (b.order == -1) return -1;
      return a.order.compareTo(b.order); */

      /// This sorts like we're used to
      if (a.id == -1 && b.id == -1) return 0;
      if (a.id == -1) return 1;
      if (b.id == -1) return -1;
      return a.id.compareTo(b.id);
    }));
  }
}
