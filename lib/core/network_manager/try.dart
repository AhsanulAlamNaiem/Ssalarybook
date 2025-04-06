import 'dio_client.dart';

main()async{
  // Send a POST request
  final dioClient = DioClient();
  final postData = {
    'title': 'foo',
    'body': 'bar',
    'userId': 1
  };
  final response = await dioClient.post('/texts', data: postData);
  print(response.data);
}