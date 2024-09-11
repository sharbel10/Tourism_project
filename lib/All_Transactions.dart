import 'dart:convert';
import 'package:comeback/main.dart';
import 'package:comeback/package_transaction_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Package_transaction_details.dart';
import 'Transaction_model.dart';

Future<TransactionResponse> fetchTransactions() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('login_token');

  final response = await http.get(Uri.parse(baseurl+'api/all/transactions'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    print(token);
    return TransactionResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load transactions');
  }
}
Future<PackageTransactionDetails?> fetchPackageTransactionDetails(int transactionId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('login_token');
  final response = await http.get(Uri.parse(baseurl+'api/package/transaction/$transactionId'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    return PackageTransactionDetails.fromJson(json.decode(response.body));
  } else {
   print("object");
    return null;
  }
}



class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}


class _TransactionPageState extends State<TransactionPage> {
  late Future<TransactionResponse> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions = fetchTransactions();
  }
  void _onTransactionTap(Transaction transaction) async {
    if (transaction.type == 'Package transaction') {
      final packageDetails = await fetchPackageTransactionDetails(transaction.id);
      if (packageDetails != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailsPage(
              packageDetails: packageDetails,
              tripId: packageDetails.tripId, // Pass the tripId here
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load package details')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions',style: TextStyle(fontFamily: "Montserrat"),),
       // backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<TransactionResponse>(
        future: futureTransactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.transactions.isEmpty) {
            return Center(child: Text('No transactions found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = snapshot.data!.transactions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Icon(
                        Icons.monetization_on,
                        color: Colors.teal,
                        size: 30,
                      ),
                      title: Text(
                        transaction.type,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Status: ${transaction.status}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Price: \$${transaction.price}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                              fontFamily: 'Montserrat'
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onTap: () => _onTransactionTap(transaction),  // Handle tap
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}


