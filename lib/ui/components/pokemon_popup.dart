import 'package:flutter/material.dart';
import 'package:pokedex/extensions/string_extension.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/utils/helper.dart';

class PokemonPopup extends StatelessWidget {
  final Pokemon pokemon;

  PokemonPopup({Key key, @required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Helper.getDisplayName(pokemon.name),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 20),
            Image.network(
              pokemon.photoUrl,
              width: size.width * 0.4,
            ),
            SizedBox(height: 10),
            Text(
              Pokemon.getId('${pokemon.id}'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types
                  .map((e) => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.blue,
                        ),
                        child: Text(
                          e.capitalizeFirstofEach(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            ListTile(
              title: Text('Weight'),
              subtitle: Text('${pokemon.weight / 10} kg'),
            ),
            ListTile(
              title: Text('Height'),
              subtitle: Text('${pokemon.height / 10} m'),
            ),
          ],
        ),
      ),
    );
  }
}
