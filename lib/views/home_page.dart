import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../controllers/all_data_controller.dart';
import 'employee_details_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final shoppingController = Get.put(EmployeeDataController());
  var search = TextEditingController();
  var scrollController = ScrollController();
  String searchValue = "";


  @override
  void initState() {
      scrollController.addListener(() {
        if (scrollController.position.atEdge) {
          if (scrollController.position.pixels != 0) {
            shoppingController.offset = shoppingController.offset + 10;
            shoppingController.fetchAllData();
          } else {
            if (kDebugMode) {
              print('ListView scroll at top');
            }
            // Load next documents
          }
        }
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color(0xffffffff),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(6, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextFormField(
                    controller: search,
                    onChanged: (data) {
                      setState(() {
                        searchValue = search.text;
                      });
                    },
                    decoration:  InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(
                          left: 15, bottom: 5, top: 15, right: 15),
                      isDense: false,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 25.0,
                        color: Colors.grey,
                      ),
                      suffixIcon: search.text.isNotEmpty ? InkWell(
                        onTap: (){
                          search.text = "";
                          searchValue = "";
                          setState(() {
                          });
                        },
                        child: const Icon(
                          Icons.close,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ) : Container(),
                    )),
              ),
            ),
            Expanded(
              child: GetX<EmployeeDataController>(
                  builder: (controller) {
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: controller.employees.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (controller.employees[index].firstName!
                        .toLowerCase()
                        .toString()
                        .contains(searchValue.toLowerCase().toString())) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              controller.fetchEmployeeDetails(controller.employees[index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EmployeeDetailsPage(),),
                              );
                            },
                            tileColor: Colors.white,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: controller.employees[index].image
                                    .toString(),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(width:55,height:50,child: Icon(Icons.error)),
                              ),
                            ),
                            title: Text(
                              "${controller.employees[index].firstName} ${controller.employees[index].lastName}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: controller.employees[index].company != null
                                ? Text("Company : ${controller.employees[index].company!.name}")
                                : const Text("Company : No data..."),
                          ),
                          const Divider(
                            height: 3,
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }),
            ),
            GetBuilder<EmployeeDataController>(
              builder: (snapshot) => snapshot.isLoading ? Positioned(
                bottom: 10,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.red[900],
                          strokeWidth: 1.5,
                        )),
                  ),
                ),
              ) : Container()
            ),
          ],
        ),
      ),
    );
  }
}
