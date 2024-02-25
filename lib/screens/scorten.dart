import 'package:flutter/material.dart';
import 'package:segpnew/basePage.dart';

class ScortenCalculatorPage extends StatefulWidget {
  @override
  _ScortenCalculatorPageState createState() => _ScortenCalculatorPageState();
}

class _ScortenCalculatorPageState extends State<ScortenCalculatorPage> {
  TextEditingController ageController = TextEditingController();
  TextEditingController malignancyController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController bsaController = TextEditingController();
  TextEditingController ureaController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController bicarbonateController = TextEditingController();

  double scortenResult = 0;
  double riskFactorResult = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCORTEN Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Patient Information:'),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: malignancyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Malignancy (0 or 1)'),
            ),
            TextField(
              controller: heartRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Heart Rate(beats/minute)'),
            ),
            TextField(
              controller: bsaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Body Surface Area (%)'),
            ),
            TextField(
              controller: ureaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Serum Urea(mmol/L)'),
            ),
            TextField(
              controller: glucoseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Serum Glucose(mmol/L)'),
            ),
            TextField(
              controller: bicarbonateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Serum Bicarbonate(mmol/L)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateResults();
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text('SCORTEN Score: $scortenResult'),
            Text('Calculated Risk Factor: $riskFactorResult%'),
            SizedBox(height: 20),
            // Remove the Navigator widget that wraps the ElevatedButton widget
            // Use the Navigator widget that is provided by the Scaffold widget
            ElevatedButton(
              // Use the onPressed property to check if all the details are filled
              onPressed: () {
                // Get the values of the text fields
                String age = ageController.text;
                String malignancy = malignancyController.text;
                String heartRate = heartRateController.text;
                String bsa = bsaController.text;
                String urea = ureaController.text;
                String glucose = glucoseController.text;
                String bicarbonate = bicarbonateController.text;

                // Check if any of the text fields is empty
                if (age.isEmpty ||
                    malignancy.isEmpty ||
                    heartRate.isEmpty ||
                    bsa.isEmpty ||
                    urea.isEmpty ||
                    glucose.isEmpty ||
                    bicarbonate.isEmpty) {
                  // If yes, show a SnackBar widget with a message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all the details'),
                    ),
                  );
                } else {
                  // If no, navigate to the BasePage widget
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return BasePage();
                      },
                    ),
                  );
                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  void calculateResults() {
    double age = double.tryParse(ageController.text) ?? 0;
    double malignancy = double.tryParse(malignancyController.text) ?? 0;
    double heartRate = double.tryParse(heartRateController.text) ?? 0;
    double bsa = double.tryParse(bsaController.text) ?? 0;
    double urea = double.tryParse(ureaController.text) ?? 0;
    double glucose = double.tryParse(glucoseController.text) ?? 0;
    double bicarbonate = double.tryParse(bicarbonateController.text) ?? 0;

    setState(() {
      scortenResult = calculateScorten(age, malignancy, heartRate, bsa, urea, glucose, bicarbonate);
      riskFactorResult = calculateriskfactor(age, malignancy, heartRate, bsa, urea, glucose, bicarbonate);
    });
  }

  double calculateScorten(double age, double malignancy, double heartRate,
    double bsa, double urea, double glucose, double bicarbonate) {
  double agePoints = (age >= 40) ? 1 : 0;
  double heartRatePoints = (heartRate >= 120) ? 1 : 0;
  double bsaPoints = (bsa >= 10) ? 1 : 0;
  double ureaPoints = (urea > 10) ? 1 : 0;
  double glucosePoints = (glucose > 14) ? 1 : 0;
  double bicarbonatePoints = (bicarbonate < 20) ? 1 : 0;
  double malignancyPoints = (malignancy == 1) ? 1 : 0;

  return agePoints + ureaPoints + glucosePoints + bsaPoints + bicarbonatePoints + heartRatePoints + malignancyPoints;
}

double calculateriskfactor(double age, double malignancy, double heartRate,
    double bsa, double urea, double glucose, double bicarbonate) {
  double scortenScore = calculateScorten(age, malignancy, heartRate, bsa, urea, glucose, bicarbonate);
  double riskfactor;

  if (scortenScore <= 1) {
    riskfactor = 3.2;
  } else if (scortenScore == 2) {
    riskfactor = 12.1;
  } else if (scortenScore == 3) {
    riskfactor = 35.3;
  } else if (scortenScore == 4) {
    riskfactor = 58.3;
  } else {
    riskfactor = 90;
  }

  return riskfactor;
}
}