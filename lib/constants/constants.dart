const BASE_URL = 'https://pokeapi.co/api/v2';
const SCREEN_WIDTH = 0.5;

const POKEMON_TYPES = <String>[
  'normal',
  'fire',
  'fighting',
  'water',
  'flying',
  'grass',
  'poison',
  'electric',
  'ground',
  'psychic',
  'rock',
  'ice',
  'bug',
  'dragon',
  'ghost',
  'dark',
  'steel',
  'fairy'
];

const GENERATIONS = [
  <String, dynamic>{
    'name': 'generation-i',
    'region': 'kanto',
    'id': 1,
  },
  <String, dynamic>{
    'name': 'generation-ii',
    'region': 'johto',
    'id': 2,
  },
  <String, dynamic>{
    'name': 'generation-iii',
    'region': 'hoenn',
    'id': 3,
  },
  <String, dynamic>{
    'name': 'generation-iv',
    'region': 'sinnoh',
    'id': 4,
  },
  <String, dynamic>{
    'name': 'generation-v',
    'region': 'unova',
    'id': 5,
  },
  <String, dynamic>{
    'name': 'generation-vi',
    'region': 'kalos',
    'id': 6,
  },
  <String, dynamic>{
    'name': 'generation-vii',
    'region': 'alola',
    'id': 7,
  },
  <String, dynamic>{
    'name': 'generation-viii',
    'region': 'galar',
    'id': 8,
  },
];
