import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/constants/constants.dart';
import 'package:pokedex/constants/filterTypes.dart';
import 'package:pokedex/model/PokemonFilter.dart';
import 'package:pokedex/ui/pages/pokemonList/components/filter/filterButtons.dart';
import 'package:pokedex/utils/helper.dart';

class FilterWidget extends StatefulWidget {
  final Function(List<PokemonFilter>) filter;
  final Function onClosed;
  final List<PokemonFilter> filters;
  FilterWidget({
    @required this.filter,
    @required this.onClosed,
    this.filters,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final _hpLimitController = TextEditingController()..text = '0';
  final _defLimitController = TextEditingController()..text = '0';
  final _atkLimitController = TextEditingController()..text = '0';
  final _specAtkLimitController = TextEditingController()..text = '0';
  final _specDefLimitController = TextEditingController()..text = '0';
  final _speedLimitController = TextEditingController()..text = '0';
  final _hpKey = GlobalKey<FormState>();
  final _atkKey = GlobalKey<FormState>();
  final _defKey = GlobalKey<FormState>();
  final _specAtkKey = GlobalKey<FormState>();
  final _specDefKey = GlobalKey<FormState>();
  final _speedKey = GlobalKey<FormState>();

  ValueFilterType _hpFilterMode = ValueFilterType.HIGHER_THEN;
  ValueFilterType _atkFilterMode = ValueFilterType.HIGHER_THEN;
  ValueFilterType _defFilterMode = ValueFilterType.HIGHER_THEN;
  ValueFilterType _specAtkFilterMode = ValueFilterType.HIGHER_THEN;
  ValueFilterType _specDefFilterMode = ValueFilterType.HIGHER_THEN;
  ValueFilterType _speedFilterMode = ValueFilterType.HIGHER_THEN;
  String _typeFilterName = 'normal';
  String _generationFilterName = 'generation-i';

  Set<String> enabledFilters = Set<String>();

  var filters = <PokemonFilter>[];

  void filter() {
    if (enabledFilters.contains('type')) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_TYPE,
        mode: FilterType.FILTER_PROPERTY,
        options: <String, dynamic>{
          'type': _typeFilterName,
        },
      ));
    }
    if (enabledFilters.contains('generation')) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_GENERATION,
        mode: FilterType.FILTER_PROPERTY,
        options: <String, dynamic>{
          'id': GENERATIONS
              .firstWhere((e) => e['name'] == _generationFilterName)['id'],
        },
      ));
    }
    if (enabledFilters.contains('hp') && _hpKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_HP,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 0,
          'mode': _hpFilterMode,
          'value': int.parse(_hpLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('atk') && _atkKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_ATK,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 1,
          'mode': _atkFilterMode,
          'value': int.parse(_atkLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('def') && _defKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_DEF,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 2,
          'mode': _defFilterMode,
          'value': int.parse(_defLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('spec-atk') &&
        _specAtkKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_SPEC_ATK,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 3,
          'mode': _specAtkFilterMode,
          'value': int.parse(_specAtkLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('spec-def') &&
        _specDefKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_SPEC_DEF,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 4,
          'mode': _specDefFilterMode,
          'value': int.parse(_specDefLimitController.text),
        },
      ));
    }
    if (enabledFilters.contains('speed') && _speedKey.currentState.validate()) {
      filters.add(PokemonFilter(
        filterType: FilterType.FILTER_BY_SPEED,
        mode: FilterType.FILTER_STAT,
        options: <String, dynamic>{
          'index': 5,
          'mode': _speedFilterMode,
          'value': int.parse(_speedLimitController.text),
        },
      ));
    }

    widget.filter(filters);
    widget.onClosed();
  }

  void resetFilters() {
    setState(() {
      enabledFilters.clear();
      filters.clear();

      _typeFilterName = 'normal';
      _generationFilterName = 'generation-i';

      _hpFilterMode = ValueFilterType.HIGHER_THEN;
      _atkFilterMode = ValueFilterType.HIGHER_THEN;
      _defFilterMode = ValueFilterType.HIGHER_THEN;
      _specAtkFilterMode = ValueFilterType.HIGHER_THEN;
      _specDefFilterMode = ValueFilterType.HIGHER_THEN;
      _speedFilterMode = ValueFilterType.HIGHER_THEN;

      _hpLimitController.text = '0';
      _defLimitController.text = '0';
      _atkLimitController.text = '0';
      _specAtkLimitController.text = '0';
      _specDefLimitController.text = '0';
      _speedLimitController.text = '0';
    });
  }

  Widget _typeFilterWidget() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: enabledFilters.contains('type'),
      onChanged: (value) {
        if (enabledFilters.contains('type')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_HP);
          setState(() => enabledFilters.remove('type'));
        } else {
          setState(() => enabledFilters.add('type'));
        }
      },
      title: Row(
        children: [
          Text('Type'),
          Spacer(),
          DropdownButton(
            value: _typeFilterName,
            items: POKEMON_TYPES
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(Helper.getDisplayName(e)),
                    ))
                .toList(),
            onChanged: (newType) {
              setState(() => _typeFilterName = newType);
            },
          ),
        ],
      ),
    );
  }

  Widget _hpFilter() {
    return _statFilter(
      key: _hpKey,
      title: 'HP',
      filterName: 'hp',
      onEnabled: (value) {
        if (enabledFilters.contains('hp')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_HP);
          setState(() => enabledFilters.remove('hp'));
        } else {
          setState(() => enabledFilters.add('hp'));
        }
      },
      onChanged: (value) => setState(() => _hpFilterMode = value),
      controller: _hpLimitController,
      filterMode: _hpFilterMode,
    );
  }

  Widget _atkFilter() {
    return _statFilter(
      key: _atkKey,
      title: 'Attack',
      filterName: 'atk',
      onEnabled: (value) {
        if (enabledFilters.contains('atk')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_ATK);
          setState(() => enabledFilters.remove('atk'));
        } else {
          setState(() => enabledFilters.add('atk'));
        }
      },
      onChanged: (value) => setState(() => _atkFilterMode = value),
      controller: _atkLimitController,
      filterMode: _atkFilterMode,
    );
  }

  Widget _defFilter() {
    return _statFilter(
      key: _defKey,
      title: 'Defense',
      filterName: 'def',
      onEnabled: (value) {
        if (enabledFilters.contains('def')) {
          filters.removeWhere((e) => e.filterType == FilterType.FILTER_BY_DEF);
          setState(() => enabledFilters.remove('def'));
        } else {
          setState(() => enabledFilters.add('def'));
        }
      },
      onChanged: (value) => setState(() => _defFilterMode = value),
      controller: _defLimitController,
      filterMode: _defFilterMode,
    );
  }

  Widget _specAtkFilter() {
    return _statFilter(
      key: _specAtkKey,
      title: 'Special Attack',
      filterName: 'spec-atk',
      onEnabled: (value) {
        if (enabledFilters.contains('spec-atk')) {
          filters.removeWhere(
              (e) => e.filterType == FilterType.FILTER_BY_SPEC_ATK);
          setState(() => enabledFilters.remove('spec-atk'));
        } else {
          setState(() => enabledFilters.add('spec-atk'));
        }
      },
      onChanged: (value) => setState(() => _specAtkFilterMode = value),
      controller: _specAtkLimitController,
      filterMode: _specAtkFilterMode,
    );
  }

  Widget _specDefFilter() {
    return _statFilter(
      key: _specDefKey,
      title: 'Special Defense',
      filterName: 'spec-def',
      onEnabled: (value) {
        if (enabledFilters.contains('spec-def')) {
          filters.removeWhere(
              (e) => e.filterType == FilterType.FILTER_BY_SPEC_DEF);
          setState(() => enabledFilters.remove('spec-def'));
        } else {
          setState(() => enabledFilters.add('spec-def'));
        }
      },
      onChanged: (value) => setState(() => _specDefFilterMode = value),
      controller: _specDefLimitController,
      filterMode: _specDefFilterMode,
    );
  }

  Widget _speedFilter() {
    return _statFilter(
      key: _speedKey,
      title: 'Speed',
      filterName: 'speed',
      onEnabled: (value) {
        if (enabledFilters.contains('speed')) {
          filters
              .removeWhere((e) => e.filterType == FilterType.FILTER_BY_SPEED);
          setState(() => enabledFilters.remove('speed'));
        } else {
          setState(() => enabledFilters.add('speed'));
        }
      },
      onChanged: (value) => setState(() => _speedFilterMode = value),
      controller: _speedLimitController,
      filterMode: _speedFilterMode,
    );
  }

  Widget _statFilter({
    @required Key key,
    @required String title,
    @required String filterName,
    @required ValueFilterType filterMode,
    @required Function onEnabled,
    @required Function onChanged,
    @required TextEditingController controller,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: enabledFilters.contains(filterName),
      onChanged: onEnabled,
      title: Row(
        children: [
          Text(title),
          Spacer(),
          DropdownButton(
            value: filterMode,
            items: [
              DropdownMenuItem(
                value: ValueFilterType.HIGHER_THEN,
                child: Text('>='),
              ),
              DropdownMenuItem(
                value: ValueFilterType.LOWER_THEN,
                child: Text('<'),
              ),
            ],
            onChanged: onChanged,
          ),
          SizedBox(width: 30),
          SizedBox(
            width: 60,
            child: Form(
              key: key,
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (int.tryParse(value) == null) return 'Not valid';
                  return null;
                },
                onChanged: (value) {
                  if (!enabledFilters.contains(filterName))
                    setState(() => enabledFilters.add(filterName));
                },
                controller: controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 3,
                decoration: InputDecoration(
                  counter: Container(),
                  errorStyle: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _generationFilter() {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: enabledFilters.contains('generation'),
      onChanged: (value) {
        if (enabledFilters.contains('generation')) {
          filters.removeWhere(
              (e) => e.filterType == FilterType.FILTER_BY_GENERATION);
          setState(() => enabledFilters.remove('generation'));
        } else {
          setState(() => enabledFilters.add('generation'));
        }
      },
      title: Row(
        children: [
          Text('Generation'),
          Spacer(),
          DropdownButton(
            value: _generationFilterName,
            items: GENERATIONS
                .map((e) => DropdownMenuItem(
                      value: e['name'],
                      child: Text(
                        Helper.getGenerationName(e['name']),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() => _generationFilterName = value);
              if (!enabledFilters.contains('generation')) {
                setState(() {
                  enabledFilters.add('generation');
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    if (widget.filters != null) filters = widget.filters;
    for (var filter in filters) {
      if (filter.filterType == FilterType.FILTER_BY_TYPE) {
        enabledFilters.add('type');
        _typeFilterName = filter.options['type'];
      }
      if (filter.filterType == FilterType.FILTER_BY_GENERATION) {
        enabledFilters.add('generation');
        _generationFilterName = GENERATIONS
            .firstWhere((e) => e['id'] == filter.options['id'])['name'];
      }
      if (filter.filterType == FilterType.FILTER_BY_HP) {
        enabledFilters.add('hp');
        _hpFilterMode = filter.options['mode'];
        _hpLimitController.text = filter.options['value'].toString();
      }
      if (filter.filterType == FilterType.FILTER_BY_ATK) {
        enabledFilters.add('atk');
        _atkFilterMode = filter.options['mode'];
        _atkLimitController.text = filter.options['value'].toString();
      }
      if (filter.filterType == FilterType.FILTER_BY_DEF) {
        enabledFilters.add('def');
        _defFilterMode = filter.options['mode'];
        _defLimitController.text = filter.options['value'].toString();
      }
      if (filter.filterType == FilterType.FILTER_BY_SPEC_ATK) {
        enabledFilters.add('spec-atk');
        _specAtkFilterMode = filter.options['mode'];
        _specAtkLimitController.text = filter.options['value'].toString();
      }
      if (filter.filterType == FilterType.FILTER_BY_SPEC_DEF) {
        enabledFilters.add('spec-def');
        _specDefFilterMode = filter.options['mode'];
        _specDefLimitController.text = filter.options['value'].toString();
      }
      if (filter.filterType == FilterType.FILTER_BY_SPEED) {
        enabledFilters.add('speed');
        _speedFilterMode = filter.options['mode'];
        _speedLimitController.text = filter.options['value'].toString();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
      onPressed: widget.onClosed,
      padding: EdgeInsets.zero,
      color: Colors.grey.withOpacity(.4),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25, bottom: 15),
                child: Text(
                  'Filter by...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _typeFilterWidget(),
                      _generationFilter(),
                      _hpFilter(),
                      _atkFilter(),
                      _defFilter(),
                      _specAtkFilter(),
                      _specDefFilter(),
                      _speedFilter(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              ResetFiltersButton(resetFilters: resetFilters),
              SizedBox(height: 5),
              ApplyFiltersButton(filter: filter),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
