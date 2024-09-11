class PackageTransactionDetails {
final int id;
final int tripId; // This is the new field
final String packageName;
final String tripTime;
final String tripDate;
final int adultNumber;
final int childrenNumber;
final String totalPrice;
final String renterName;
final String renterEmail;

PackageTransactionDetails({
  required this.id,
  required this.tripId,
  required this.packageName,
  required this.tripTime,
  required this.tripDate,
  required this.adultNumber,
  required this.childrenNumber,
  required this.totalPrice,
  required this.renterName,
  required this.renterEmail,
});

factory PackageTransactionDetails.fromJson(Map<String, dynamic> json) {
var packageTransaction = json['data']?['package_transaction'];
if (packageTransaction == null) {
throw Exception("Package transaction data is null");
}

var trip = packageTransaction['trip'];
var transactionInfo = packageTransaction['transaction_info'];
var packageInfo = packageTransaction['package'];

return PackageTransactionDetails(
id: packageTransaction['id'] ?? 0,
tripId: trip?['id'] ?? 0, // Extracting tripId
packageName: packageInfo?['name'] ?? 'Unknown Package',
tripTime: trip?['time'] ?? 'Unknown Time',
tripDate: trip?['date']?['date'] ?? 'Unknown Date',
adultNumber: transactionInfo?['adult_number'] ?? 0,
childrenNumber: transactionInfo?['children_number'] ?? 0,
totalPrice: transactionInfo?['total_price'] ?? '0.00',
renterName: packageTransaction['renter_name'] ?? 'Unknown Renter',
renterEmail: packageTransaction['renter_email'] ?? 'Unknown Email',
);
}
}


// Future<void> _submitReview() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('login_token');
//   final url = Uri.parse(baseurl+'add/review');
//   final response = await http.post(
//     url,
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json'
//     },
//     body: json.encode({
//       'type': 'Package',
//       'trip_id': widget.tripId,
//       'title': commentController.text.isNotEmpty ? commentController.text : null,
//       'description': commentController.text,
//       'image': null // Replace with the image data if available
//     }),
//   );
//
//   final responseData = json.decode(response.body);
//
//   if (response.statusCode == 200) {
//     if (responseData['status'] == false) {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(responseData['message'] ?? 'An error occurred')),
//       );
//     } else {
//       // Handle success response
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Review submitted successfully')),
//       );
//     }
//   } else {
//     // Show error message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to submit review')),
//     );
//   }
// }
// Future<void> _submitRating(double rating) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('login_token');
//   final url = Uri.parse(baseurl+'api/rating'); // Update with your rating API endpoint
//   final response = await http.post(
//     url,
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json'
//     },
//     body: json.encode({
//       'trip_id': widget.tripId,
//       'stars': rating,
//     }),
//   );
//
//   final responseData = json.decode(response.body);
//
//   if (response.statusCode == 200) {
//     if (responseData['status'] == false) {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(responseData['message'] ?? 'An error occurred')),
//       );
//     } else {
//       // Handle success response
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Rating submitted successfully')),
//       );
//     }
//   } else {
//     // Show error message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to submit rating')),
//     );
//   }
// }
// Future<void> _deleteReview() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('login_token');
//   final url = Uri.parse(baseurl+'api/delete/review'); // Placeholder endpoint
//   final response = await http.delete(
//     url,
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: json.encode({
//       'type': 'Package',
//       'trip_id': widget.tripId,
//     }),
//   );
//
//   final responseData = json.decode(response.body);
//
//   if (response.statusCode == 200) {
//     if (responseData['status'] == false) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(responseData['message'] ?? 'An error occurred')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Review deleted successfully')),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to delete review')),
//     );
//   }
// }