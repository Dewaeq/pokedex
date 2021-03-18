/* class FilterTypes {
  static const FILTER_BY_TYPE = 'hi';
} */
enum FilterType {
  FILTER_BY_GENERATION,
  FILTER_BY_TYPE,
  FILTER_BY_HP,
  FILTER_BY_ATK,
  FILTER_BY_DEF,
  FILTER_BY_SPEC_ATK,
  FILTER_BY_SPEC_DEF,
  FILTER_BY_SPEED,

  FILTER_PROPERTY,
  FILTER_STAT,
}

enum ValueFilterType {
  /// Higher also includes equal to
  HIGHER_THEN,
  LOWER_THEN,
}
