import 'package:dio/dio.dart';
import 'package:fetch_api/model/json_model.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController controlDetails = TextEditingController();

  apiCall? apiCalling;

  String cityName = "Karachi";
  static String _apikey = "2dba79d2ea3efcd5c47300a3c61edfaa";

  Future<apiCall?> fetchData(String cityName) async {
    Response response;
    var dio = Dio();
    response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apikey');
    if (response.statusCode == 200) {
      apiCall apiResult = apiCall.fromJson(response.data);
      return apiResult;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:40.0,left: 24, right: 24),
          child: TextField(
            controller: controlDetails,
            decoration: const InputDecoration(
              labelText: "City Name",
              hintText: "Enter City",
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
            child: const Text(
              "Get Result",
              style: TextStyle(
                  fontSize: 20,
             ),
            ),
            onPressed: () async {
              final finalApi = await fetchData(controlDetails.text);
              setState(() {
                apiCalling = finalApi;

              });
            }),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
            const Text(
              "Wind",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              apiCall !=null ? "${apiCalling?.wind?.speed}km/hr" : " ",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 23,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Temperature",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            apiCall() != null
                ? Text("${apiCalling?.main!.temp!}°C",
                    // "-${temp.toDouble()}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 23,
                    ))
                : const Text(
                    " ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ],
        ),
        const SizedBox(height: 20.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Humidity",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              apiCall != null ? "${apiCalling?.main?.humidity}%" : " ",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 23,
              ),
            ),
          ],
        ),
      ],
    )));
  }
}
