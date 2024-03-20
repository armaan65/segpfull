import 'package:flutter/material.dart';
import 'package:segpnew/basePage.dart';

class ScortenCalculatorPage extends StatefulWidget {
  const ScortenCalculatorPage({super.key});

  @override
  _ScortenCalculatorPageState createState() => _ScortenCalculatorPageState();
}

class _ScortenCalculatorPageState extends State<ScortenCalculatorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController ageController = TextEditingController();
  TextEditingController malignancyController = TextEditingController();
  TextEditingController heartRateController = TextEditingController();
  TextEditingController bsaController = TextEditingController();
  TextEditingController ureaController = TextEditingController();
  TextEditingController glucoseController = TextEditingController();
  TextEditingController bicarbonateController = TextEditingController();

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
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: malignancyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Malignancy (0 or 1)',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter malignancy';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: heartRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Heart Rate(beats/minute)',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter heart rate';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: bsaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Body Surface Area (%)',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter body surface area';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ureaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Serum Urea(mmol/L)',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter serum urea';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: glucoseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Serum Glucose(mmol/L)',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter serum glucose';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: bicarbonateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Serum Bicarbonate(mmol/L)',
                  labelStyle: customFont,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter serum bicarbonate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.validate();
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
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
                      Text(
                        'SCORTEN Score: $scortenResult',
                        style: customFont.copyWith(fontSize: 18),
                      ),
                      Text(
                        'Calculated Risk Factor: $riskFactorResult%',
                        style: customFont.copyWith(fontSize: 18),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const BasePage();
                        },
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.secondary,
                  backgroundColor: colorScheme.onSecondary,
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateResults() {
    int age = int.parse(ageController.text);
    int malignancy = int.parse(malignancyController.text);
    int heartRate = int.parse(heartRateController.text);
    int bsa = int.parse(bsaController.text);
    int urea = int.parse(ureaController.text);
    int glucose = int.parse(glucoseController.text);
    int bicarbonate = int.parse(bicarbonateController.text);

    setState(() {
      scortenResult = calculateScorten(age, malignancy, heartRate, bsa, urea, glucose, bicarbonate);
      riskFactorResult = calculateRiskFactor(scortenResult);
    });
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
