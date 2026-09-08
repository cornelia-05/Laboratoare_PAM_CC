import 'package:flutter/material.dart';

void main() {
  runApp(const ApplicationWindow());
}

// structura
class ApplicationWindow extends StatelessWidget {
  const ApplicationWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyScreen(), // Sa se deschida ecranul principal
    );
  }
}

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  // suma de convertit
  final TextEditingController amountController = TextEditingController();

  // currencies
  static const List<String> currencyList = ['MDL', 'EUR', 'USD'];

  // cursul valutar
  static const Map<String, double> exchangeRates = {
    'MDL': 1.0,
    'EUR': 20,
    'USD': 17,
  };

  String fromCurrency = 'MDL';
  String toCurrency = 'EUR';

  // rezultatul conversiei
  String resultText = '';

  //calculul
  void convertCurrency() {

    double? enteredAmount = double.tryParse(amountController.text);

    if (enteredAmount == null || enteredAmount <= 0) {
      setState(() {
        resultText = 'Introdu o sumă validă!';
      });
      return;
    }

    // x-mdl,mdl-y
    double amountInMdl = enteredAmount * exchangeRates[fromCurrency]!;
    double finalResult = amountInMdl / exchangeRates[toCurrency]!;

    setState(() {
      resultText = '${finalResult.toStringAsFixed(2)} $toCurrency';
    });
  }

  //cleanup
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  //interfata
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // titlu
      appBar: AppBar(
        title: const Text('Conversie Monedă'),
        backgroundColor: Colors.purple.shade200,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0), // Spațiu pe margini
        child: Column(
          children: [

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Introduceți suma',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Meniurile de selecție
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                DropdownButton<String>(
                  value: fromCurrency,
                  items: currencyList.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        fromCurrency = newValue;
                      });
                    }
                  },
                ),

                const Icon(Icons.arrow_forward),

                DropdownButton<String>(
                  value: toCurrency,
                  items: currencyList.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        toCurrency = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: convertCurrency,
              child: const Text('Convertește'),
            ),
            const SizedBox(height: 30),

            Text(
              resultText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}