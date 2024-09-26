class ReviewModel {
  String? id;
  String? userId;
  String? productId;
  String? rating;
  String? comment;
  String? createdAt;
  String? updatedAt;

  ReviewModel(
      {this.id,
      this.userId,
      this.productId,
      this.rating,
      this.comment,
      this.createdAt,
      this.updatedAt});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['productId'] = productId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
