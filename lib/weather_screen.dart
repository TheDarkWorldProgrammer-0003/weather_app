import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_information.dart';
import 'package:weather_app/hourly_update.dart';
import 'package:http/http.dart' as http;
import 'hourly_update.dart';
import 'package:weather_app/weather_screen.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();

}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  void initState(){
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String,dynamic>> getCurrentWeather()async{
    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=fe4d9d9698a8f78e44613f4e09b7a186"),
      );
      final data = jsonDecode(res.body);

       if(int.parse(data['cod']) != 200){
         throw 'An unexpected error occured';
    }

       // setState(() {
       //   // temp = data['list'] [0] ['main'] ['temp'];
       // });
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App",
          style: TextStyle(fontWeight:FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions:[
          IconButton(onPressed: (){
            setState(() {

            });
          }
          , icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future:getCurrentWeather() ,
        builder:(context,snapshot) {
          print(snapshot);
          if(snapshot.connectionState==ConnectionState.waiting){
            return const  Center(child: CircularProgressIndicator.adaptive(),
            );
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main'] ['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];


          return Padding(padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Main Card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: ClipRRect(
                  borderRadius:BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX:10,sigmaY: 10),
                    child:  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(" $currentTemp K ",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          SizedBox(height: 16,),
                          Icon(
                            currentSky=='Clouds'|| currentSky == 'Rain '? Icons.cloud : Icons.sunny,
                          size: 64,),
                          SizedBox(height: 16,),
                          Text(currentSky,
                            style: TextStyle(
                            fontSize: 20
                          ),)
                        ],
                      ),
                    ),
                  ),
                ) ,
              ),
            ),
              SizedBox(height: 20,),
              const Text("Weather Forecast",style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              ),
            SizedBox(height: 16,),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       for(int i = 0; i<5;i++)
            //       HourlyForecast(
            //         ab: data['list'][i+1]['dt_txt'].toString(),
            //         icon:data['list'][i+1]['weather'][0]['main'] == 'Clouds' || data['list'][i+1]['weather'][0]['main'] == "Rain" ? Icons.cloud: Icons.sunny,
            //         txt: data['list'][i+1]['main']['temp'].toString(),
            //       ),
            //     ],
            //   ),
            // ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                    itemBuilder:(context,index){
                    final hourlyForecast = data['list'][index+1];
                    final hourlySky = data['list'][index+1]['weather'][0]['main'];
                    final hourlyTemp = hourlyForecast['main']['temp'].toString();
                    final ab =DateTime.parse(hourlyForecast['dt_txt'].toString());
                      return HourlyForecast(
                          ab: DateFormat.jm().format(ab),
                          txt:hourlyTemp,
                          icon: hourlySky == 'Clouds' || hourlySky== "Rain" ? Icons.cloud: Icons.sunny,
                      );
                    },
                ),
              ),
             const SizedBox(height: 20,),
             // additional information
              const Text("Additional Information",style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                AdditionalInformation( icon: Icons.water_drop_sharp,
                  label: "Humidity",
                  value: currentHumidity.toString(),),
                AdditionalInformation(icon: Icons.air_sharp,
                label:"Wind Speed",
                value:currentWindSpeed.toString(),),

                AdditionalInformation(
                  icon: Icons.beach_access,
                  label: "Pressure",
                  value: currentPressure.toString(),
                ),

              ],
            )
            //    Main card
            ],
          ),
        );
        },
      ),
    );
  }
}


