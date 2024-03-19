import 'package:flutter/material.dart';
import 'package:segpnew/basePage.dart';

class ScortenResultsPage extends StatefulWidget {
  final int scortenScore;
  final double riskFactor;

  ScortenResultsPage({Key? key, required this.scortenScore, required this.riskFactor}) : super(key: key);

  @override
  _ScortenResultsPageState createState() => _ScortenResultsPageState();
}

class _ScortenResultsPageState extends State<ScortenResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCORTEN Results'),
        backgroundColor: Color(0xFFA7E6FF), // Light blue
      ),
      body: Container(
        color: Colors.white, // White background
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: Colors.white, // White card
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'SCORTEN Score: ${widget.scortenScore}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Calculated Risk Factor: ${widget.riskFactor}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BasePage(),
                          ),
                      );
                    },
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF53CADA), // Dark blue button
                      foregroundColor: Colors.white, // White text on button
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
