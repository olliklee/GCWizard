import 'dart:convert';

enum SearchFlags { HORIZONTAL, VERTICAL, DIAGONAL, IGNORECASE }

enum Directions {
  N(-1, 0), E(0, 1), S(1, 0), W(0, -1),
  NE(-1, 1), SE(1, 1), SW(1, -1), NW(-1, -1);

  final int dx;
  final int dy;

  const Directions(this.dx, this.dy);
}

class WordSearchResult {
  final Map<Directions, int> counts;
  final List<List<int>> markerMatrix;
  final List<List<String>> inputMatrix;

  WordSearchResult(this.counts, this.markerMatrix, this.inputMatrix);
  int get sumTotal => counts.values.reduce((a, b) => a + b);
}

WordSearchResult wordCountMatrix(
    String inputText,
    String word, {
      bool caseSensitive = false,
      List<SearchFlags> flags = const [
        SearchFlags.HORIZONTAL, 
        SearchFlags.VERTICAL, 
        SearchFlags.DIAGONAL,
        SearchFlags.IGNORECASE],
    }) {
  
  var ignoreCase = flags.contains(SearchFlags.IGNORECASE);
  var cleanedText = _cleanText(inputText, ignoreCase: ignoreCase);
  var searchText = _cleanText(word, ignoreCase: ignoreCase);
  var inputMatrix = _convertToMatrix(cleanedText);

  int rows = inputMatrix.length;
  int cols = inputMatrix[0].length;

  List<List<int>> markerMatrix = List.generate(rows, (i) => List.filled(cols, 0));

  List<Directions> allowedDirections = _getAllowedDirection(flags);
  Map<Directions, int> counts = {for (var dir in allowedDirections) dir: 0};

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      for (var dir in allowedDirections) {
        if (_searchAndMark(inputMatrix, markerMatrix, searchText, i, j, dir.dx, dir.dy)) {
          counts[dir] = (counts[dir] ?? 0) + 1;
        }
      }
    }
  }
  return WordSearchResult(counts, markerMatrix, inputMatrix);
}

bool _searchAndMark(List<List<String>> matrix, List<List<int>> markerMatrix, String word, int x, int y, int dx, int dy) {
  int rows = matrix.length;
  int cols = matrix[0].length;

  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;

    if (nx < 0 || ny < 0 || nx >= rows || ny >= cols || matrix[nx][ny] != word[k]) {
      return false;
    }
  }

  // vertikal = 1, horizontal = 2, diagonal = 4
  int markerValue = (dx == 0 || dy == 0) ? (dx == 0 ? 2 : 1) : 4;

  // mark all matches
  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;
    markerMatrix[nx][ny] |= markerValue;
  }

  return true;
}

List<Directions> _getAllowedDirection(List<SearchFlags> flags) {
  List<Directions> allowedDirections = [];

  if (flags.contains(SearchFlags.HORIZONTAL)) {
    allowedDirections.addAll([Directions.E, Directions.W]);
  }
  if (flags.contains(SearchFlags.VERTICAL)) {
    allowedDirections.addAll([Directions.N, Directions.S]);
  }
  if (flags.contains(SearchFlags.DIAGONAL)) {
    allowedDirections.addAll([Directions.SE, Directions.NE, Directions.SW, Directions.NW]);
  }
  return allowedDirections;
}

String _cleanText(String input, {bool ignoreCase = true}) {
  RegExp regex = RegExp(r'[\p{L}\p{N}\p{P} ]', unicode: true);

  return input
      .split('\n')
      .map((line) => line.split('').where((char) => regex.hasMatch(char)).join(''))
      .map((line) => ignoreCase ? line.toUpperCase() : line)
      .join('\n');
}

List<List<String>> _convertToMatrix(String input) {
  List<String> lines = const LineSplitter().convert(input);
  var maxLength = lines.map((line) => line.length).reduce((a, b) => a > b ? a : b);

  return lines
      .map((line) => line.padRight(maxLength, ' ').split("")) // fill space
      .toList();
}

// void main() {
//   var matrixText = '''MMMSXXMASM
// MAXMSMAMSA
// AMXSXMAAMM
// MSAMASMSMX
// XMASAMXAMM
// XXAMMXXAMA
// SMSMSASXSS
// SAXAMASAAA
// MAMMMXMMMM
// MXMXAXMASX''';
//
//   String word = "XMAS";
//
//   var result = wordCountInMatrixDetailed(matrixText, word);
//   print("Fundstellen (1 = horizontal, 2 = vertikal, 4 = diagonal):");
//   for (var row in result.markerMatrix) {
//     print(row.join(" "));
//   }
//
//   print("Vorkommen pro Richtung:");
//   result.counts.forEach((direction, count) {
//     print("${direction.name}: $count-mal");
//   });
//   print("total ${result.sumTotal}");
// }