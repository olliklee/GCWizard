import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/gcw_expandable.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';
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
  var _currentShowGridExpanded = false;

  Map<Directions, int> _countsPerDirection = {};
  int _totalCount = 0;
  late List<List<String>> _cleanedGrid;

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
      if (_currentSearchWord.isNotEmpty && _currentGrid.isNotEmpty)
        Column(
          children: [
            _buildOptionWidget(),
            _buildShowGridWidget(),
            _buildOutput(),
          ],
        ),


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

  Widget _buildShowGridWidget() {
    _calcOutput();
    return GCWExpandableTextDivider(
      text: i18n(context, 'word_count_matrix_show_grid'),
      suppressTopSpace: false,
      expanded: _currentShowGridExpanded,
      onChanged: (value) {
        setState(() {
          _currentShowGridExpanded = value;
        });
      },
      child: GCWText(
        text: _gridToText(_cleanedGrid),
        align: Alignment.center,
        style: gcwMonotypeTextStyle(),
      ),
    );
  }

  Widget _showOnOffSwitch(String label, SearchFlags flag) {
    return GCWOnOffSwitch(
      title: i18n(context, label),
      value: _currentSearchOptions.contains(flag),
      onChanged: (value) {
        setState(() {
          (value) ? _currentSearchOptions.add(flag) : _currentSearchOptions.remove(flag);
          _calcOutput();
        });
      },
    );
  }

  void _calcOutput() {
    bool hasSearchDirection = _currentSearchOptions
        .any((flag) => flag == SearchFlags.HORIZONTAL || flag == SearchFlags.VERTICAL || flag == SearchFlags.DIAGONAL);

    if (!hasSearchDirection) {
      setState(() {
        _countsPerDirection = {};
        _totalCount = 0;
      });
      return;
    }

    var result = wordCountMatrix(_currentGrid, _currentSearchWord, flags: _currentSearchOptions);
    _cleanedGrid = result.cleanedInput;

    setState(() {
      if (_currentSearchWord.length > 1) {
        _countsPerDirection = result.counts;
        _totalCount = result.sumTotal;
      } else {
        _countsPerDirection = {};
        _totalCount = result.sumTotal ~/ 8; // any direction counts only once
      }
    });
  }

  Widget _buildOutput() {
    var directionsCountList = _countsPerDirection.entries
        .where((entry) => entry.value > 0)
        .map((entry) => [entry.key.directionArrow, entry.value])
        .toList();

    if (_totalCount == 0) return Container();
    return GCWDefaultOutput(
      child: Column(
        children: [
          GCWOutput(child: '${i18n(context, 'word_count_matrix_occurences')}: $_totalCount', copyText: '$_totalCount'),
          GCWColumnedMultilineOutput(
            data: directionsCountList,
            copyColumn: 1,
          ),
        ],
      ),
    );
  }

  String _gridToText(List<List<String>> matrix) {
    return matrix.map((row) => row.join(' ')).join('\n');
  }
}
