import '../model/product.dart';

double calculateTotalPriceFromListProduct(List<Product> listProducts) {
  double total = 0;

  for (Product product in listProducts) {
    if (!product.isPurchased) throw ProductNotPurchasedException(product);

    if (product.amount != null && product.price != null) {
      total += (product.amount! * product.price!);
    }
  }

  return total;
}

class ProductNotPurchasedException implements Exception {
  final Product product;
  final String message;
  ProductNotPurchasedException(this.product)
      : message = "O produto ${product.name} não está no carrinho.";
}
