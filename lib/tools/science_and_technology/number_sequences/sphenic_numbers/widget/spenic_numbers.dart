import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_checknumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_containsdigits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_digits.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_nthnumber.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_range.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/widget/numbersequences_from_to.dart';


class NumberSequenceSphenicNumbersCheckNumber extends NumberSequenceCheckNumber {
  const NumberSequenceSphenicNumbersCheckNumber({super.key}) : super(mode: NumberSequencesMode.SPHENIC, maxIndex: 10000);
}

class NumberSequenceSphenicNumbersDigits extends NumberSequenceDigits {
  const NumberSequenceSphenicNumbersDigits({super.key}) : super(mode: NumberSequencesMode.SPHENIC, maxDigits: 5);
}

class NumberSequenceSphenicNumbersFromTo extends NumberSequenceFromTo {
  const NumberSequenceSphenicNumbersFromTo({super.key}) : super(mode: NumberSequencesMode.SPHENIC, maxIndex: 51382);
}

class NumberSequenceSphenicNumbersRange extends NumberSequenceRange {
  const NumberSequenceSphenicNumbersRange({super.key}) : super(mode: NumberSequencesMode.SPHENIC, maxIndex: 10000);
}

class NumberSequenceSphenicNumbersNthNumber extends NumberSequenceNthNumber {
  const NumberSequenceSphenicNumbersNthNumber({super.key}) : super(mode: NumberSequencesMode.SPHENIC, maxIndex: 10000);
}

class NumberSequenceSphenicNumbersContainsDigits extends NumberSequenceContainsDigits {
  const NumberSequenceSphenicNumbersContainsDigits({super.key}) : super(mode: NumberSequencesMode.SPHENIC, maxIndex: 10000);
}
