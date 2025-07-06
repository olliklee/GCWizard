part of 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence.dart';

final Zero = BigInt.zero;
final One = BigInt.one;
final Two = BigInt.two;
final Three = BigInt.from(3);
final sqrt5 = sqrt(5);
final sqrt2 = sqrt(2);

Iterable<BigInt> fibonacciGenerator(int start, int stop) sync* {
  BigInt pn0 = Zero;
  BigInt pn1 = One;
  BigInt number = Zero;
  int index = 0;

  while (index <= stop) {
    if (index == 0) {
      number = Zero;
    } else if (index == 1) {
      number = One;
    } else {
      number = pn0 + pn1;
      pn0 = pn1;
      pn1 = number;
    }

    if (index >= start) {
      yield number;
    }

    index++;
  }
}

Iterable<BigInt> factorialGenerator(int start, int stop) sync* {
  BigInt number = One;
  int index = 0;

  while (index <= stop) {
    if (index == 0 || index == 1) {
      number = One;
    } else {
      number *= BigInt.from(index);
    }

    if (index >= start) {
      yield number;
    }

    index++;
  }
}

Iterable<BigInt> lucasGenerator(int start, int stop) sync* {
  BigInt pn0 = BigInt.two;
  BigInt pn1 = One;
  BigInt number = Zero;
  int index = 0;

  while (index <= stop) {
    if (index == 0) {
      number = pn0;
    } else if (index == 1) {
      number = pn1;
    } else {
      number = pn0 + pn1;
      pn0 = pn1;
      pn1 = number;
    }

    if (index >= start) {
      yield number;
    }

    index++;
  }
}

Iterable<BigInt> pellGenerator(int start, int stop) sync* {
  BigInt pn0 = Zero;
  BigInt pn1 = One;
  BigInt number = Zero;
  int index = 0;

  while (index <= stop) {
    if (index == 0) {
      number = pn0;
    } else if (index == 1) {
      number = pn1;
    } else {
      number = BigInt.two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
    }

    if (index >= start) {
      yield number;
    }

    index++;
  }
}

Iterable<BigInt> pellLucasGenerator(int start, int stop) sync* {
  BigInt pn0 = BigInt.two;
  BigInt pn1 = BigInt.two;
  BigInt number = Zero;
  int index = 0;

  while (index <= stop) {
    if (index == 0) {
      number = pn0;
    } else if (index == 1) {
      number = pn1;
    } else {
      number = BigInt.two * pn1 + pn0;
      pn0 = pn1;
      pn1 = number;
    }

    if (index >= start) {
      yield number;
    }

    index++;
  }
}

Iterable<BigInt> recamanGenerator(int start, int stop) sync* {
  final List<BigInt> recamanSequence = <BigInt>[];
  BigInt current = Zero;
  BigInt index = One;

  recamanSequence.add(Zero);

  while (index <= BigInt.from(stop)) {
    BigInt number;

    if (index == Zero) {
      number = current;
    } else if ((current - index) > Zero && !recamanSequence.contains(current - index)) {
      number = current - index;
    } else {
      number = current + index;
    }

    recamanSequence.add(number);
    current = number;

    if (index >= BigInt.from(start)) {
      yield number;
    }

    index += One;
  }
}

BigInt _getBinomialCoefficient(int n, int k) {
  if (n == k) {
    return Zero;
  } else {
    return _getfactorial(n) ~/ _getfactorial(k) ~/ _getfactorial(n - k);
  }
}

BigInt _getCatalan(int n) {
  if (n == 0) return One;

  try {
    return _getBinomialCoefficient(2 * n, n) ~/ (BigInt.from(n) + One);
  } catch (e) {
    return BigInt.from(-1);
  }
}

BigInt _getFermat(int n) {
  return Two.pow(pow(2, n) as int) + One;
}

BigInt _getfactorial(int n) {
  if (n > 0) {
    return n <= 1 ? One : BigInt.from(n) * _getfactorial(n - 1);
  } else {
    return One;
  }
}

BigInt _getJacobsthal(int n) {
  return (Two.pow(n) - BigInt.from(-1).pow(n)) ~/ Three;
}

BigInt _getJacobsthalLucas(int n) {
  return Two.pow(n) + BigInt.from(-1).pow(n);
}

BigInt _getJacobsthalOblong(int n) {
  return _getJacobsthal(n) * _getJacobsthal(n + 1);
}

BigInt _getMersenne(int n) {
  return Two.pow(n) - One;
}

BigInt _getMersenneFermat(int n) {
  return Two.pow(n) + One;
}

// void main() {
//
//   // for (final f in fibonacciGenerator()) {
//   //   if (f >= BigInt.from(0) && f <= BigInt.from(100) ){
//   //     print(f);
//   //   }
//   // }
//
//   // for (final value in factorialGenerator(49995, 50000)) {
//   //   print(value);
//   // }
//
//   for (final value in fibonacciGenerator(0, 10)) {
//     print(value);
//   }
//
//
// }