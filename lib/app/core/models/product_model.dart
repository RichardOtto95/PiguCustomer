// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String title;
  String subtitle;
  String description;
  String icon;
  String image;
  String categoryName;
  String price;

  ProductModel({
    this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.image,
    this.categoryName,
    this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        icon: json["icon"],
        image: json["image"],
        categoryName: json["categoryName"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "icon": icon,
        "image": image,
        "categoryName": categoryName,
        "price": price,
      };

  // List<ProductModel> categoriesList() {
  //   return [
  //     ProductModel(
  //         title: "Smartphone",
  //         icon: "assets/icons/smartphone.png",
  //         description: "Aparelho com 16GB de RAM, processador quadcore, de qualquer marca."),
  //     ProductModel(
  //       title: "Televisores",
  //       icon: "assets/icons/tv.png",
  //       description: "Televisores Aparelho com 16GB de RAM, processador quadcore, de qualquer marca."
  //     ),
  //     ProductModel(
  //       title: "Jogos",
  //       icon: "assets/icons/games.png",
  //       description: "Jogos Aparelho com 16GB de RAM, processador quadcore, de qualquer marca."
  //     ),
  //     ProductModel(
  //       title: "Cosméticos",
  //       icon: "assets/icons/oticas.png",
  //       description: "Cosméticos Aparelho com 16GB de RAM, processador quadcore, de qualquer marca."
  //     ),
  //     ProductModel(
  //       title: "Fitness",
  //       icon: "assets/icons/fitness.png",
  //       description: "Fitness Aparelho com 16GB de RAM, processador quadcore, de qualquer marca."
  //     ),
  //   ];
  // }


  // List<ProductModel> getPropostas(){
  //   return [
  //      ProductModel(
  //         title: "Loja do pedro",
  //         icon: "assets/icons/smartphone.png",
  //         description: "Aparelho com 16GB de RAM, processador quadcore, de qualquer marca.",
  //         price: "450,99"),
  //      ProductModel(
  //         title: "Mundo Cell",
  //         icon: "assets/icons/smartphone.png",
  //         description: "Aparelho com 16GB de RAM, processador quadcore, de qualquer marca.",
  //         price: "399,99"),
  //      ProductModel(
  //         title: "Quero Cell",
  //         icon: "assets/icons/smartphone.png",
  //         description: "Aparelho com 16GB de RAM, processador quadcore, de qualquer marca.",
  //         price: "350,99"),
  //   ];
  // }

}
