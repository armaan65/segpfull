import 'package:flutter/material.dart';
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

  bool _isButtonDisabled = false; // To control the button state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA7E6FF), // Light blue background
      appBar: AppBar(
        title: const Text('SCORTEN Calculator', style: TextStyle(color: Colors.black)), // Black text for AppBar title
        backgroundColor: Color(0xFF53CADA), // Darker blue for the AppBar
        iconTheme: IconThemeData(color: Colors.black), // Black icons for AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSliderCard('Age', _currentAgeValue, 0, 100, (value) => _currentAgeValue = value),
              _buildSliderCard('Malignancy', _currentMalignancyValue, 0, 1, (value) => _currentMalignancyValue = value),
              _buildSliderCard('Heart Rate', _currentHeartRateValue, 0, 200, (value) => _currentHeartRateValue = value),
              _buildSliderCard('Body Surface Area', _currentBsaValue, 0, 100, (value) => _currentBsaValue = value),
              _buildSliderCard('Serum Urea', _currentUreaValue, 0, 50, (value) => _currentUreaValue = value),
              _buildSliderCard('Serum Glucose', _currentGlucoseValue, 0, 50, (value) => _currentGlucoseValue = value),
              _buildSliderCard('Serum Bicarbonate', _currentBicarbonateValue, 0, 50, (value) => _currentBicarbonateValue = value),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonDisabled ? null : _calculateResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF53CADA), // Dark blue button background color
                  foregroundColor: Colors.white, // Button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard(String label, double currentValue, double min, double max, Function(double) onChanged) {
    return Card(
      color: Colors.white, // Card background color
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('$label: ${currentValue.round()}',
              style: const TextStyle(
                color: Colors.black, // Slider text color
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: max.toInt(),
              onChanged: (value) {
                setState(() => onChanged(value));
              },
              activeColor: Color(0xFF53CADA), // Slider active color
              inactiveColor: Colors.black12, // Slider inactive color
            ),
          ],
        ),
      ),
    );
  }

  void _calculateResults() {
    setState(() => _isButtonDisabled = true); // Disable the button while calculating
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
    setState(() => _isButtonDisabled = false); // Re-enable the button after calculation
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
