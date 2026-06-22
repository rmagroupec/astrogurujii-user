import 'package:flutter/material.dart';

import 'model/modelNew.dart';

class DoshaScreen extends StatelessWidget {
  KundaliNew res;

  DoshaScreen({required this.res});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        children: [
          // Mangal Dosh Section
          _buildDoshaCard(
              title: "Mangal Dosh",
               status: res.dosha!.mangalDosh!.botResponse??"",
               score:  res.dosha!.mangalDosh!.score.toString(),
              factors: [
                res.dosha!.mangalDosh!.factors!.mars??""
              ],
              cancellation:
                res.dosha!.mangalDosh!.cancellation!.cancellationReason,




              remedies: [
                // "Offer water to Banyan tree regularly",
                // "Chant Moola Mantra of Lord Shiva",
              ]
          ),
          SizedBox(height: 10),

          // Kaalsarp Dosh Section
          _buildDoshaCard(
              title: "Kaalsarp Dosh",
              status: res.dosha!.kaalsarpDosh!.botResponse??"",
              remedies: res.dosha!.kaalsarpDosh!.remedies
          ),
          SizedBox(height: 10),

          // Manglik Dosh Section
          _buildDoshaCard(
              title: "Manglik Dosh",
              status: res.dosha!.manglikDosh!.botResponse??"",
              score: res.dosha!.manglikDosh!.score.toString(),
              factors: res.dosha!.manglikDosh!.factors,
              remedies: [
                // "Perform Manglik Dosh Nivaran Pooja.",
                // "Chant Hanuman Chalisa."
              ]
          ),
          SizedBox(height: 10),

          // Pitra Dosh Section
          _buildDoshaCard(
              title: "Pitra Dosh",
              status: res.dosha!.pitraDosh!.botResponse??"",
              remedies: res.dosha!.pitraDosh!.remedies
          ),
        ],
      ),
    );
  }

  // Helper method to build each dosha card
  Widget _buildDoshaCard({
    required String title,
    required String status,
    String? score,
    List<String>? factors,
    List<String>? cancellation,
    required List<String> remedies,
  }) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Status: $status",
              style: TextStyle(fontSize: 16),
            ),
            if (score != null) ...[
              SizedBox(height: 8),
              Text(
                "Score: $score",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
            if (factors != null && factors.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                "Factors: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...factors.map((factor) => Text(factor)).toList(),
            ],
            if (cancellation != null && cancellation.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                "Cancellation: ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...cancellation.map((canc) => Text(canc)).toList(),
            ],
            SizedBox(height: 8),
            Text(
              "Remedies:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...remedies.map((remedy) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(remedy),
            )),
          ],
        ),
      ),
    );
  }
}


