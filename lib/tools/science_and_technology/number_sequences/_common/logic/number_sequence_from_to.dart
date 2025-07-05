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

Future<List<BigInt>> calculateFromToAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! GetNumberFromToJobData) return [];

  var data = jobData!.parameters as GetNumberFromToJobData;
  var output = await calculateFromTo(data, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<List<BigInt>> calculateFromTo(GetNumberFromToJobData data, {SendPort? sendAsyncPort}) async {
  List<BigInt> numberList = [];

  if (data.sequence == NumberSequencesMode.FIBONACCI) {
    BigInt pn0 = Zero;
    BigInt pn1 = One;
    BigInt bigIntStart = BigInt.from(data.start);
    BigInt bigIntStop = BigInt.from(data.stop);

    if (pn0 >= bigIntStart && pn1 <= bigIntStop) {
      numberList.add(pn0);
    }

    BigInt current = pn0 + pn1;

    while (current <= bigIntStop) {
      if (current >= bigIntStart) {
        numberList.add(current);
      }
      pn0 = pn1;
      pn1 = current;
      current = pn0 + pn1;

      if (pn0 > bigIntStop && pn1 > bigIntStop && current > bigIntStop) break;
    }
  } else {
    List<String> sequenceList = getSequenceList(data.sequence);

    for (String numberStr in sequenceList) {
      BigInt number = BigInt.parse(numberStr);
      if (number >= BigInt.from(data.start) && number <= BigInt.from(data.stop)) {
        numberList.add(number);
      }
    }
  }

  return numberList;
}