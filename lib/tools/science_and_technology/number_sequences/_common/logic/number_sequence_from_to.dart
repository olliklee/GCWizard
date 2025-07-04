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

Future<List<BigInt>> calculateFromTo(GetNumberFromToJobData data, {SendPort? sendAsyncPort}) async {
  List<BigInt> numberList = [];

  var possibleModes = [
    NumberSequencesMode.PRIMES,
    NumberSequencesMode.MERSENNE_PRIMES,
    NumberSequencesMode.MERSENNE_EXPONENTS,
    NumberSequencesMode.PERFECT_NUMBERS,
    NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS,
    NumberSequencesMode.SUPERPERFECT_NUMBERS,
    NumberSequencesMode.SUBLIME_NUMBERS,
    NumberSequencesMode.WEIRD_NUMBERS,
    NumberSequencesMode.LYCHREL,
    NumberSequencesMode.PERMUTABLE_PRIMES,
    NumberSequencesMode.MEMORABLE_PRIMES,
    NumberSequencesMode.LUCKY_NUMBERS,
    NumberSequencesMode.HAPPY_NUMBERS,
    NumberSequencesMode.BUSY_BEAVER,
    NumberSequencesMode.CARMICHAEL,
    NumberSequencesMode.HARSHAD,
    NumberSequencesMode.TAXICAB,
    NumberSequencesMode.SPHENIC,
    NumberSequencesMode.BELL,
    NumberSequencesMode.LONELY,
    NumberSequencesMode.PALINDROME_PRIMES
  ];

  // if (possibleModes.contains(data.sequence)) {
    List<String> sequenceList = getSequenceList(data.sequence);
    for (String numberStr in sequenceList) {
      BigInt number = BigInt.parse(numberStr);
      if (number >= BigInt.from(data.start) && number <= BigInt.from(data.stop)) {
        numberList.add(number);
      }
    // }
  }
  return numberList;
}

void main() async {
  var jobData = GetNumberFromToJobData(
    sequence: NumberSequencesMode.SPHENIC,
    start: 10,
    stop: 300,
  );
  var list = await calculateFromTo(jobData);
  print(list);
}
