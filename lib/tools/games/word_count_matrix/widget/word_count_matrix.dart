import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_button.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_iconbutton.dart';
import 'package:gc_wizard/common_widgets/clipboard/gcw_clipboard.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/dropdowns/gcw_dropdown.dart';
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
  late TextEditingController _wordsController;

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
  Map<Directions, int> _countsPerDirection = {};

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(text: _currentInput);
    _wordsController = TextEditingController(text: _currentWord);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _wordsController.dispose();
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
        controller: _wordsController,
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
                _calcOutputFillGapMode();
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
                _countsPerDirection = [];
              });
            },
          ),
        ),
      ),
    ]);
  }

  void _calcOutput() {
    _markerMatrix = wordCountMatrix(_currentInput, _currentWord, flags: _currentSearchDirection).counts;
    _countsPerDirection = normalizeAndSplitInputForView(_currentInput);
    setState(() {});
  }

  void _deleteMarkedLetters() {
    if (_countsPerDirection.isEmpty) return;
    if (_markerMatrix.isEmpty) return;
    _countsPerDirection = fillSpaces(_countsPerDirection.join('\r\n'), _markerMatrix, _currentFillGapMode);
    _markerMatrix = searchWordList(_countsPerDirection.join('\r\n'), '', 0, noSpaces: false);
    setState(() {});
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
        text: TextSpan(children: _buildRtfOutput(_countsPerDirection, _markerMatrix), style: gcwTextStyle()),
      ),
    );
  }

  List<TextSpan> _buildRtfOutput(List<String> text, List<Uint8List> founds) {
    var textSpan = <TextSpan>[];

    if (text.isEmpty || text.first.isEmpty || founds.isEmpty || founds.first.isEmpty) return textSpan;
    var lastColor = _getTextColorValue(founds.first.first);
    var actText = '';

    for (var row = 0; row < text.length; row++) {
      if (row > 0) actText += '\n';
      for (var column = 0; column < text[row].length; column++) {
        var actColor = lastColor;
        if (founds.length > row && founds[row].length > column) {
          actColor = _getTextColorValue(founds[row][column]);
        }
        var lastEntry = (row == text.length - 1 && column == text[row].length - 1);
        if (lastEntry || actColor != lastColor) {
          if (lastEntry) {
            if (actColor != lastColor) {
              textSpan.add(_createTextSpan(actText, lastColor));
              actText = '';
              lastColor = actColor;
            }
            actText += text[row][column] + ' ';
          }

          textSpan.add(_createTextSpan(actText, lastColor));
          actText = '';
          lastColor = actColor;
        }
        actText += text[row][column] + ' ';
      }
    }
    return textSpan;
  }

  TextSpan _createTextSpan(String text, int color) {
    switch (color) {
      case 1:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.red));
      case 2:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.green));
      case 3:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.yellow[700]));
      case 4:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.blue));
      case 5:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.brown));
      case 6:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.orange));
      case 7:
        return TextSpan(text: text, style: gcwMonotypeTextStyle().copyWith(color: Colors.deepPurple));
      default:
        return TextSpan(text: text, style: gcwMonotypeTextStyle());
    }
  }
}
