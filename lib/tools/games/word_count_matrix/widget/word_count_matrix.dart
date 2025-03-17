import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/switches/gcw_onoff_switch.dart';
import 'package:gc_wizard/common_widgets/textfields/gcw_textfield.dart';
import 'package:gc_wizard/tools/games/word_count_matrix/logic/word_count_matrix.dart';

class WordCountMatrix extends StatefulWidget {
  const WordCountMatrix({Key? key}) : super(key: key);

  @override
  _WordCountMatrixState createState() => _WordCountMatrixState();
}

class _WordCountMatrixState extends State<WordCountMatrix> {
  late TextEditingController _inputController;
  late TextEditingController _wordController;

  String _currentInput = '';
  String _currentWord = '';
  List<SearchFlags> _currentSearchDirection = [
    SearchFlags.HORIZONTAL,
    SearchFlags.VERTICAL,
    SearchFlags.DIAGONAL,
    SearchFlags.IGNORECASE,
  ];

  var _currentOptionsExpanded = false;

  List<List<int>> _markerMatrix = [];
  List<List<String>> _inputMatrix = [];
  Map<Directions, int> _countsPerDirection = {};
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _wordController = TextEditingController(text: _currentWord);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      GCWTextDivider(
        text: i18n(context, 'word_search_input'),
      ),
      GCWTextField(
        controller: _inputController,
        style: gcwMonotypeTextStyle(),
        onChanged: (text) {
          setState(() {
            _currentInput = text;
          });
        },
      ),
      GCWTextDivider(
        text: i18n(context, 'common_search'),
      ),
      GCWTextField(
        controller: _wordController,
        onChanged: (text) {
          setState(() {
            _currentWord = text;
          });
        },
      ),
      _buildOptionWidget(),
      _buildButtonRow(),
      _buildOutput(),
    ]);
  }

  Widget _buildOptionWidget() {
    return GCWExpandableTextDivider(
      text: i18n(context, 'common_options'),
      suppressTopSpace: false,
      expanded: _currentOptionsExpanded,
      onChanged: (value) {
        setState(() {
          _currentOptionsExpanded = value;
        });
      },
      child: Column(children: <Widget>[
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_horizontal'),
          value: _currentSearchDirection.contains(SearchFlags.HORIZONTAL),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? [..._currentSearchDirection, SearchFlags.HORIZONTAL]
                  : _currentSearchDirection.where((flag) => flag != SearchFlags.HORIZONTAL).toList();
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_vertical'),
          value:_currentSearchDirection.contains(SearchFlags.VERTICAL),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? [..._currentSearchDirection, SearchFlags.VERTICAL]
                  : _currentSearchDirection.where((flag) => flag != SearchFlags.VERTICAL).toList();
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_diagonal'),
          value: _currentSearchDirection.contains(SearchFlags.DIAGONAL),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? [..._currentSearchDirection, SearchFlags.DIAGONAL]
                  : _currentSearchDirection.where((flag) => flag != SearchFlags.DIAGONAL).toList();
            });
          },
        ),
        GCWOnOffSwitch(
          title: i18n(context, 'word_search_reverse'),
          value: _currentSearchDirection.contains(SearchFlags.IGNORECASE),
          onChanged: (value) {
            setState(() {
              _currentSearchDirection = value
                  ? [..._currentSearchDirection, SearchFlags.IGNORECASE]
                  : _currentSearchDirection.where((flag) => flag != SearchFlags.IGNORECASE).toList();
            });
          },
        ),
      ]),
    );
  }

  Widget _buildButtonRow() {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
          child: GCWButton(
            text: _countsPerDirection.isEmpty ? i18n(context, 'common_search') : i18n(context, 'word_search_search_more'),
            onPressed: () {
              setState(() {
                _calcOutput();
              });
            },
          ),
      )),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: DEFAULT_MARGIN, right: DEFAULT_MARGIN),
          child: GCWButton(
            text: i18n(context, 'word_search_delete_letters'),
            onPressed: () {
              setState(() {
                _deleteMarkedLetters();
              });
            },
          ),
      )),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(right: DEFAULT_MARGIN),
          child: GCWButton(
            text: i18n(context, 'common_reset'),
            onPressed: () {
              setState(() {
                _markerMatrix = [];
                _countsPerDirection = {};
              });
            },
          ),
        ),
      ),
    ]);
  }

  void _calcOutput() {
    var result = wordCountMatrix(_currentInput, _currentWord, flags: _currentSearchDirection);
    _markerMatrix = result.markerMatrix;
    _inputMatrix = result.inputMatrix;
    _countsPerDirection = result.counts;
    _totalCount = result.sumTotal;
    setState(() {});
  }

  void _deleteMarkedLetters() {
    if (_totalCount == 0 || _markerMatrix.isEmpty) return;

    for (int row = 0; row < _inputMatrix.length; row++) {
      for (int col = 0; col < _inputMatrix[row].length; col++) {
        if (_markerMatrix[row][col] != 0) {
          _inputMatrix[row][col] = ' '; // Ersetze markierte Zeichen durch ein Leerzeichen
        }
      }
    }

    setState(() {
      _calcOutput();
    });
  }

  Widget _buildOutput() {
    return GCWDefaultOutput(
      trailing: Row(
        children: <Widget>[
          GCWIconButton(
            iconColor: themeColors().mainFont(),
            size: IconButtonSize.SMALL,
            icon: Icons.content_copy,
            onPressed: () {
              insertIntoGCWClipboard(context, _countsPerDirection.join('\n'));
            },
          ),
        ],
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: _buildRtfOutput(), style: gcwTextStyle()),
      ),
    );
  }

  List<TextSpan> _buildRtfOutput() {
    List<TextSpan> textSpans = [];

    // Prüfen, ob der Eingabetext leer ist oder die Matrix nur Nullen enthält
    if (_currentInput.isEmpty || _markerMatrix.every((row) => row.every((value) => value == 0))) {
      return textSpans;
    }

    String currentText = '';
    Color lastColor = _getTextColorValue(0); // Standardfarbe

    for (int row = 0; row < _currentInput.length; row++) {
      for (int col = 0; col < _currentInput[row].length; col++) {
        String char = _currentInput[row][col]; // Aktuelles Zeichen
        Color color = _getTextColorValue(_markerMatrix[row][col]); // Farbe aus der MarkerMatrix holen

        // Falls sich die Farbe ändert, füge den bisherigen Text hinzu
        if (color != lastColor && currentText.isNotEmpty) {
          textSpans.add(_createTextSpan(currentText, lastColor));
          currentText = '';
        }

        currentText += char; // Zeichen zum aktuellen Text hinzufügen
        lastColor = color;
      }
      currentText += '\n'; // Zeilenumbruch nach jeder Zeile
    }

    // Falls noch Text übrig ist, den letzten TextSpan hinzufügen
    if (currentText.isNotEmpty) {
      textSpans.add(_createTextSpan(currentText, lastColor));
    }

    return textSpans;
  }

  TextSpan _createTextSpan(String text, Color color) {
    return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: color));
  }

  Color _getTextColorValue(int value) {
    switch (value) {
      case 1: return Colors.red;
      case 2: return Colors.green;
      case 3: return Colors.deepOrangeAccent;
      case 4: return Colors.blue;
      case 5: return Colors.brown;
      case 6: return Colors.orange;
      case 7: return Colors.purple;
      default: return themeColors().mainFont();
    }
  }
}
