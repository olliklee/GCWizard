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

  const GCWTwoOptionsSwitch(
      {Key? key,
        this.title,
        this.leftValue,
        this.rightValue,
        required this.value,
        required this.onChanged,
        this.alternativeColor = false,
        this.notitle = false})
      : super(key: key);

  @override
  _GCWTwoOptionsSwitchState createState() => _GCWTwoOptionsSwitchState();
}

class _GCWTwoOptionsSwitchState extends State<GCWTwoOptionsSwitch> {
  @override
  Widget build(BuildContext context) {
    var _currentValue = widget.value ?? GCWSwitchPosition.left;
    ThemeColors colors = themeColors();

    var textStyle = gcwTextStyle();
    if (widget.alternativeColor) textStyle = textStyle.copyWith(color: colors.dialogText());

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: themeColors().inActive().withOpacity(0.2)),
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
                const SizedBox(width: 12.0,),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _currentValue == GCWSwitchPosition.left
                          ? themeColors().checkBoxCheckColor()
                          : themeColors().inActive().withOpacity(0.2),
                      foregroundColor: _currentValue == GCWSwitchPosition.left
                          ? themeColors().dialogText()
                          : themeColors().mainFont(),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0)
                        )
                      )
                    ),
                    onPressed: () {
                      setState(() {
                        _currentValue = GCWSwitchPosition.left;
                        widget.onChanged(_currentValue);
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                          widget.leftValue == null
                          ? i18n(context, 'common_encrypt')
                          : widget.leftValue.toString(),
                      textAlign: TextAlign.right,
                      ),
                    ),
                  )
                ),
                _buildOptionButton(
                  context,
                  position: GCWSwitchPosition.right,
                  label: widget.rightValue ?? i18n(context, 'common_decrypt'),
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: _currentValue == GCWSwitchPosition.right
                            ? themeColors().checkBoxCheckColor()
                            : themeColors().inActive().withOpacity(0.2),
                        foregroundColor: _currentValue == GCWSwitchPosition.right
                            ? themeColors().dialogText()
                            : themeColors().mainFont(),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0)
                            )
                        )
                    ),
                    onPressed: () {
                      setState(() {
                        _currentValue = GCWSwitchPosition.right;
                        widget.onChanged(_currentValue);
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.rightValue == null
                            ? i18n(context, 'common_decrypt')
                            : widget.rightValue.toString(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0,)
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
        : colors.inactive().withOpacity(0.2);
    final foregroundColor = isSelected ? colors.dialogText() : colors.mainFont();

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
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
