import 'dart:convert';
import 'package:shoping_gallery/model/product_model.dart';
import 'package:http/http.dart' as http;



class Api {
  static const _productListUrl = "https://dummyjson.com/products";

  Future<List<Product?>> getProductData() async {
    final response = await http.get(Uri.parse(_productListUrl));
    {
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body)["products"] as List;

         print(decodedData);
        return  decodedData.map((productData) => Product.fromJson(productData)).toList();
      } else {
        throw Exception("Something Happend");
      }
    }
  }

  static const _productCategoriesUrl = "https://dummyjson.com/products/categories";

  Future<List<dynamic>> getCategoriesList() async {
    final  response = await http.get(Uri.parse(_productCategoriesUrl));
    {
      if (response.statusCode == 200) {
        List<dynamic> decodedData = jsonDecode(response.body);

        print(decodedData);
        return  decodedData;
      } else {
        throw Exception("Something Happend");
      }
    }
  }
  static const _CatogoriesUrl = "https://dummyjson.com/products/category/";

  Future<List<Product?>> getCategories(String category) async {
    final response = await http.get(Uri.parse(_CatogoriesUrl+ "$category"));
    {
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body)["products"] as List;

        print(decodedData);
        return  decodedData.map((productData) => Product.fromJson(productData)).toList();
      } else {
        throw Exception("Something Happend");
      }
    }
  }
  static const _SearchUrl = "https://dummyjson.com/products/search?q=";

  Future<List<Product?>> getSearch(String name) async {
    final response = await http.get(Uri.parse(_SearchUrl+ "$name"));
    {
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body)["products"] as List;

        print(decodedData);
        return  decodedData.map((productData) => Product.fromJson(productData)).toList();
      } else {
        throw Exception("Something Happend");
      }
    }
  }
}