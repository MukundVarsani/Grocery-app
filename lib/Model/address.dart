class Address {
  String? street;
  String? city;
  String? postalCode;
  String? country;

  Address({this.street, this.city, this.postalCode, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    postalCode = json['postalCode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['postalCode'] = postalCode;
    data['country'] = country;
    return data;
  }
}
