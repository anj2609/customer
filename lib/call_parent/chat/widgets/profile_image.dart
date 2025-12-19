import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../chat/api/apis.dart';

class ProfileImage extends StatelessWidget {
  final double size;
  final String? url;

  const ProfileImage({super.key, required this.size, this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size)),
      child: CachedNetworkImage(
        width: size,
        height: size,
        fit: BoxFit.cover,
        imageUrl: url ?? APIs.myid,
        errorWidget: (context, url, error) => ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(size)),
            child: Container(
              width: size,
              height: size,
              color: Colors.grey,
            )),
      ),
    );
  }
}

class ProfileImageSquare extends StatelessWidget {
  final double size;
  final String url;

  const ProfileImageSquare({super.key, required this.size, required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: CachedNetworkImage(
          width: size,
          height: size * (5 / 4),
          fit: BoxFit.cover,
          imageUrl: url,
          errorWidget: (context, url, error) => ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: Container(
                  width: size,
                  height: size * (5 / 4),
                  color: Colors.grey,
                ),
              )),
    );
  }
}
