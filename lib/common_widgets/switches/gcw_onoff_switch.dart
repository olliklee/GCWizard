import 'package:flutter/material.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
// import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
// import 'package:gc_wizard/application/theme/theme_colors.dart';
// import 'package:gc_wizard/common_widgets/gcw_text.dart';

class GCWOnOffSwitch extends StatefulWidget {
  final void Function(bool) onChanged;
  final String? title;
  final bool? value;
  final bool notitle;
  final List<int> flexValues;
  static const _flexValues = [1, 1, 1];

  const GCWOnOffSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.title,
    this.notitle = false,
    this.flexValues = _flexValues,
  }) : super(key: key);

  @override
  _GCWOnOffSwitchState createState() => _GCWOnOffSwitchState();
}

class _GCWOnOffSwitchState extends State<GCWOnOffSwitch> {
  bool _currentValue = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? false;
  }

  void _toggleCheckbox() {
    setState(() {
      _currentValue = !_currentValue;
      widget.onChanged(_currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = themeColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: widget.flexValues[0] +
                widget.flexValues[1] +
                widget.flexValues[2],
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: _toggleCheckbox,
                  child: Row(
                    children: [
                      const SizedBox(width: 12.0),
                      Checkbox(
                        value: _currentValue,
                        activeColor: colors.checkBoxCheckColor(),
                        checkColor: colors.dialogText(),
                        onChanged: (value) {
                          setState(() {
                            _toggleCheckbox(); // Update the state with the new value
                          });
                        },
                      ),
                      const SizedBox(width: 8.0),
                      Text(widget.title ?? '',
                          style: _currentValue
                              ? gcwTextStyle()
                              : gcwTextStyle()
                              .apply(color: colors.inActive())),
                    ],
                  ),
                ),
                Expanded(flex: widget.flexValues[2], child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
