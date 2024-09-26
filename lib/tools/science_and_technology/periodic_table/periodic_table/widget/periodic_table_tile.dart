import 'package:flutter/material.dart';
import 'package:gc_wizard/application/navigation/no_animation_material_page_route.dart';
import 'package:gc_wizard/application/tools/widget/gcw_tool.dart';

// import 'package:gc_wizard/application/theme/theme.dart';
// import 'package:gc_wizard/application/theme/theme_colors.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/_common/logic/periodic_table.dart';
import 'package:gc_wizard/tools/science_and_technology/periodic_table/periodic_table_data_view/widget/periodic_table_data_view.dart';

// Widget für Kachel im Periodensystem
enum ChemicalStateColor {
  lightYellow(Colors.yellowAccent),
  lightCyan(Colors.cyanAccent),
  lightGreen(Colors.lightGreenAccent),
  lightBlue(Colors.lightBlueAccent),
  lightPink(Colors.pinkAccent),
  lightOrange(Colors.orangeAccent),
  lightPurple(Colors.purpleAccent),
  lightTeal(Colors.tealAccent),
  lightLime(Colors.limeAccent),
  lightAmber(Colors.amberAccent),
  lightIndigo(Colors.indigoAccent),
  lightMint(Colors.greenAccent),
  lightRed(Colors.redAccent),
  lightViolet(Color(0xFFEE82EE));  // Eigen definierte Farbe (violett)

  final Color color;

  const ChemicalStateColor(this.color);
}

class ElementTile extends StatelessWidget {
  final int atomicNumber;
  final bool border;
  final Color? bgColor;
  final Color? textColor;

  const ElementTile({
    Key? key,
    required this.atomicNumber,
    required this.border,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Berechnung der Kachelgröße basierend auf Bildschirmgröße
    final double tileWidth = MediaQuery.of(context).size.width / 20;
    final double tileHeight = MediaQuery.of(context).size.height / 12;

    return (atomicNumber == 0)
        ? SizedBox(
            width: tileWidth,
            height: tileHeight,
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(NoAnimationMaterialPageRoute<GCWTool>(
                  builder: (context) => GCWTool(
                      tool: PeriodicTableDataView(atomicNumber: atomicNumber),
                      id: 'periodictable_dataview')));
            },
            child: Container(
              width: tileWidth,
              height: tileHeight,
              decoration: BoxDecoration(
                color: bgColor ?? Colors.blueAccent,
                borderRadius: BorderRadius.circular(4.0),
                border:
                    border ? Border.all(color: Colors.black, width: 1.0) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Obere Zeile: Ordnungszahl
                  Text(
                    atomicNumber.toString(),
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Mittleres Element: Elementkürzel
                  Text(
                    atomicNumbersToText(atomicNumber as List<int>),
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
