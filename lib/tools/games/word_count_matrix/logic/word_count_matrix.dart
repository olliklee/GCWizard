enum SearchFlags { HORIZONTAL, VERTICAL, DIAGONAL }

enum Directions {
  N(-1, 0), S(1, 0), E(0, 1), W(0, -1),
  NE(-1, 1), SE(1, 1), SW(1, -1), NW(-1, -1);

  final int dx;
  final int dy;

  const Directions(this.dx, this.dy);
}

class WordSearchResult {
  final Map<Directions, int> counts;
  final List<List<int>> markerMatrix;

  WordSearchResult(this.counts, this.markerMatrix);
}

void main() {
  var matrixText = '''XMASX
  XmAsM
  xmasA
  xMaSX''';

  String word = "XMAS";

  var result = wordCountInMatrixDetailed(matrixText, word, caseSensitive: false);

  print("Fundstellen (1 = horizontal, 2 = vertikal, 3 = diagonal):");
  for (var row in result.markerMatrix) {
    print(row.join(" "));
  }

  print("Vorkommen pro Richtung:");
  result.counts.forEach((direction, count) {
    print("${direction.name}: $count-mal");
  });
}

WordSearchResult wordCountInMatrixDetailed(
    String matrixText,
    String word, {
      bool caseSensitive = false,
      List<SearchFlags> flags = const [SearchFlags.HORIZONTAL, SearchFlags.VERTICAL, SearchFlags.DIAGONAL],
    }) {
  var cleanedText = _cleanText(matrixText, caseSensitive: caseSensitive);
  var searchText = _cleanText(word, caseSensitive: caseSensitive);
  var matrix = _convertToMatrix(cleanedText);

  int rows = matrix.length;
  int cols = matrix[0].length;

  // Erstelle eine Markierungs-Matrix (initialisiert mit 0)
  List<List<int>> markerMatrix = List.generate(rows, (i) => List.filled(cols, 0));

  List<Directions> allowedDirections = _getAllowedDirection(flags);
  Map<Directions, int> counts = {for (var dir in allowedDirections) dir: 0};

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      for (var dir in allowedDirections) {
        if (_searchAndMark(matrix, markerMatrix, searchText, i, j, dir.dx, dir.dy)) {
          counts[dir] = (counts[dir] ?? 0) + 1;
        }
      }
    }
  }

  return WordSearchResult(counts, markerMatrix);
}

bool _searchAndMark(List<List<String>> matrix, List<List<int>> markerMatrix, String word, int x, int y, int dx, int dy) {
  int rows = matrix.length;
  int cols = matrix[0].length;

  // Prüfe, ob das Wort in der angegebenen Richtung passt
  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;

    if (nx < 0 || ny < 0 || nx >= rows || ny >= cols || matrix[nx][ny] != word[k]) {
      return false;
    }
  }

  // Bestimme die Markierungsnummer basierend auf der Richtung
  int markerValue = (dx == 0 || dy == 0) ?
  (dx == 0 ? 2 : 1) : // Horizontal = 1, Vertikal = 2
  3; // Diagonal = 3

  // Falls das Wort passt, markiere alle seine Positionen in der Marker-Matrix
  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;
    markerMatrix[nx][ny] = markerValue; // Richtungswert setzen
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

String _cleanText(String input, {bool caseSensitive = false}) {
  RegExp regex = RegExp(r'[\p{L}\p{N}]', unicode: true);

  return input
      .split('\n')
      .map((line) => line.split('')
      .where((char) => regex.hasMatch(char))
      .join('')
  )
      .map((line) => caseSensitive ? line : line.toUpperCase()) // Nur Umwandlung bei caseSensitive=false
      .join('\n');
}

List<List<String>> _convertToMatrix(String input) {
  List<String> lines = input.split("\n").map((line) => line.trim()).toList();
  var maxLength = lines.map((line) => line.length).reduce((a, b) => a > b ? a : b);

  return lines
      .map((line) => line.padRight(maxLength, ' ').split("")) // fill space
      .toList();
}