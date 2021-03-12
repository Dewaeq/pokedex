import 'package:pokedex/model/PokemonAbility.dart';
import 'package:pokedex/model/PokemonSpecies.dart';
import 'package:pokedex/model/PokemonStat.dart';

class Pokemon {
  String name;
  String photoUrl;
  String speciesName;
  PokemonSpecies species;
  List<String> types = [];
  int id;
  int order;

  /// In decimetres
  int height;

  /// In hectograms
  int weight;

  List<PokemonStat> stats = [];
  List<PokemonAbility> abilities = [];

  Pokemon({
    this.photoUrl,
    this.name,
    this.speciesName,
    this.species,
    this.types,
    this.id,
    this.order,
    this.height,
    this.weight,
  });

  Pokemon.fromData(Map<String, dynamic> data) {
    photoUrl = data['photo_url'];
    name = data['name'];
    speciesName = data['species_name'];
    types = List<String>.from(data['types']);
    id = data['id'];
    order = data['order'];
    height = data['height'];
    weight = data['weight'];
    stats = List<PokemonStat>.from(
      data['stats'].map((e) => PokemonStat.fromData(e)),
    );
    abilities = List<PokemonAbility>.from(
      data['abilities'].map((e) => PokemonAbility.fromData(e)),
    );
  }

  static String getId(String id) {
    if (id.contains('-1')) return '#unknown';
    return '#' +
        (id.toString().length == 1
            ? '00' + id.toString()
            : id.toString().length == 2
                ? '0' + id.toString()
                : id.toString());
  }
}
