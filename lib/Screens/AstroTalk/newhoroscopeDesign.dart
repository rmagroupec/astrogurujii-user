import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Setup/SetUp.dart';
import '../WebServices/api_helper.dart';



class HoroscopeScreen extends StatefulWidget {
    String sign;
        String date;

        HoroscopeScreen({required this.sign,required this.date});

  @override
  _HoroscopeScreenState createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  Map<String, dynamic>? horoscopeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHoroscopeData();
  }

  final _api=ApiBaseHelper();


  Future<void> fetchHoroscopeData() async {
    final url = Uri.parse('${_api.aPPmAINuRL}user_api/get_daily_sun_horoscope');
    final headers = {
      'Content-Type': 'application/json',
    };
    final _prefs = await SharedPreferences.getInstance();

    final body = jsonEncode({
      "zodiac": widget.sign,
      "date": widget.date,
      // "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjczMWRlNDNmYmYyMjk1ZTZlYjNjYTMxIiwiaXNfdG9rZW5fdmFsaWRlIjoxLCJpYXQiOjE3MzEzOTI5MTB9.trVPR-1bNubzEb9E7enSf8bKRDuevdkh72Dp8oSC6TI"
           "token":_prefs.get('token').toString()
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        setState(() {
          horoscopeData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load horoscope data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horoscope'),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : horoscopeData != null
          ? buildHoroscopeContent(horoscopeData!)
          : Center(child: Text('Failed to load data')),
    );
  }

  Widget buildHoroscopeContent(Map<String, dynamic> data) {
    final horoscope = data['data']['horoscope'];
    final botResponse = horoscope['bot_response'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Zodiac Info Card
          Card(
            color: primaryColor.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${horoscope['zodiac']}',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(int.parse(
                            '0xFF${horoscope['lucky_color_code'].substring(1)}')),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Lucky Color: ${horoscope['lucky_color']}',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lucky Numbers: ${horoscope['lucky_number'].join(", ")}',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: botResponse.length,
              itemBuilder: (context, index) {
                String key = botResponse.keys.elementAt(index);
                var aspect = botResponse[key];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          size: 28,
                          color: primaryColor,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatTitle(key),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: aspect['score'] / 100,
                                      backgroundColor:
                                      primaryColor.withOpacity(0.3),
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${aspect['score']}%',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                aspect['split_response'],
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTitle(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }
}
