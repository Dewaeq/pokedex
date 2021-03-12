class DefaultAbility {
  String name;
  String description;
  String effectDescription;
  String shortEffectDescription;
  List<String> pokemon = [];

  DefaultAbility.fromData(Map<String, dynamic> data) {
    name = data['name'];
    description = data['description'];
    effectDescription = data['effect_description'];
    shortEffectDescription = data['short_effect_description'];
    pokemon = List<String>.from(data['pokemon']);
  }
}
