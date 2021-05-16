import 'package:flutter/material.dart';
import 'package:flutter_tmdb_lite/utils/Constants.dart';
import 'package:shimmer/shimmer.dart';

Container shimmer() {
  return Container(
    child: Shimmer.fromColors(
      baseColor: Color(0xFFE0E0E0),
      highlightColor: Color(0xFF757575),
      child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    height: 160,
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 12, left: 20),
                        color: Colors.white,
                        height: 20,
                        width: 90,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 22, left: 20),
                        color: Colors.white,
                        height: 50,
                        width: 130,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 22, left: 20),
                        color: Colors.white,
                        height: 10,
                        width: 80,
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    ),
  );
}

Widget widgetError(String err) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.error,
        size: 80,
        color: Colors.red,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Text("Error : $err ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Constants.colorDark)),
      ),
    ],
  );
}
