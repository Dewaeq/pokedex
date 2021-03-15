/* class FilterTypes {
  static const FILTER_BY_TYPE = 'hi';
} */
enum FilterType {
  FILTER_BY_TYPE,
  FILTER_BY_ATK,
  FILTER_BY_DEF,
  FILTER_BY_HP,
}

enum HPFilterType {
  /// Higher also includes equal to
  HIGHER_THEN,
  LOWER_THEN,
}
