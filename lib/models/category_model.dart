import 'package:flutter/cupertino.dart';

class ImageCategory {
  final String id;
  final String name;
  final String imageUrl;

  ImageCategory({this.id, @required this.name, @required this.imageUrl});
  factory ImageCategory.fromJson({
  @required String id, @required Map<String ,dynamic> json}) {
    return ImageCategory(
      id: id,
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
  String toString() => 'ImageCategory{id: $id, name:$name, imageUrl: $imageUrl}';
}