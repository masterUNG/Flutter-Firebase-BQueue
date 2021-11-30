import 'dart:convert';

class RestaurantModel {
  final String nameRes;
  final String urlImageRes;
  final String address;
  final String tokenRest;
  RestaurantModel({
    this.nameRes,
    this.urlImageRes,
    this.address,
    this.tokenRest,
  });

  RestaurantModel copyWith({
    String nameRes,
    String urlImageRes,
    String address,
    String tokenRest,
  }) {
    return RestaurantModel(
      nameRes: nameRes ?? this.nameRes,
      urlImageRes: urlImageRes ?? this.urlImageRes,
      address: address ?? this.address,
      tokenRest: tokenRest ?? this.tokenRest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameRes': nameRes,
      'urlImageRes': urlImageRes,
      'address': address,
      'tokenRest': tokenRest,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      nameRes: map['nameRes'],
      urlImageRes: map['urlImageRes'],
      address: map['address'],
      tokenRest: map['tokenRest'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) =>
      RestaurantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RestaurantModel(nameRes: $nameRes, urlImageRes: $urlImageRes, address: $address, tokenRest: $tokenRest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantModel &&
        other.nameRes == nameRes &&
        other.urlImageRes == urlImageRes &&
        other.address == address &&
        other.tokenRest == tokenRest;
  }

  @override
  int get hashCode {
    return nameRes.hashCode ^
        urlImageRes.hashCode ^
        address.hashCode ^
        tokenRest.hashCode;
  }
}
