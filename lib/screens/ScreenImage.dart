import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class ScreenImageView extends StatefulWidget {
  final String? imageUrl;
  ScreenImageView({this.imageUrl});
  @override
  _ScreenImageViewState createState() => _ScreenImageViewState();
}

class _ScreenImageViewState extends State<ScreenImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: FadeInImage(
          height: double.infinity,
          width: double.infinity,
          placeholder: AssetImage('assets/tmdb.jpg'),
          image: NetworkImage(widget.imageUrl!),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
