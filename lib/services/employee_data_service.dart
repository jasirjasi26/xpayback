import 'package:http/http.dart' as http;
import 'package:untitled1/utils/api_urls.dart';
import '../models/employee_details_model.dart';
import '../models/employee_list_model.dart';

class EmployeeDataService{
  static var client=http.Client();

  static Future<EmployeeList?> fetchEmployeeList(int offset) async{
    var response = await client.get(Uri.parse(APIUrls.getEmployeeList + offset.toString()));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return employeeListFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }


  static Future<EmployeeDetails?> fetchEmployeeDetails(int index) async{
    var response = await client.get(Uri.parse(APIUrls.getEmployeeDetails + index.toString()));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return employeeDetailsFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}