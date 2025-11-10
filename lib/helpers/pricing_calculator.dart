class TPRCalculator {
  // -- Calculate price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxAmount + shippingCost;
    return totalPrice;
  }

  // -- Calculate shipping cost
  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(0);
  }

  // -- Calculate tax
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  // Helper method to get tax rate based on location
  static double getTaxRateForLocation(String location) {
    switch (location.toLowerCase()) {
      case 'usa':
        return 0.08; // 8% tax
      case 'uk':
        return 0.20; // 20% tax
      case 'canada':
        return 0.13; // 13% tax
      default:
        return 0.0; // No tax if location not recognized
    }
  }

  // Helper method to get shipping cost based on location
  static double getShippingCost(String location) {
    switch (location.toLowerCase()) {
      case 'usa':
        return 5.0; // $5 shipping
      case 'uk':
        return 10.0; // $10 shipping
      case 'canada':
        return 7.0; // $7 shipping
      default:
        return 0.0; // No shipping cost if location not recognized
    }
  }
}
