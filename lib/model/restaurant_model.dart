import 'dart:convert';

class RestaurantModel {
  final String nameRes;
  final String urlImageRes;
  final String address;
  RestaurantModel({
   this.nameRes,
   this.urlImageRes,
   this.address,
  });
  

  RestaurantModel copyWith({
    String nameRes,
    String urlImageRes,
    String address,
  }) {
    return RestaurantModel(
      nameRes: nameRes ?? this.nameRes,
      urlImageRes: urlImageRes ?? this.urlImageRes,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameRes': nameRes,
      'urlImageRes': urlImageRes,
      'address': address,
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      nameRes: map['nameRes'],
      urlImageRes: map['urlImageRes'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantModel.fromJson(String source) => RestaurantModel.fromMap(json.decode(source));

  @override
  String toString() => 'RestaurantModel(nameRes: $nameRes, urlImageRes: $urlImageRes, address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RestaurantModel &&
      other.nameRes == nameRes &&
      other.urlImageRes == urlImageRes &&
      other.address == address;
  }

  @override
  int get hashCode => nameRes.hashCode ^ urlImageRes.hashCode ^ address.hashCode;
}
