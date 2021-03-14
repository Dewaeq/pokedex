import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/pokemonCards/pokemon_card.dart';
import 'package:pokedex/utils/helper.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList>
    with TickerProviderStateMixin {
  int _cardType = 1;
  bool _open = false;
  bool _openSearch = false;
  bool _includeEvolutions = false;
  List<Pokemon> shownPokemon;
  PokemonState state;
  TextEditingController _controller = TextEditingController();

  AnimationController _animationController;

  Widget _fabButton({Function onPressed, String title, IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RaisedButton(
            onPressed: () {
              animate();
              onPressed();
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(title),
          ),
          SizedBox(
            height: 40,
            child: RaisedButton(
              onPressed: () {
                animate();
                onPressed();
              },
              shape: CircleBorder(),
              color: Colors.white,
              child: Icon(icon),
            ),
          ),
        ],
      ),
    );
  }

  Widget floatingOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _fabButton(
            onPressed: () {}, icon: Icons.sort, title: 'Sort by property'),
        _fabButton(
            onPressed: () {},
            icon: Icons.filter_list_alt,
            title: 'Filter by property'),
        _fabButton(
            onPressed: () {
              setState(() => _openSearch = !_openSearch);
            },
            icon: Icons.search,
            title: 'Search'),
      ],
    );
  }

  Widget _appBar(Size size) {
    return SliverAppBar(
      title: Text(
        'Pokédex',
        style: TextStyle(
          color: Colors.blueGrey[900],
        ),
      ),
      toolbarHeight: size.height * 0.1,
      iconTheme: IconThemeData(color: Colors.blueGrey[700]),
      floating: true,
      backgroundColor: Colors.white,
    );
  }

  Widget _searchAppBar(Size size) {
    return SliverAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) => filterPokemon(value),
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(hintText: 'Pokemon name or id'),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            onChanged: (value) {
              setState(() => _includeEvolutions = value);
              filterPokemon(_controller.text);
            },
            contentPadding: EdgeInsets.zero,
            value: _includeEvolutions,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('Include evolutions'),
          ),
        ],
      ),
      leading: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey[800]),
          onPressed: () {
            filterPokemon('');
            setState(() {
              _controller.text = '';
              _openSearch = false;
            });
            FocusScope.of(context).unfocus();
          },
        ),
      ),
      floating: true,
      backgroundColor: Colors.white,
      toolbarHeight: size.height * 0.15,
    );
  }

  void filterPokemon(String input) {
    if (input == '') {
      setState(() => shownPokemon = state.pokemons);
      return;
    }
    input = input.trim().toUpperCase();
    var newPokemon = state.pokemons.where((e) {
      if (_includeEvolutions) {
        for (var x in e.species.evolutions) {
          if (Helper.getDisplayName(x.fromPokemon)
              .toUpperCase()
              .contains(input)) {
            return true;
          }
        }
      }
      if (Helper.getDisplayName(e.name).toUpperCase().contains(input) ||
          '${e.id}'.contains(input) ||
          Pokemon.getId('${e.id}').contains(input)) {
        return true;
      }
      return false;
    }).toList();
    setState(() {
      shownPokemon = newPokemon;
    });
  }

  void animate() {
    if (!_open)
      _animationController.forward();
    else
      _animationController.reverse();
    _open = !_open;
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    state = Provider.of<PokemonState>(context);
    if (!state.isBusy && !state.gotData) state.init();

    if (state == null || !state.gotData) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (shownPokemon == null) shownPokemon = state.pokemons;

    return KeyboardVisibilityBuilder(builder: (_, visible) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: animate,
          backgroundColor: _open ? Colors.white : Colors.deepPurpleAccent,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            color: _open ? Colors.deepPurpleAccent : Colors.white,
            progress: _animationController,
          ),
        ),
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Container(
                  child: CustomScrollView(
                    slivers: [
                      !_openSearch ? _appBar(size) : _searchAppBar(size),
                      SliverPadding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                        sliver: shownPokemon.isEmpty
                            ? SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    'No pokemon found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey[850],
                                    ),
                                  ),
                                ),
                              )
                            : SliverGrid.count(
                                crossAxisCount: _cardType + 1,
                                childAspectRatio: 1.2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: List<Widget>.from(shownPokemon.map(
                                  (e) => PokemonCard(
                                    cardType: 1,
                                    pokemon: e,
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PokemonDetailsPage(pokemon: e),
                                      ),
                                    ),
                                    onLongPressed: () =>
                                        Helper.showShortPokemonDetails(
                                            context, size, e),
                                  ),
                                ))
                                  ..add(SizedBox(height: 20)),
                              ),
                      ),
                    ],
                  ),
                ),
                !_open
                    ? Container()
                    : Positioned(
                        bottom: 85,
                        right: 5,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: _open ? 1 : 0,
                          child: floatingOptions(),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
    });
  }
}
