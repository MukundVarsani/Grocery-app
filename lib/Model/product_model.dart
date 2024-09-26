class ProductModel {
  String? id;
  String? name;
  String? description;
  String? price;
  String? category;
  String? stock;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  bool? isAvailable;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.category,
      this.stock,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.isAvailable
      
      });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    category = json['category'];
    stock = json['stock'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isAvailable = json['isAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['category'] = category;
    data['stock'] = stock;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isAvailable'] = isAvailable;
    return data;
  }
}
