import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create.dart';
import 'common.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dateBoughtController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];

  void _searchAppliances() async {
    String serialNumber = serialNumberController.text;
    String brand = brandController.text;
    String model = modelController.text;
    String status = statusController.text;
    String dateBought = dateBoughtController.text;

    try {
      final url = Uri.parse(
          'http://$SourceIP/appliance/search');
      final response = await http.post(url,
          headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
          },
          body: jsonEncode({
        'serial_number': serialNumber,
        'brand': brand,
        'model': model,
        'status': status,
        'date_bought': dateBought,
      }));

      if (response.statusCode == 200) {
        setState(() {
          // Assuming the API response returns a list of JSON objects representing appliances
          searchResults =
          List<Map<String, dynamic>>.from(json.decode(response.body)["data"]);
        });
      } else {
        setState(() {
          searchResults = [];
        });
        if (mounted) {
          showSnackBar(context, "Server Error");
        }
      }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != dateBoughtController.text) {
      setState(() {
        dateBoughtController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = min(MediaQuery.of(context).size.width, 600) as double;

    return Scaffold(
      appBar: AppBar(title: Text('Search Appliances')),
      body: SingleChildScrollView(
        child:Center(
        child:Container(
        alignment: Alignment.center,
        width: screenWidth,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormField(controller: serialNumberController, label: 'Serial Number'),
            SizedBox(height: 20),
            _buildFormField(controller: brandController, label: 'Brand'),
            SizedBox(height: 20),
            _buildFormField(controller: modelController, label: 'Model'),
            SizedBox(height: 20),
            _buildFormField(controller: statusController, label: 'Status'),
            SizedBox(height: 20),
            _buildDateBoughtFormField(),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _searchAppliances,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 20),
            if (searchResults.isNotEmpty) ..._buildSearchResults(),
          ],
        ),
      ),
    ),
      ),
    );
  }

  Widget _buildDateBoughtFormField() {
    return TextFormField(
      readOnly: true,
      controller: dateBoughtController,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Date Bought',
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
        suffixIcon: IconButton(
          onPressed: _selectDate,
          icon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }


  List<Widget> _buildSearchResults() {
    return searchResults.map((result) {
      // Assuming the API response contains properties like 'serialNumber', 'brand', 'model', 'status', 'dateBought'
      int id = result["id"];
      String serialNumber = result['serial_number'];
      String brand = result['brand'];
      String model = result['model'];
      String status = result['status'];
      String dateBought = result['date_bought'];

      return Card(
        child: ListTile(
          title: Text('Serial Number: $serialNumber'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: $brand'),
              Text('Model: $model'),
              Text('Status: $status'),
              Text('Date Bought: $dateBought'),
            ],
          ),
          onTap: () =>
          {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage(id:id.toString(), serialNumber: serialNumber,
                brand: brand,
                model: model,
                status: status,
                dataBought: dateBought, isUpdate: true)),
          )
        },
        ),
      );
    }).toList();
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
        ),
      ),
    );
  }
}
