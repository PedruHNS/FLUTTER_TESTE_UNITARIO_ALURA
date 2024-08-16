import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

class Calculadora {
  int somar(int a, int b) {
    return a + b;
  }

  int subtrair(int a, int b) {
    return a - b;
  }

  int multiplicar(int a, int b) {
    int result = 0;

    for (int i = 0; i < b; i++) {
      result += a;
    }

    return result;
  }

  int dividir(int a, int b) {
    return dividirComResto(a, b).quociente;
  }

  Divisao dividirComResto(int a, int b) {
    if (b == 0) throw DivisaoPorZeroException();

    int quociente = a ~/ b;
    int resto = a % b;

    return Divisao(quociente, resto);
  }
}

class Divisao {
  int quociente;
  int resto;

  Divisao(this.quociente, this.resto);
}

class DivisaoPorZeroException implements Exception {}

void main() {
  late Calculadora calc;
  late int valueA;
  late int valueB;
  setUp(
    () {
      calc = Calculadora();
      valueA = Random().nextInt(10 - (-10) + 1);
      valueB = Random().nextInt(10 - (-10) + 1);
    },
  );
  test("soma", () {
    final result = calc.somar(valueA, valueB);

    expect(result, valueA + valueB);
  });

  test('subtração', () {
    final result = calc.subtrair(valueA, valueB);

    expect(result, valueA - valueB);
  });

  test('multiplacação', () {
    final result = calc.multiplicar(valueA, valueB);

    expect(result, valueA * valueB);
  });

  group("casos divisão", () {
    test('divisor = 0', () {
      expect(() => calc.dividirComResto(valueA, 0),
          throwsA(isA<DivisaoPorZeroException>()));
    });
    test('dividir sem resto inclui negativos', () {
      final result = calc.dividir(valueA, valueB);

      expect(result, valueA ~/ valueB);
    });

    test('divisão com resto, misto de positivo e negativo', () {
      final result = calc.dividirComResto(-32, -5);
      expect(result.quociente, -32 ~/ -5);
      expect(result.resto, -32 % -5);
    });
  });
}
