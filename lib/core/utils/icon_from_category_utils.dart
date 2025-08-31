import 'package:flutter/material.dart';
import 'package:pocketa/features/categories/domain/entities/category_entity.dart';

IconData iconFromCategory(CategoryEntity c) =>
    IconData(c.iconCodePoint, fontFamily: c.iconFontFamily);
