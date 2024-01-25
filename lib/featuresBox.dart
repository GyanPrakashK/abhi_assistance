import 'package:abhi_assistance/pallets.dart';
import 'package:flutter/material.dart';

class FeaturesBox extends StatelessWidget {
  final Color color;
  final String headtext;
  final String descriptiontext;
  const FeaturesBox(
      {super.key,
      required this.color,
      required this.headtext,
      required this.descriptiontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ).copyWith(top: 18),
      decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Pallete.borderColor),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headtext,
            style: TextStyle(
                fontFamily: 'Cera Pro',
                fontSize: 18,
                color: Pallete.mainFontColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            descriptiontext,
            style: TextStyle(
                fontFamily: 'Cera Pro',
                fontSize: 15,
                color: Pallete.mainFontColor),
          ),
        ],
      ),
    );
  }
}
