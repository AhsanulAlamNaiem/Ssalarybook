import 'package:http/http.dart' as http;

main()async{
  String signupRequests = 'https://salary-book.onrender.com/api/usermanagement/employee-details/';
  final postData = {
    "cookie": "csrftoken=dcFafsIaYI8MoIB7Sio0injGSE8d6I3l; sessionid=2ealmw2x3b8lhzhtwshstpure6lqcjce",
    "Authorization": "Token aea48c3164773e1510541e24f57e4fa745a6b0e9"
  };
  final response = await http.get(Uri.parse(signupRequests), headers: postData);
  print(response.body);
}