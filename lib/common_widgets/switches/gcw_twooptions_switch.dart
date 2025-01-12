import 'package:flutter/material.dart';
import 'package:gc_wizard/application/i18n/logic/app_localizations.dart';
import 'package:gc_wizard/application/theme/theme.dart';
import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/common_widgets/gcw_text.dart';

enum GCWSwitchPosition { left, right }

class GCWTwoOptionsSwitch extends StatefulWidget {
  final void Function(GCWSwitchPosition) onChanged;
  final String? title;
  final Object? leftValue;
  final Object? rightValue;
  final GCWSwitchPosition? value;
  final bool alternativeColor;
  final bool notitle;

  const GCWTwoOptionsSwitch({
    Key? key,
    this.title,
    this.leftValue,
    this.rightValue,
    required this.value,
    required this.onChanged,
    this.alternativeColor = false,
    this.notitle = false,
  }) : super(key: key);

  @override
  _GCWTwoOptionsSwitchState createState() => _GCWTwoOptionsSwitchState();
}

class _GCWTwoOptionsSwitchState extends State<GCWTwoOptionsSwitch> {
  late GCWSwitchPosition _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? GCWSwitchPosition.left;
  }

  void _updateValue(GCWSwitchPosition newValue) {
    setState(() {
      _currentValue = newValue;
      widget.onChanged(_currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = themeColors();
    var textStyle = gcwTextStyle();
    if (widget.alternativeColor) {
      textStyle = textStyle.copyWith(color: colors.dialogText());
    }

    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(color: colors.inactive().withAlpha(50)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.notitle)
            GCWText(
              text: widget.title ?? i18n(context, 'common_mode'),
              style: textStyle,
            ),
          const SizedBox(height: 8.0),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12.0),
                _buildOptionButton(
                  context,
                  position: GCWSwitchPosition.left,
                  label: widget.leftValue ?? i18n(context, 'common_encrypt'),
                  alignment: Alignment.centerRight,
                ),
                _buildOptionButton(
                  context,
                  position: GCWSwitchPosition.right,
                  label: widget.rightValue ?? i18n(context, 'common_decrypt'),
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(width: 12.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, {
        required GCWSwitchPosition position,
        required Object label,
        required Alignment alignment,
      }) {
    final isSelected = _currentValue == position;
    final colors = themeColors();
    final backgroundColor = isSelected
        ? colors.checkBoxCheckColor()
        : colors.inactive().withAlpha(50);
    final foregroundColor = isSelected ? colors.dialogText() : colors.mainFont();

    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: position == GCWSwitchPosition.left
                ? const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            )
                : const BorderRadius.only(
              topRight: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),
        onPressed: () => _updateValue(position),
        child: Container(
          alignment: alignment,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            label.toString(),
            style: gcwTextStyle().apply(
              color: isSelected
                  ? colors.dialogText()
                  : null,
            ),
            textAlign: position == GCWSwitchPosition.left
                ? TextAlign.right
                : TextAlign.left
          ),
        ),
      ),
    );
  }
}