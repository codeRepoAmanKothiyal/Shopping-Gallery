/*
"products": [
{
"id": 1,
"title": "iPhone 9",
"description": "An apple mobile which is nothing like apple",
"price": 549,
"discountPercentage": 12.96,
"rating": 4.69,
"stock": 94,
"brand": "Apple",
"category": "smartphones",
"thumbnail": "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg",
"images": [
"https://cdn.dummyjson.com/product-images/1/1.jpg",
"https://cdn.dummyjson.com/product-images/1/2.jpg",
]
},
 */

class Product {
  int? id;
  String? title;
  String? description;
  dynamic price;
  dynamic? discountPercentage;
  dynamic rating;
  String? brand;
  String? category;
  String? thumbnail;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.brand,
    this.category,
    this.thumbnail
  });

  Product.fromJson(Map<String, dynamic>json){
    id= json["id"];
    title= json["title"];
    description= json["description"];
    price= json["price"];
    discountPercentage= json["discountPercentage"];
    rating= json["rating"];
    brand=json["brand"];
    category= json["category"];
    thumbnail= json["thumbnail"];

  }
}