import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'common.dart';

class FormPage extends StatefulWidget {
  final String id;
  final String serialNumber;
  final String brand;
  final String model;
  final String status;
  final String dataBought;
  final bool isUpdate;

  const FormPage({Key? key,
    required this.id,
    required this.serialNumber,
    required this.brand,
    required this.model,
    required this.status,
    required this.dataBought,
    required this.isUpdate}) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String serialNumber = '';
  String brand = '';
  String model = '';
  String status = '';
  final TextEditingController dateBoughtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    serialNumber = widget.serialNumber;
    brand = widget.brand;
    model = widget.model;
    status = widget.status;
    dateBoughtController.text = widget.dataBought;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Get form values

      // Send form data to the localhost API
      sendFormDataToAPI(serialNumber, brand, model, status, dateBoughtController.text);
    }
  }

  void sendFormDataToAPI(
      String serialNumber, String brand, String model, String status, String dateBought) async {

    String urlLink = 'http://$SourceIP/appliance/create';
    if(widget.isUpdate) {
      urlLink = 'http://$SourceIP/appliance/update';
    }

    try {
      final url = Uri.parse(urlLink);
      final response = await http.post(
        url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode({
          'id': widget.id,
          'serial_number': serialNumber,
          'brand': brand,
          'model': model,
          'status': status,
          'date_bought': dateBought,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully submitted the form to the API
        logger.d('Form submitted successfully!');
        if(mounted) {
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        }
        // Show a success message to the user if needed
      } else {
        // Failed to submit the form
        logger.d('Failed to submit the form. Error: ${response.statusCode}');
        // Show an error message to the user if needed

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
      var dateBoughtStr = pickedDate.toLocal().toString().split(' ')[0];
      setState(() {
        logger.d(dateBoughtStr);
        dateBoughtController.text = dateBoughtStr;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String buttonName = "Submit";
    if(widget.isUpdate) {
      buttonName = "Update";
    }

    final screenWidth = min(MediaQuery.of(context).size.width, 600) as double;

    return Scaffold(
      appBar: AppBar(title: Text('Appliance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child:Container(
          alignment: Alignment.center,
          width: screenWidth,
          child:Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: serialNumber,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Serial Number',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.confirmation_number_outlined, size: 24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty && value.length > 200) {
                    return 'Please enter Valid Serial Number';
                  }
                  return null;
                },
                onSaved: (value) => {
                  serialNumber = value!
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: brand,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Brand',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.branding_watermark_outlined, size: 24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty && value.length > 200) {
                    return 'Please enter legit Value';
                  }
                  return null;
                },
                onSaved: (value) => {
                  brand = value!
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: model,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Model',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.mobile_friendly_outlined, size: 24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty && value.length > 200) {
                    return 'Please enter valid Model';
                  }
                  return null;
                },
                onSaved: (value) => {
                  model = value!
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                initialValue: status,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.check_circle_outline, size: 24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).hintColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty && value.length > 200) {
                    return 'Please enter valid Status';
                  }
                  return null;
                },
                onSaved: (value) => {
                  status = value!
                },
              ),

              SizedBox(height: 20),
              _buildDateBoughtFormField(),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(buttonName),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
          ),
        )
      ),
    );
  }

  Widget _buildDateBoughtFormField() {
    return TextFormField(
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
}
