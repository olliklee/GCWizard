part of 'package:gc_wizard/application/theme/theme_colors.dart';

class _ThemeColorsDarkAccessible extends ThemeColors {
  static const _lightGray = Color(0xFFD8D8D8);
  static const _gray = Color(0x80D8D8D8); // Erhöhte Deckkraft für besseren Kontrast
  static const _darkGray = Color(0xFF1E1E24); // Dunklere Farbe für Kontraststeigerung

  @override
  ThemeData base() {
    return ThemeData.dark();
  }

  @override
  Color secondary() {
    return Colors.deepOrangeAccent; // Heller und satter für besseren Kontrast
  }

  @override
  Color focused() {
    return Colors.tealAccent.shade400; // Gut sichtbares Grün mit hohem Kontrast
  }

  @override
  Color inactive() {
    return Colors.grey.shade600; // Dunkleres Grau für besseren Kontrast
  }

  @override
  Color inputBackground() {
    return _darkGray;
  }

  @override
  Color mainFont() {
    return Colors.white;
  }

  @override
  Color outputListOddRows() {
    return _gray;
  }

  @override
  Color dialog() {
    return Colors.orangeAccent.shade700; // Dunklere Akzentfarbe für Kontrast
  }

  @override
  Color dialogText() {
    return Colors.white; // Höherer Kontrast gegen dunkleren Hintergrund
  }

  @override
  Color primaryBackground() {
    return const Color(0xFF282828); // Dezent dunkler für Kontrast zu Text
  }

  @override
  Color iconImageBackground() {
    return Colors.white;
  }

  @override
  Color textFieldHintText() {
    return const Color.fromRGBO(200, 200, 200, 1.0); // Helleres Grau für bessere Lesbarkeit
  }

  @override
  Color messageBackground() {
    return _darkGray;
  }

  @override
  Color switchThumb1() {
    return _lightGray;
  }

  @override
  Color switchTrack1() {
    return _darkGray;
  }

  @override
  Color switchThumb2() {
    return secondary();
  }

  @override
  Color switchTrack2() {
    return secondary().withOpacity(0.7); // Erhöhte Deckkraft für Sichtbarkeit
  }

  @override
  Color checkBoxActiveColor() {
    return _lightGray;
  }

  @override
  Color checkBoxFillColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _darkGray;
    }
    return _darkGray;
  }

  @override
  Color checkBoxCheckColor() {
    return Colors.yellowAccent; // Auffällige Farbe für bessere Erkennbarkeit
  }

  @override
  Color checkBoxFocusColor() {
    return secondary().withOpacity(0.7);
  }

  @override
  Color checkBoxHoverColor() {
    return secondary().withOpacity(0.8);
  }

  @override
  Color checkBoxOverlayColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return secondary().withOpacity(0.5);
    }
    return secondary().withOpacity(0.7); // Leicht erhöhte Sichtbarkeit
  }

  @override
  Color listSubtitle() {
    return Colors.grey.shade300; // Helleres Grau für besseren Kontrast
  }

  @override
  Color gridBackground() {
    return const Color.fromARGB(255, 70, 70, 70); // Etwas dunkler für Klarheit
  }

  @override
  Color hyperLinkText() {
    return Colors.cyanAccent; // Auffälligere Farbe für Links
  }

  @override
  Color textFieldFill() {
    return Colors.black;
  }

  @override
  Color textFieldFillText() {
    return Colors.white;
  }

  @override
  Color formulaNumber() {
    return Colors.limeAccent; // Auffällig und gut sichtbar
  }

  @override
  Color formulaVariable() {
    return Colors.amberAccent.shade400; // Sättigung erhöht für Kontrast
  }

  @override
  Color formulaMath() {
    return Colors.lightBlueAccent.shade400; // Deutlicherer Blau-Ton für Abgrenzung
  }

  @override
  Color formulaError() {
    return Colors.redAccent.shade700; // Sättigung für bessere Erkennbarkeit
  }
}
