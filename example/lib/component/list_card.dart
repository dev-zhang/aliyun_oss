/*
 * File Created: 2022-06-14 17:45:23
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-14 17:47:41
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
