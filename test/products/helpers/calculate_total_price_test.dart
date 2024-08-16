import 'dart:math';

import 'package:flutter_listin/products/helpers/calculate_total_price.dart';
import 'package:flutter_listin/products/model/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('teste de lista simples | ', () {
    test("lista vazia", () {
      List<Product> listProducts = [];

      double result = calculateTotalPriceFromListProduct(listProducts);

      expect(result, 0);
    });

    test("calcula o valor de 1 produto da lista", () {
      List<Product> listProducts = [];
      final product = Product(
        id: '',
        name: '',
        obs: '',
        category: '',
        isKilograms: false,
        isPurchased: true,
        price: Random().nextInt(10).toDouble(),
        amount: Random().nextDouble() * 10,
      );

      listProducts.add(product);

      double result = calculateTotalPriceFromListProduct(listProducts);

      expect(
        result,
        product.price! * product.amount!,
        // reason: "aqui você coloca uma mensagem se der erro",
        // skip: true, caso queira pular esse teste
      );
    });

    test(
      'não pode receber valores negativo',
      () {
        List<Product> listProducts = [
          Product(
            id: '',
            name: '',
            obs: '',
            category: '',
            isKilograms: false,
            isPurchased: true,
            price: Random().nextInt(10).toDouble(),
            amount: Random().nextDouble() * 10,
          )
        ];

        double result = calculateTotalPriceFromListProduct(listProducts);

        expect(result, isNonNegative);
        expect(result, greaterThanOrEqualTo(0));
      },
      retry: 10,
      //retry roda o codigo quantas vezes for passado
    );
  });
  group('testando exception | ', () {
    test('soma apenas produtos que estão no carrinho', () {
      List<Product> listProducts = [
        Product(
          id: '',
          name: '',
          obs: '',
          category: '',
          isKilograms: false,
          isPurchased: true,
          price: Random().nextInt(10).toDouble(),
          amount: Random().nextDouble() * 10,
        ),
        Product(
          id: '',
          name: '',
          obs: '',
          category: '',
          isKilograms: false,
          isPurchased: true,
          price: Random().nextInt(10).toDouble(),
          amount: Random().nextDouble() * 10,
        ),
        Product(
          id: '',
          name: '',
          obs: '',
          category: '',
          isKilograms: false,
          isPurchased: false,
          price: Random().nextInt(10).toDouble(),
          amount: Random().nextDouble() * 10,
        )
      ];

      expect(
        () => calculateTotalPriceFromListProduct(listProducts),
        throwsA(isA<ProductNotPurchasedException>()),
      );
    });
  });
}
