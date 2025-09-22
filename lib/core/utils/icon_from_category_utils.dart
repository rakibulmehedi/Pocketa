import 'package:flutter/material.dart';
import 'package:flow/features/categories/domain/entities/category_entity.dart';

IconData iconFromCategory(CategoryEntity c) =>
    IconData(c.iconCodePoint, fontFamily: c.iconFontFamily);
