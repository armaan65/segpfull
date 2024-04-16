import 'package:flutter/material.dart';
import 'package:segpnew/screens/upload_page.dart';

class ScortenResultsPage extends StatefulWidget {
  final int scortenScore;
  final double riskFactor;

  const ScortenResultsPage({Key? key, required this.scortenScore, required this.riskFactor}) : super(key: key);

  @override
  _ScortenResultsPageState createState() => _ScortenResultsPageState();
}

class _ScortenResultsPageState extends State<ScortenResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA7E6FF),
      appBar: AppBar(
        title: const Text('SCORTEN Results', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFF53CADA),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'SCORTEN Score: ${widget.scortenScore}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Calculated Risk Factor: ${widget.riskFactor}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UploadPage(),
                        ),
                      );
                    },
                    child: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF53CADA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
