import 'package:flutter/material.dart';
class HourlyForecast extends StatelessWidget {
  final String ab ;
  final String txt;
  final IconData icon;


  const HourlyForecast({super.key,
  required this.ab,
  required this.txt,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100,
          child: Column(

            children: [
              Text(ab,
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8,),
              Icon(icon,
                size: 32,),
              const SizedBox(height: 8,),
              Text(txt),
            ],
          ),
        ),
      ),
    );
  }
}