part of 'package:gc_wizard/application/theme/theme_colors.dart';

class _ThemeColorsLightAccessible extends ThemeColors {
  static const _creme = Color(0xFFF2F2EB); // Etwas dunkler für mehr Kontrast mit Weiß
  static const _darkGray = Color(0xFF303030); // Dunkleres Grau für Textlesbarkeit
  static const _gray = Color(0xFF7A7A7A); // Etwas dunkler für Kontraststeigerung
  static const _lightGray = Color(0xFFCCCCCC); // Leicht abgedunkelt für bessere Differenzierung

  @override
  ThemeData base() {
    return ThemeData.light();
  }

  @override
  Color secondary() {
    return Colors.deepOrangeAccent; // Sättigung für bessere Erkennbarkeit
  }

  @override
  Color focused() {
    return Colors.tealAccent.shade700; // Kräftigeres Türkis für Sichtbarkeit
  }

  @override
  Color inactive() {
    return Colors.grey.shade600; // Dunkleres Grau für bessere Erkennbarkeit
  }

  @override
  Color inputBackground() {
    return Colors.white;
  }

  @override
  Color mainFont() {
    return Colors.black;
  }

  @override
  Color outputListOddRows() {
    return _lightGray;
  }

  @override
  Color dialog() {
    return Colors.orangeAccent.shade700; // Sattere Akzentfarbe für Dialoge
  }

  @override
  Color dialogText() {
    return Colors.black;
  }

  @override
  Color primaryBackground() {
    return _creme;
  }

  @override
  Color iconImageBackground() {
    return Colors.white;
  }

  @override
  Color textFieldHintText() {
    return _gray; // Dunkleres Grau für mehr Lesbarkeit
  }

  @override
  Color messageBackground() {
    return Colors.white;
  }

  @override
  Color switchThumb1() {
    return _gray;
  }

  @override
  Color switchTrack1() {
    return _lightGray.withOpacity(0.6); // Erhöhte Deckkraft für Lesbarkeit
  }

  @override
  Color switchThumb2() {
    return secondary();
  }

  @override
  Color switchTrack2() {
    return secondary().withOpacity(0.7); // Erhöhte Deckkraft für besseren Kontrast
  }

  @override
  Color checkBoxActiveColor() {
    return _darkGray;
  }

  @override
  Color checkBoxFillColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _lightGray.withOpacity(0.7);
    }
    return _lightGray.withOpacity(0.7);
  }

  @override
  Color checkBoxCheckColor() {
    return secondary();
  }

  @override
  Color checkBoxFocusColor() {
    return secondary().withOpacity(0.7); // Erhöhte Sichtbarkeit im Fokus
  }

  @override
  Color checkBoxHoverColor() {
    return secondary();
  }

  @override
  Color checkBoxOverlayColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return secondary().withOpacity(0.5);
    }
    return secondary().withOpacity(0.7);
  }

  @override
  Color listSubtitle() {
    return _darkGray; // Dunkler für Kontrast zu hellem Hintergrund
  }

  @override
  Color gridBackground() {
    return const Color(0xFFF9F9F9); // Weicherer Hintergrund für Klarheit
  }

  @override
  Color hyperLinkText() {
    return Colors.cyan; // Kräftige Akzentfarbe für Links
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
    return const Color.fromRGBO(70, 180, 0, 1); // Intensiveres Grün
  }

  @override
  Color formulaVariable() {
    return const Color.fromRGBO(255, 160, 0, 1); // Gesättigtes Orange
  }

  @override
  Color formulaMath() {
    return Colors.indigoAccent.shade400; // Hellere Blautöne für besseren Kontrast
  }

  @override
  Color formulaError() {
    return Colors.red.shade700; // Dunklere Rottöne für Sichtbarkeit
  }
}
