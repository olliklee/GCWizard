import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_output.dart';
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

  String _currentGrid = '';
  String _currentSearchWord = '';
  final Set<SearchFlags> _currentSearchOptions = {
    SearchFlags.HORIZONTAL,
    SearchFlags.VERTICAL,
    SearchFlags.DIAGONAL,
  };

  var _currentOptionsExpanded = false;

  List<List<int>> _markerMatrix = [];
  List<List<String>> _inputMatrix = [];
  Map<Directions, int> _countsPerDirection = {};
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentGrid);
    _wordController = TextEditingController(text: _currentSearchWord);
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
            _currentGrid = text;
            _calcOutput();
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
            _currentSearchWord = text;
            _calcOutput();
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
        _showOnOffSwitch('word_search_horizontal', SearchFlags.HORIZONTAL),
        _showOnOffSwitch('word_search_vertical', SearchFlags.VERTICAL),
        _showOnOffSwitch('word_search_diagonal', SearchFlags.DIAGONAL),
        _showOnOffSwitch('common_case_sensitive', SearchFlags.CASESENSITIVE),
      ]),
    );
  }

  Widget _showOnOffSwitch(String label, SearchFlags flag) {
    return GCWOnOffSwitch(
      title: i18n(context, label),
      value: _currentSearchOptions.contains(flag),
      onChanged: (value) {
        setState(() {
          (value)
              ? _currentSearchOptions.add(flag)
              : _currentSearchOptions.remove(flag);
          _calcOutput();
        });
      },
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
    if (_currentGrid.isEmpty || _currentSearchWord.isEmpty) return;

    var result = wordCountMatrix(_currentGrid, _currentSearchWord, flags: _currentSearchOptions);
    _markerMatrix = result.markerMatrix;
    _inputMatrix = result.inputMatrix;
    _countsPerDirection = result.counts;
    _totalCount = result.sumTotal;
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
    var textMatrix = _inputMatrix/*_buildRtfOutput()*/;
    var directionsCountList =
        _countsPerDirection.entries.map((entry) => [entry.key.name, entry.value]).toList();

    return GCWDefaultOutput(
      trailing: Row(
        children: <Widget>[
          GCWIconButton(
            iconColor: themeColors().mainFont(),
            size: IconButtonSize.SMALL,
            icon: Icons.content_copy,
            onPressed: () {
              insertIntoGCWClipboard(context, textMatrix.join('\n'));
            },
          ),
        ],
      ),
      child: Column(
        children: [
          GCWOutput(
              child: '${i18n(context, 'word_count_matrix_occurences')}: $_totalCount',
              copyText: '$_totalCount'),
          GCWColumnedMultilineOutput(data: directionsCountList, copyColumn: 1,),
          // RichText(
          //   textAlign: TextAlign.center,
          //   text: TextSpan(children: textMatrix, style: gcwTextStyle()),
          // ),

        ],
      ),
    );
  }

  List<TextSpan> _buildRtfOutput() {
    List<TextSpan> textSpans = [];

    // Prüfen, ob der Eingabetext leer ist oder die Matrix nur Nullen enthält
    if (_currentGrid.isEmpty || _markerMatrix.every((row) => row.every((value) => value == 0))) {
      return textSpans;
    }

    String currentText = '';
    Color lastColor = _getTextColorValue(0); // Standardfarbe

    for (int row = 0; row < _currentGrid.length; row++) {
      for (int col = 0; col < _currentGrid[row].length; col++) {
        String char = _currentGrid[row][col]; // Aktuelles Zeichen
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
