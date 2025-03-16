enum SearchFlags {
  HORIZONTAL,
  VERTICAL,
  DIAGONAL,
}

enum Direction {
  N(-1, 0), // Oben
  S(1, 0), // Unten
  E(0, 1), // Rechts
  W(0, -1), // Links
  NE(-1, 1), // Diagonal oben rechts
  SE(1, 1), // Diagonal unten rechts
  SW(1, -1), // Diagonal unten links
  NW(-1, -1); // Diagonal oben links

  final int dx;
  final int dy;

  const Direction(this.dx, this.dy);
}

void main() {
  var matrixText = '''MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAAA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX''';

  String word = "XMAS";

  Map<Direction, int> counts = wordCountMatrix(matrixText, word, flags: [SearchFlags.HORIZONTAL]);

  print("Vorkommen von '$word' in jeder Richtung:");
  counts.forEach((direction, count) {
    print("${direction.name}: $count-mal");
  });
  int totalCount = counts.values.reduce((a, b) => a + b);

  print("Insgesamt: $totalCount");
}

Map<Direction, int> wordCountMatrix(
  String matrixText,
  String word, {
  List<SearchFlags> flags = const [SearchFlags.HORIZONTAL, SearchFlags.VERTICAL, SearchFlags.DIAGONAL],
}) {
  var matrix = _convertToMatrix(matrixText);

  int rows = matrix.length;
  int cols = matrix[0].length;

  List<Direction> allowedDirections = _getAllowedDirection(flags);

  Map<Direction, int> counts = {for (var dir in allowedDirections) dir: 0};

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      for (var dir in allowedDirections) {
        if (_searchFrom(matrix, word, i, j, dir.dx, dir.dy)) {
          counts[dir] = (counts[dir] ?? 0) + 1;
        }
      }
    }
  }

  return counts;
}

bool _searchFrom(List<List<String>> matrix, String word, int x, int y, int dx, int dy) {
  int rows = matrix.length;
  int cols = matrix[0].length;

  for (int k = 0; k < word.length; k++) {
    int nx = x + k * dx;
    int ny = y + k * dy;

    if (nx < 0 || ny < 0 || nx >= rows || ny >= cols || matrix[nx][ny] != word[k]) {
      return false;
    }
  }

  return true;
}

List<Direction> _getAllowedDirection(List<SearchFlags> flags) {
  List<Direction> allowedDirections = [];

  if (flags.contains(SearchFlags.HORIZONTAL)) {
    allowedDirections.addAll([Direction.E, Direction.W]);
  }
  if (flags.contains(SearchFlags.VERTICAL)) {
    allowedDirections.addAll([Direction.N, Direction.S]);
  }
  if (flags.contains(SearchFlags.DIAGONAL)) {
    allowedDirections.addAll([Direction.SE, Direction.NE, Direction.SW, Direction.NW]);
  }
  return allowedDirections;
}

List<List<String>> _convertToMatrix(String input) {
  List<String> lines = input.split("\n").map((line) => line.trim()).toList();

  int maxLength = lines.map((line) => line.length).reduce((a, b) => a > b ? a : b);

  return lines
      .map((line) => line.padRight(maxLength, ' ').split("")) // fill space
      .toList();
}
