import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/constants/filterTypes.dart';
import 'package:pokedex/model/Pokemon.dart';
import 'package:pokedex/model/PokemonFilter.dart';
import 'package:pokedex/state/PokemonState.dart';
import 'package:pokedex/ui/pages/pokemonDetails/pokemonDetailsPage.dart';
import 'package:pokedex/ui/pages/pokemonList/components/filter/filterWidget.dart';
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
  bool _openFilter = false;
  bool _includeEvolutions = false;
  List<Pokemon> shownPokemon;
  List<PokemonFilter> _filters;
  PokemonState state;

  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController;
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

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: animate,
      backgroundColor: _open ? Colors.white : Colors.deepPurpleAccent,
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        color: _open ? Colors.deepPurpleAccent : Colors.white,
        progress: _animationController,
      ),
    );
  }

  Widget floatingOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _fabButton(
          onPressed: scrollToTop,
          icon: Icons.keyboard_arrow_up,
          title: 'Go to top',
        ),
        _fabButton(
          onPressed: () {},
          icon: Icons.sort,
          title: 'Sort by property',
        ),
        _fabButton(
          onPressed: _openFilterMenu,
          icon: Icons.filter_list_alt,
          title: 'Filter by property',
        ),
        _fabButton(
          onPressed: () {
            scrollToTop();
            setState(() => _openSearch = !_openSearch);
          },
          icon: Icons.search,
          title: 'Search',
        ),
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
      snap: _openSearch,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) => _searchPokemon(value),
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(hintText: 'Pokemon name or id'),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            onChanged: (value) {
              setState(() => _includeEvolutions = value);
              _searchPokemon(_searchController.text);
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
            _searchPokemon('');
            setState(() {
              _searchController.text = '';
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

  Widget _pokemonList(Size size) {
    // if (shownPokemon.length % (_cardType + 1) == 0) return Text('hi');
    return CustomScrollView(
      controller: _scrollController,
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
                          builder: (_) => PokemonDetailsPage(pokemon: e),
                        ),
                      ),
                      onLongPressed: () =>
                          Helper.showShortPokemonDetails(context, size, e),
                    ),
                  ))
                    ..addAll([
                      SizedBox(
                        height: 1,
                      ),
                      shownPokemon.length % (_cardType + 1) == 0
                          ? SizedBox(height: 1)
                          : Container(),
                    ]),
                ),
        ),
      ],
    );
  }

  void _openFilterMenu() {
    setState(() => _openFilter = true);
    return;
  }

  void _closeFilterMenu() {
    setState(() => _openFilter = false);
  }

  void _filterPokemon(List<PokemonFilter> filters) {
    if (filters.isEmpty) {
      _filters = null;
      setState(() => shownPokemon = state.pokemons);
      return;
    }
    _filters = filters;
    shownPokemon = state.pokemons;

    for (var filter in filters) {
      if (filter.filterType == FilterType.FILTER_BY_TYPE) {
        _filterPokemonByType(filter.options['type']);
      } else if (filter.mode == FilterType.FILTER_STAT) {
        _filterPokemonByStat(filter.options);
      } else if (filter.filterType == FilterType.FILTER_BY_GENERATION) {
        _filterPokemonByGeneration(filter.options);
      }
    }
  }

  void _filterPokemonByType(String pokemonType) {
    var newPokemon =
        state.pokemons.where((e) => e.types.contains(pokemonType)).toList();
    setState(() => shownPokemon = newPokemon);
  }

  void _filterPokemonByGeneration(Map<String, dynamic> options) {
    var newPokemon = <Pokemon>[];
    newPokemon = shownPokemon
        .where((e) => e.species.generationId == options['id'])
        .toList();

    setState(() => shownPokemon = newPokemon);
  }

  void _filterPokemonByStat(Map<String, dynamic> options) {
    var newPokemon = <Pokemon>[];
    if (options['mode'] == ValueFilterType.HIGHER_THEN) {
      newPokemon = shownPokemon
          .where((e) => e.stats[options['index']].baseStat >= options['value'])
          .toList();
    } else {
      newPokemon = shownPokemon
          .where((e) => e.stats[0].baseStat < options['value'])
          .toList();
    }
    setState(() => shownPokemon = newPokemon);
  }

  void _searchPokemon(String input) {
    if (input == '') {
      setState(() => shownPokemon = state.pokemons);
      return;
    }
    input = input.trim().toLowerCase();
    var newPokemon = state.pokemons;

    if (POKEMON_TYPES.contains(input)) {
      _filterPokemonByType(input);

      return;
    }
    newPokemon = state.pokemons.where((e) {
      if (_includeEvolutions) {
        for (var x in e.species.evolutions) {
          if (Helper.getDisplayName(x.fromPokemon)
                  .toLowerCase()
                  .contains(input) ||
              Helper.getDisplayName(x.toPokemon)
                  .toLowerCase()
                  .contains(input)) {
            return true;
          }
        }
      }
      if (Helper.getDisplayName(e.name).toLowerCase().contains(input) ||
          '${e.id}'.contains(input) ||
          Pokemon.getId('${e.id}').contains(input)) {
        return true;
      }
      return false;
    }).toList();

    if (_includeEvolutions) {
      var mainPokemon = newPokemon.firstWhere(
          (e) => Helper.getDisplayName(e.name).toLowerCase().contains(input));
      newPokemon.remove(mainPokemon);
      newPokemon = Helper.sortPokemon(newPokemon)..insert(0, mainPokemon);
    } else {
      newPokemon = Helper.sortPokemon(newPokemon);
    }

    setState(() {
      shownPokemon = newPokemon;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void animate() {
    if (!_open) {
      _animationController.forward();
    } else
      _animationController.reverse();
    _open = !_open;
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    )..addListener(() => setState(() {}));

    _scrollController = ScrollController();

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
        floatingActionButton: _openFilter ? null : _floatingActionButton(),
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Center(
            child: Stack(
              children: [
                Container(
                  child: _pokemonList(size),
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
                      ),
                _openFilter
                    ? FilterWidget(
                        filter: _filterPokemon,
                        onClosed: _closeFilterMenu,
                        filters: _filters,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
