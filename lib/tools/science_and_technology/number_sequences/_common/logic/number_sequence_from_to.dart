part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class GetNumberFromToJobData {
  final NumberSequencesMode sequence;
  final int start;
  final int stop;

  GetNumberFromToJobData({
    required this.sequence,
    required this.start,
    required this.stop,
  });
}

Future<List<BigInt>> calculateFromToAsync(GetNumberFromToJobData data, {SendPort? sendAsyncPort}) async {
  List<BigInt> numberList = [];

    List<String> sequenceList = getSequenceList(data.sequence);
    for (String numberStr in sequenceList) {
      BigInt number = BigInt.parse(numberStr);
      if (number >= BigInt.from(data.start) && number <= BigInt.from(data.stop)) {
        numberList.add(number);
      }
  }
  return numberList;
}