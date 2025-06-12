

// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';


void main() {
  runApp(const PerseusApp());
}

class PerseusApp extends StatelessWidget {
  const PerseusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerseusHome(),
      
    );
  }
}

// VirusTotal API key
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
  } else {
    throw Exception('VirusTotal request failed with status ${response.statusCode}');
  }
}

class PerseusHome extends StatefulWidget {
  const PerseusHome({super.key});

  @override
  State<PerseusHome> createState() => _PerseusHomeState();
}


class ShimmerLoader extends StatelessWidget {
  final LinearGradient gradient;

  const ShimmerLoader({super.key, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: Center(
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 52, 13, 84).withOpacity(0.3),
            highlightColor: const Color.fromARGB(255, 178, 140, 213).withOpacity(0.7),
            child: Container(
              width: 200,
              height: 20,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ),
    );
  }
}



class _PerseusHomeState extends State<PerseusHome> {
  final TextEditingController _urlController = TextEditingController();
  //  onPressed: () {
  //   _urlController.clear(); 
  // },


  void _showResult(BuildContext context, Map<String, dynamic> data) {
    final stats = data['data']['attributes']['last_analysis_stats'];
    final isSafe = stats['malicious'] == 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isSafe ?Color.fromARGB(255, 172, 141, 218)
                : const Color.fromARGB(255, 43, 19, 74),
        duration: const Duration(seconds: 5),
        
        content: Row(
        
          children: [
            
            Flexible(
              
              child: Text(
                isSafe ? 'This URL is safe.                          ' : 'Warning: URL is malicious!                          ',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoScreen(data: data),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
























  Future<void> _checkAndShowResult(String url) async {
    try {
      final data = await checkUrlSafety(url);
      if (!mounted) return;
      _showResult(context, data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking URL')),
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
       Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15062B), Color(0xFF38008B),Color(0xFF15062B),],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),),

        newMethod(context),
      ],
    );
  }

  Scaffold newMethod(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal:30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  const SizedBox(height:50,),
                  Text(
                    'PERSEUS',
                    style: GoogleFonts.aboreto(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Think Before You Click\n~ We do the rest ~',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB0ACE5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.content_paste, size: 24, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Copy a link and paste it here to verify if it's safe to navigate.",
                          style: GoogleFonts.ubuntuMono(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        hintText: 'Paste URL here',
                         hintStyle: GoogleFonts.ubuntuMono(
                        color: Color.fromARGB(255, 46, 6, 105),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.1,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search,color: Color.fromARGB(255, 46, 6, 105)),
                         
                        onPressed: () async {
                          final url = _urlController.text;
                          if (url.isNotEmpty) {
                            // Show the loader screen with your app's gradient
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShimmerLoader(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF15062B), Color(0xFF38008B),Color(0xFF15062B)
                                    ],
                                  ),
                                      




                                ),
                              ),
                            );

                            try {
                              final data = await checkUrlSafety(url);
                              if (!context.mounted) return;
                              Navigator.pop(context); // Remove the loader
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => InfoScreen(data: data)),
                              );
                            } catch (e) {
                              if (context.mounted) Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error checking URL')),
                              );
                            }
                          }
                        },

                                                  

                        ),

                        border: InputBorder.none,
                      ),
                    ),
                  ),


  const SizedBox(height: 40),


              
Row(
  children: [
    Expanded(
      child: Divider(
        color: Color.fromARGB(255, 172, 141, 218),
        thickness: 1.0,
        height: 30,
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        'OR',
        style: GoogleFonts.ubuntuMono(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    ),
    Expanded(
      child: Divider(
        color: Color.fromARGB(255, 172, 141, 218),
        thickness: 1.0,
        height: 30,
      ),
    ),
  ],
)
,
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB0ACE5),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.qr_code_scanner, size: 32, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Scan a QR code to instantly verify \nits safety before navigating, with \na fully secure process.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntuMono(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0ACE5),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black45,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                      );
                    },
                    child: Text(
                      'Scan now',
                      style: GoogleFonts.ubuntuMono(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ),
      );
  }
}



//QR SCANNER SCREEN





class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isProcessing = false;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(Barcode barcode) async {
    if (_isProcessing || !mounted) return;
    setState(() => _isProcessing = true);

    final String? rawValue = barcode.rawValue;
    if (rawValue != null) {
      try {
        final data = await checkUrlSafety(rawValue);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: data['data']['attributes']['last_analysis_stats']['malicious'] == 0
                ? const Color.fromARGB(255, 135, 72, 218)
                : const Color.fromARGB(255, 54, 5, 103),
            content: Row(
              children: [
                Expanded(
                  child: Text(
                    data['data']['attributes']['last_analysis_stats']['malicious'] == 0
                        ? 'This URL is safe.'
                        : 'Warning: URL is not entirely safe!',
                    style:GoogleFonts.ubuntuMono(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoScreen(data: data),
                      ),
                    );
                  },
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning or checking URL', style:GoogleFonts.ubuntuMono(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 12),),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 8, 98),
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor:Color.fromARGB(255, 44, 8, 98),
        foregroundColor: Colors.white,
      ),
      body:
      
   MobileScanner(
  controller: _controller,
  onDetect: (capture) async {
    _controller.stop(); // Stop scanning to avoid multiple triggers

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final qrValue = barcodes.first.rawValue;

      // Show the shimmer loader with your app's gradient
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShimmerLoader(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF15062B), Color(0xFF38008B), Color(0xFF15062B),
              ],
            ),
          ),
        ),
      );

      try {
        final data = await checkUrlSafety(qrValue!); // Your async function
        if (!context.mounted) return;
        Navigator.pop(context); // Remove loader
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InfoScreen(data: data),
          ),
        );
      } catch (e) {
        if (context.mounted) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error processing QR code')),
        );
      }
    }
  },
)
,



    );
  }
}


//INFOSCREEN



class InfoScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const InfoScreen({super.key, required this.data});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    final analysis = widget.data['data']['attributes']['last_analysis_stats'];
    final urlId = widget.data['data']['id'];
    final url = widget.data['data']['attributes']['url'] ?? 'Unknown URL';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        
        
      ),
      body: Container(
    
        
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF15062B), Color(0xFF38008B), Color(0xFF15062B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

    Center (child: Text(
          "DIAGNOSTICS",
          style: GoogleFonts.aboreto(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),),

        const SizedBox(height:40,),


                  _sectionLabel("URL ID"),
                  const SizedBox(height:20),
                  _sectionValue(urlId),
                  const SizedBox(height: 20),
                  _sectionLabel("URL"),
                  const SizedBox(height: 20),
                  _sectionValue(url),
                  const SizedBox(height: 20),
                  _sectionLabel("ANALYSIS RESULTS"),
                  const SizedBox(height: 20),
                  _analysisRow("Harmless", analysis['harmless'].toString()),
                  _analysisRow("Suspicious", analysis['suspicious'].toString()),
                  _analysisRow("Malicious", analysis['malicious'].toString()),
                  _analysisRow("Undetected", analysis['undetected'].toString()),
                  const SizedBox(height: 70),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color:  const Color(0xFFB0ACE5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: GoogleFonts.ubuntuMono(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 1.1,
          ),
        ),
      );

  Widget _sectionValue(String value) => Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8),
        child: Text(
          value,
          style: GoogleFonts.ubuntuMono(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      );

  Widget _analysisRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.ubuntuMono(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.ubuntuMono(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
}
//future builder , bloc or provider, stream builder


void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(color: const Color.fromARGB(255, 91, 81, 227),),
    ),
  );
}

void hideLoader(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}




// New page

// build {
//   if(state is loading){
// return Shimmer;
//   }else if(state is loaded){
//     return Column()
//   }else {
//   return text;
//   }
// }
