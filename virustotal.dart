import 'dart:convert';
import 'package:http/http.dart' as http;


//This file contains the VirusTotal api 
const String virusTotalApiKey = '4c05eb38da905d1cf615b06d3ce26f3da40fc7393a05413e9ba44ae2ddf1be6c';

Future<Map<String, dynamic>> checkUrlSafety(String url) async {
  final scanUrl = 'https://www.virustotal.com/api/v3/urls';
  final encodedUrl = base64Url.encode(utf8.encode(url.trim())).replaceAll('=', '');
  final response = await http.get(
    Uri.parse('$scanUrl/$encodedUrl'),
    headers: {
      'x-apikey': virusTotalApiKey,
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } 
  else {
    throw Exception('VirusTotal request failed with status ${response.statusCode}');
  }
}
