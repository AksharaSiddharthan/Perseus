
//ignore_for_file: unused_import


import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'virustotal.dart';

void main() {
  runApp(const PerseusApp());
}

class PerseusApp extends StatelessWidget {
  const PerseusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const PerseusHome(),
        '/qrscanner': (context) => const QRScannerScreen(),
        '/info': (context) => const InfoScreen(),
      },
    );
  }
}

class PerseusHome extends StatefulWidget {
  const PerseusHome({super.key});

  @override
  State<PerseusHome> createState() => _PerseusHomeState();
}

class _PerseusHomeState extends State<PerseusHome> {
  final TextEditingController _urlController = TextEditingController();
  Future<Map<String, dynamic>>? _futureResult;

  void _startCheck() {
    final url = _urlController.text;
    if (url.isNotEmpty) {
      setState(() {
        _futureResult = checkUrlSafety(url);
      });
      _urlController.clear();
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF15062B), Color(0xFF38008B), Color(0xFF38008B), Color(0xFF15062B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
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
                        color: Colors.white,
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
                          child: const Icon(Icons.content_paste, size: 24, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Copy a link and paste it here to verify if it's safe to navigate.",
                            style: GoogleFonts.ubuntuMono(color: Colors.white, fontSize: 12),
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
                            color: Color(0xFF2E0669),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.1,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Color(0xFF2E0669)),
                            onPressed: _startCheck,
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _startCheck(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_futureResult != null)
                      FutureBuilder<Map<String, dynamic>>(
                        future: _futureResult,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.error, color: Colors.red),
                                  Text(
                                    'Error checking URL',
                                    style: GoogleFonts.ubuntuMono(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushNamed(context, '/info', arguments: snapshot.data);
                              setState(() {
                                _futureResult = null;
                              });
                            });
                            return const SizedBox(); 
                          }
                          return const SizedBox();
                        },
                      ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFAC8DDA),
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
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFAC8DDA),
                            thickness: 1.0,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
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
                          child: const Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Scan a QR code to instantly verify \nits safety before navigating, with \na fully secure process.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntuMono(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB0ACE5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black45,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/qrscanner');
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
        ],
      ),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late final MobileScannerController _controller;
  Future<Map<String, dynamic>>? _futureResult;
  String? _lastQR;

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

  void _onQRDetected(String? qrValue) {
    if (qrValue == null || qrValue == _lastQR) return;
    setState(() {
      _lastQR = qrValue;
      _futureResult = checkUrlSafety(qrValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 8, 98),
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: const Color.fromARGB(255, 44, 8, 98),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final qrValue = barcodes.first.rawValue;
                _onQRDetected(qrValue);
                _controller.stop();
              }
            },
          ),
          if (_futureResult != null)
            FutureBuilder<Map<String, dynamic>>(
              future: _futureResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        Text(
                          'Error processing QR code',
                          style: GoogleFonts.ubuntuMono(color: Colors.white, fontSize: 12),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureResult = null;
                              _lastQR = null;
                              _controller.start();
                            });
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamed(context, '/info', arguments: snapshot.data);
                    setState(() {
                      _futureResult = null;
                      _lastQR = null;
                    });
                  });
                  return const SizedBox();
                }
                return const SizedBox();
              },
            ),
        ],
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
        body: const Center(child: Text('No data provided')),
      );
    }
    final analysis = data['data']['attributes']['last_analysis_stats'];
    final urlId = data['data']['id'];
    final url = data['data']['attributes']['url'] ?? 'Unknown URL';
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                  Center(
                    child: Text(
                      "DIAGNOSTICS",
                      style: GoogleFonts.aboreto(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _sectionLabel("URL ID"),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 200),
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
          color: const Color(0xFFB0ACE5),
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
