import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer.dart';
import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/common_widgets/buttons/gcw_submit_button.dart';
import 'package:gc_wizard/common_widgets/dialogs/gcw_dialog.dart';
import 'package:gc_wizard/common_widgets/dividers/gcw_text_divider.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_columned_multiline_output.dart';
import 'package:gc_wizard/common_widgets/outputs/gcw_default_output.dart';
import 'package:gc_wizard/common_widgets/spinners/gcw_integer_spinner.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class NumberSequenceFromTo extends StatefulWidget {
  final NumberSequencesMode mode;
  final int maxIndex;
  const NumberSequenceFromTo({super.key, required this.mode, required this.maxIndex});

  @override
  _NumberSequenceFromToState createState() => _NumberSequenceFromToState();
}

class _NumberSequenceFromToState extends State<NumberSequenceFromTo> {
  int _currentInputStop = 0;
  int _currentInputStart = 0;

  Widget _currentOutput = const GCWDefaultOutput();
  late TextEditingController _stopController;

  @override
  void initState() {
    super.initState();

    _stopController = TextEditingController(text: _currentInputStop.toString());
  }

  @override
  void dispose() {
    _stopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GCWTextDivider(
          text: i18n(context, NUMBERSEQUENCE_TITLE[widget.mode]!),
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputstart'),
          value: _currentInputStart,
          onChanged: (value) {
            setState(() {
              _currentInputStart = value;
              _currentInputStop = max(_currentInputStart, _currentInputStop);
              _stopController.text = _currentInputStop.toString();
            });
          },
        ),
        GCWIntegerSpinner(
          title: i18n(context, 'numbersequence_inputstop'),
          value: _currentInputStop,
          controller: _stopController,
          min: _currentInputStart,
          max: widget.maxIndex,
          onChanged: (value) {
            setState(() {
              _currentInputStop = value;

            });
          },
        ),
        GCWSubmitButton(onPressed: () {
          int countLines = (_currentInputStop - _currentInputStart).abs();
          setState(() {
            showGCWAlertDialog(
                context,
                i18n(context, 'numbersequence_range_hint_title'),
                i18n(context, 'numbersequence_range_hint_description',parameters: [countLines]),
                    () async {
                      _calculateFromTo();
                }, cancelButton: true);
          });
        }),
        _currentOutput
      ],
    );
  }

  void _calculateFromTo() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: GCW_ASYNC_EXECUTER_INDICATOR_HEIGHT,
            width: GCW_ASYNC_EXECUTER_INDICATOR_WIDTH,
            child: GCWAsyncExecuter<List<BigInt>>(
              isolatedFunction: calculateFromToAsync,
              parameter: _buildJobData,
              onReady: (data) => _showOutput(data),
              isOverlay: true,
            ),
          ),
        );
      },
    );
  }

  Future<GCWAsyncExecuterParameters?> _buildJobData() async {
    return GCWAsyncExecuterParameters(GetNumberFromToJobData(sequence: widget.mode, start: _currentInputStart, stop: _currentInputStop));
  }

  void _showOutput(List<BigInt> output) {
    List<List<String>> columnData = [[i18n(context, 'common_element')]];
    for (int i = 0; i < output.length; i++) {
      BigInt element = output[i];
      columnData.add([element.toString()]);
    }

    _currentOutput = GCWDefaultOutput(child: GCWColumnedMultilineOutput(data: columnData, flexValues: [1, 5], hasHeader: true,));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

}
