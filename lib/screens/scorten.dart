import 'package:flutter/material.dart';
import 'package:segpnew/basePage.dart';
import 'package:segpnew/screens/scorten_results.dart';

class ScortenCalculatorPage extends StatefulWidget {
  const ScortenCalculatorPage({super.key});

  @override
  _ScortenCalculatorPageState createState() => _ScortenCalculatorPageState();
}

class _ScortenCalculatorPageState extends State<ScortenCalculatorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _currentAgeValue = 0;
  double _currentMalignancyValue = 0;
  double _currentHeartRateValue = 0;
  double _currentBsaValue = 0;
  double _currentUreaValue = 0;
  double _currentGlucoseValue = 0;
  double _currentBicarbonateValue = 0;

  int scortenResult = 0;
  double riskFactorResult = 0;

  @override
  Widget build(BuildContext context) {
    const TextStyle customFont = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
    );

    const ColorScheme colorScheme = ColorScheme(
      primary: Color(0xFFA7E6FF),
      secondary: Color(0xFF53CADA),
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SCORTEN Calculator'),
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Patient Information:',
                style: customFont.copyWith(fontWeight: FontWeight.bold),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Age: ${_currentAgeValue.round()}'),
                      Slider(
                        value: _currentAgeValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (double value) {
                          setState(() {
                            _currentAgeValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Malignancy: ${_currentMalignancyValue.round()}'),
                      Slider(
                        value: _currentMalignancyValue,
                        min: 0,
                        max: 1,
                        divisions: 1,
                        onChanged: (double value) {
                          setState(() {
                            _currentMalignancyValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Heart Rate: ${_currentHeartRateValue.round()}'),
                      Slider(
                        value: _currentHeartRateValue,
                        min: 0,
                        max: 200,
                        divisions: 200,
                        onChanged: (double value) {
                          setState(() {
                            _currentHeartRateValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Body Surface Area: ${_currentBsaValue.round()}'),
                      Slider(
                        value: _currentBsaValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (double value) {
                          setState(() {
                            _currentBsaValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Serum Urea: ${_currentUreaValue.round()}'),
                      Slider(
                        value: _currentUreaValue,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        onChanged: (double value) {
                          setState(() {
                            _currentUreaValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Serum Glucose: ${_currentGlucoseValue.round()}'),
                      Slider(
                        value: _currentGlucoseValue,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        onChanged: (double value) {
                          setState(() {
                            _currentGlucoseValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Serum Bicarbonate: ${_currentBicarbonateValue.round()}'),
                      Slider(
                        value: _currentBicarbonateValue,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        onChanged: (double value) {
                          setState(() {
                            _currentBicarbonateValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    calculateResults();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                ),
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateResults() {
    // Parse the input values
    int age = _currentAgeValue.round();
    int malignancy = _currentMalignancyValue.round();
    int heartRate = _currentHeartRateValue.round();
    int bsa = _currentBsaValue.round();
    int urea = _currentUreaValue.round();
    int glucose = _currentGlucoseValue.round();
    int bicarbonate = _currentBicarbonateValue.round();

    // Calculate the SCORTEN score and risk factor
    int score = calculateScorten(age, malignancy, heartRate, bsa, urea, glucose, bicarbonate);
    double riskFactor = calculateRiskFactor(score);

    // Navigate to the results page with the calculated values
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScortenResultsPage(
          scortenScore: score,
          riskFactor: riskFactor,
        ),
      ),
    );
  }

  int calculateScorten(int age, int malignancy, int heartRate, int bsa, int urea, int glucose, int bicarbonate) {
    int agePoints = (age >= 40) ? 1 : 0;
    int heartRatePoints = (heartRate >= 120) ? 1 : 0;
    int bsaPoints = (bsa >= 10) ? 1 : 0;
    int ureaPoints = (urea > 10) ? 1 : 0;
    int glucosePoints = (glucose > 14) ? 1 : 0;
    int bicarbonatePoints = (bicarbonate < 20) ? 1 : 0;
    int malignancyPoints = (malignancy == 1) ? 1 : 0;

    return agePoints + ureaPoints + glucosePoints + bsaPoints + bicarbonatePoints + heartRatePoints + malignancyPoints;
  }

  double calculateRiskFactor(int scortenScore) {
    switch (scortenScore) {
      case 0:
      case 1:
        return 3.2;
      case 2:
        return 12.1;
      case 3:
        return 35.3;
      case 4:
        return 58.3;
      default:
        return 90;
    }
  }
}
