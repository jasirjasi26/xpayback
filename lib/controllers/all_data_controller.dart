import 'package:get/get.dart';
import '../models/employee_details_model.dart';
import '../services/all_data_service.dart';

class EmployeeDataController extends GetxController {
  var employees = [].obs;
  int offset = 0;
  EmployeeDetails? details;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  void fetchAllData() async {
    isLoading = true;
    update();
    try {
      var allDataList = await EmployeeDataService.fetchEmployeeList(offset);
      if (allDataList != null) {
        allDataList.users.forEach((element) {
          employees.add(element);
          update();
        });
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  void fetchEmployeeDetails(int index) async {
    details = null;
    try {
      var detailsResponse = await EmployeeDataService.fetchEmployeeDetails(index);
      details = detailsResponse;
      update();
    } finally {
      update();
    }
  }
}
