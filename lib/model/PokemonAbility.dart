import 'package:pokedex/model/DefaultAbility.dart';

class PokemonAbility {
  String name;
  int slot;
  bool isHidden;
  DefaultAbility ability;

  PokemonAbility.fromData(Map<String, dynamic> data) {
    name = data['name'];
    slot = data['slot'];
    isHidden = data['is_hidden'];
  }
}
