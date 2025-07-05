part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

class GetNumberRangeJobData{
  final NumberSequencesMode sequence;
  final int start;
  final int stop;

  GetNumberRangeJobData({
    required this.sequence,
    required this.start,
    required this.stop,
  });
}

Future<List<BigInt>> calculateRangeAsync(GCWAsyncExecuterParameters? jobData) async {
  if (jobData?.parameters is! GetNumberRangeJobData) return [];

  var data = jobData!.parameters as GetNumberRangeJobData;
  var output = await calculateRange(data, sendAsyncPort: jobData.sendAsyncPort);

  jobData.sendAsyncPort?.send(output);

  return output;
}

Future<List<BigInt>> calculateRange(GetNumberRangeJobData data,
    {SendPort? sendAsyncPort}) async {

  List<BigInt> numberList = [];
  List<String> sequenceList = <String>[];

  var numberSequenceFunction = _getNumberSequenceFunction(data.sequence);
  if (numberSequenceFunction != null) {
    for (int i = data.start; i <= data.stop; i++) {
      numberList.add(numberSequenceFunction(i));
    }
  } else if (data.sequence == NumberSequencesMode.FIBONACCI) {
    numberList = fibonacciGenerator(data.start, data.stop).toList();
  } else if (data.sequence == NumberSequencesMode.PELL) {
    numberList = pellGenerator(data.start, data.stop).toList();
  } else if (data.sequence == NumberSequencesMode.PELL_LUCAS) {
    numberList = pellLucasGenerator(data.start, data.stop).toList();
  } else if (data.sequence == NumberSequencesMode.LUCAS) {
    numberList = lucasGenerator(data.start, data.stop).toList();
  } else if (data.sequence == NumberSequencesMode.RECAMAN) {
    numberList = recamanGenerator(data.start, data.stop).toList();
  } else if (data.sequence == NumberSequencesMode.FACTORIAL) {
    numberList = factorialGenerator(data.start, data.stop).toList();
  } else {
    sequenceList = getSequenceList(data.sequence);

    for (int i = data.start; i <= data.stop; i++) {
      numberList.add(BigInt.parse(sequenceList[i]));
    }
  }

  return numberList;
}