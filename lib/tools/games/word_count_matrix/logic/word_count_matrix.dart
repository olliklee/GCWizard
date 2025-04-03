import 'dart:convert';

enum SearchFlags { HORIZONTAL, VERTICAL, DIAGONAL, CASESENSITIVE }

enum Directions {
  N(-1, 0, '⬆️'),
  E(0, 1, '➡️'),
  S(1, 0, '⬇️'),
  W(0, -1, '⬅️'),
  NE(-1, 1, '↗️'),
  SE(1, 1, '↘️'),
  SW(1, -1, '↙️'),
  NW(-1, -1, '↖️');

  final int dx;
  final int dy;
  final String directionArrow;

  const Directions(this.dx, this.dy, this.directionArrow);
}

class WordSearchResult {
  final Map<Directions, int> counts;
  final List<List<String>> cleanedInput;
  final List<List<int>> markerMatrix;

  WordSearchResult(this.counts, this.cleanedInput, this.markerMatrix);

  int get sumTotal => counts.values.isNotEmpty ? counts.values.reduce((a, b) => a + b) : 0;}

WordSearchResult wordCountMatrix(
  String inputText,
  String word, {
  bool caseSensitive = false,
  Set<SearchFlags> flags = const {
    SearchFlags.HORIZONTAL,
    SearchFlags.VERTICAL,
    SearchFlags.DIAGONAL,
  },
}) {
  List<Directions> allowedDirections = _getAllowedDirection(flags);
  Map<Directions, int> counts = {for (var dir in allowedDirections) dir: 0};

  if (inputText.isEmpty || word.isEmpty || flags.isEmpty) {
    return WordSearchResult(counts, [[]], [[]]);
  }

  var caseSensitive = flags.contains(SearchFlags.CASESENSITIVE);
  var cleanedText = _cleanText(inputText, caseSensitive: caseSensitive);
  var searchText = _cleanText(word, caseSensitive: caseSensitive);
  var inputGrid = _convertToMatrix(cleanedText);

  int rows = inputGrid.length;
  int cols = inputGrid[0].length;

  List<List<int>> markerMatrix = List.generate(rows, (i) => List.filled(cols, 0));

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      for (var dir in allowedDirections) {
        if (_search(inputGrid, markerMatrix, searchText, i, j, dir.dx, dir.dy)) {
          counts[dir] = (counts[dir] ?? 0) + 1;
        }
      }
    }
  }
  return WordSearchResult(counts, inputGrid, markerMatrix);
}

bool _search(List<List<String>> grid, List<List<int>> markerMatrix, String word, int x, int y, int dx, int dy) {
  int rows = grid.length;
  int cols = grid[0].length;

  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;

    if (nx < 0 || ny < 0 || nx >= rows || ny >= cols || grid[nx][ny] != word[k]) {
      return false;
    }
  }

  int markerValue = (dx == 0 || dy == 0) ?
  (dx == 0 ? 2 : 1) : 3; // Hor = 1, Ver = 2, Dia = 3

  // mark all matches
  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;
    markerMatrix[nx][ny] = markerValue; // Richtungswert setzen
    markerMatrix[nx][ny] |= markerValue;
  }
  return true;
}

List<Directions> _getAllowedDirection(Set<SearchFlags> flags) {
  List<Directions> allowedDirections = [];

  if (flags.contains(SearchFlags.HORIZONTAL)) {
    allowedDirections.addAll([Directions.E, Directions.W]);
  }
  if (flags.contains(SearchFlags.VERTICAL)) {
    allowedDirections.addAll([Directions.S, Directions.N]);
  }
  if (flags.contains(SearchFlags.DIAGONAL)) {
    allowedDirections.addAll([Directions.SE, Directions.NW, Directions.SW, Directions.NE]);
  }
  return allowedDirections;
}

String _cleanText(String input, {bool caseSensitive = false}) {
  // allows even diacritics
  RegExp regex = RegExp(r'[\p{L}\p{N}.]', unicode: true);

  return input
      .replaceAll('\n\n', '\n')
      .split('\n')
      .map((line) => line.split('').where((char) => regex.hasMatch(char)).join(''))
      .map((line) => caseSensitive ? line : line.toUpperCase())
      .join('\n');
}

List<List<String>> _convertToMatrix(String input) {
  List<String> lines = const LineSplitter()
      .convert(input)
      .map((line) => line.trimRight()) // Entfernt überflüssige Leerzeichen am Zeilenende
      .toList();

  if (lines.isEmpty) return []; // Falls der Input leer ist, gib eine leere Liste zurück.

  var maxLength = lines.map((line) => line.length).reduce((a, b) => a > b ? a : b);

  return lines
      .map((line) => line.padRight(maxLength, '.').split('')) // Zeilen mit Punkten auffüllen
      .toList();
}
