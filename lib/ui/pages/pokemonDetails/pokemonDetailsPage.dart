import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/abilitiesWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/bottomNavbar.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/speciesWidget.dart';
import 'package:pokedex/ui/pages/pokemonDetails/components/statWidget.dart';
import 'package:pokedex/utils/color_theme.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:pokedex/extensions/string_extension.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;
  PokemonDetailsPage({@required this.pokemon});
  @override
  _PokemonDetailsPageState createState() => _PokemonDetailsPageState(pokemon);
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  final Pokemon pokemon;
  _PokemonDetailsPageState(this.pokemon);

  int index = 0;

  Widget _pokemonTypeWidget(String type, Color color) {
    if (type == null || type.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        /* border: Border.all(
          color: Colors.white,
        ), */
        color: color,
      ),
      child: Text(
        type.capitalizeFirstofEach(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget detailItem(String title, Widget child) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        index: index,
        onPressed: (value) {
          if (value != index) setState(() => index = value);
        },
      ),
      backgroundColor: setSecondaryColor(pokemon.types[0]),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              padding: EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white60.withOpacity(.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Helper.getDisplayName(pokemon.name),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 7),
                            child: Text(
                              pokemon.species.generation,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: pokemon.types
                                  .map(
                                    (e) => Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: _pokemonTypeWidget(
                                            e, setSecondaryColor(e)),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      Pokemon.getId('${pokemon.order}'),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ), */
                  SizedBox(width: 20),
                  Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: pokemon.photoUrl,
                        width: size.width * 0.25,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          Pokemon.getId('${pokemon.order}'),
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    detailItem('Species', SpeciesWidget(pokemon: pokemon)),
                    SizedBox(height: 15),
                    detailItem('Abilities', AbilitiesWidget(pokemon: pokemon)),
                    SizedBox(height: 15),
                    detailItem('Base Stats', StatWidget(pokemon: pokemon)),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
