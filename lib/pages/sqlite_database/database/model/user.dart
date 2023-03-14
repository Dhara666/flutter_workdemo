import 'dart:typed_data';

class User {
  int id;
  String _productName;
  String _productPrice;
  String _productDiscount;
  String _productTax;
  String _productSubTotal;
  Uint8List _productImage;

  User(this._productName, this._productPrice, this._productDiscount,
      this._productTax, this._productImage, this._productSubTotal);

  User.map(dynamic obj) {
    this._productName = obj["productname"];
    this._productPrice = obj["productprice"];
    this._productDiscount = obj["productdiscount"];
    this._productTax = obj["producttax"];
    this._productImage = obj["productimage"];
    this._productSubTotal = obj["productSubTotal"];
  }

  String get productName => _productName;

  String get productPrice => _productPrice;

  String get productDiscount => _productDiscount;

  String get productTax => _productTax;
  String get productSubTotal => _productSubTotal;
  Uint8List get productPicture => _productImage;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["productname"] = _productName;
    map["productprice"] = _productPrice;
    map["productdiscount"] = _productDiscount;
    map["producttax"] = _productTax;
    map["productSubTotal"] = _productSubTotal;
    map["productimage"] = _productImage;
    return map;
  }

  void setUserId(int id) {
    this.id = id;
  }
}
