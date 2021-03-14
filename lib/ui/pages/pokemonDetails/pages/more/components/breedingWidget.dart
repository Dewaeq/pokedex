import 'package:flutter/material.dart';
import 'package:pokedex/customIcons/pokedexIcons.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/detailItem.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/itemWithDescription.dart';
import 'package:pokedex/utils/color_theme.dart';
import 'package:pokedex/utils/helper.dart';

class BreedingWidget extends StatelessWidget {
  final Pokemon pokemon;
  BreedingWidget({@required this.pokemon});

  Widget _genderRatio() {
    int left = ((8 - pokemon.species.genderRate) / 8 * 100).round();
    if (left > 70) left = 70;
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: left,
            child: Container(
              height: 30,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PokedexIcons.male,
                    size: 20,
                  ),
                  SizedBox(width: 14),
                  Text('${(8 - pokemon.species.genderRate) / 8 * 100}%'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 100 - left,
            child: Container(
              height: 30,
              color: Colors.red[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${pokemon.species.genderRate / 8 * 100}%'),
                  SizedBox(width: 14),
                  Icon(
                    PokedexIcons.female,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eggGroup(String name) {
    EdgeInsets padding;
    if (pokemon.species.eggGroups.length == 1) {
      padding = EdgeInsets.zero;
    } else if (pokemon.species.eggGroups.first == name) {
      padding = EdgeInsets.only(right: 6);
    } else if (pokemon.species.eggGroups.last == name) {
      padding = EdgeInsets.only(left: 6);
    }
    return Expanded(
      child: Container(
        padding: padding,
        child: FlatButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: setPrimaryColor(pokemon.types.first),
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              Text(
                Helper.getDisplayName(name),
              ),
              Spacer(),
              Icon(Icons.info_outline),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailItem(
      title: 'Breeding',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            ItemWithDescription(
              backgroundColor:
                  pokemon.species.genderRate == -1 ? Colors.grey[300] : null,
              padding: pokemon.species.genderRate == -1,
              child: pokemon.species.genderRate == -1
                  ? Text('Genderless')
                  : _genderRatio(),
              description: 'Gender Ratio',
            ),
            SizedBox(height: 15),
            ItemWithDescription(
              child: Row(
                children:
                    pokemon.species.eggGroups.map((e) => _eggGroup(e)).toList(),
              ),
              padding: false,
              backgroundColor: Colors.grey[50],
              description: 'Egg Groups',
            ),
            SizedBox(height: 15),
            ItemWithDescription(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: '${pokemon.species.hatchCounter + 1}',
                      style: TextStyle(
                        color: setPrimaryColor(pokemon.types.first),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text:
                          '  (${255 * (pokemon.species.hatchCounter + 1)} steps)',
                    )
                  ],
                ),
              ),
              description: 'Egg Cycles',
            ),
            SizedBox(height: pokemon.species.habitat == null ? 0 : 15),
            pokemon.species.habitat == null
                ? Container()
                : ItemWithDescription(
                    child: Text(
                      Helper.getDisplayName(pokemon.species.habitat),
                      style: TextStyle(
                        color: setPrimaryColor(pokemon.types.first),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    description: 'Habitat',
                  ),
          ],
        ),
      ),
    );
  }
}
