import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../controllers/employee_data_controller.dart';
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

  Widget setPage() {
    Color? colorTheme = Colors.blue[300];

    return Stack(
      children: <Widget>[
        Container(
          // Background
          color: colorTheme,
          height: MediaQuery.of(context).size.height * 0.205,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          // To take AppBar Size only
          top: 100.0,
          left: 20.0,
          right: 20.0,
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.search, color: colorTheme),
              onPressed: () {},
            ),
            primary: false,
            title: TextField(
                controller: search,
                onChanged: (data) {
                  setState(() {
                    searchValue = search.text;
                  });
                },
                decoration: const InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey))),
            actions: <Widget>[
              search.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        search.text = "";
                        searchValue = "";
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          size: 22.0,
                          color: colorTheme,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: setPage(),
      ),
      body: SafeArea(
        child: GetX<EmployeeDataController>(builder: (controller) {
          return  controller.employees.length > 0 ?Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: controller.employees.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (controller.employees[index].firstName!
                          .toLowerCase()
                          .toString()
                          .contains(searchValue.toLowerCase().toString()) ||
                          controller.employees[index].lastName!
                              .toLowerCase()
                              .toString()
                              .contains(searchValue.toLowerCase().toString())) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                controller.fetchEmployeeDetails(
                                    controller.employees[index].id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const EmployeeDetailsPage(),
                                  ),
                                );
                              },
                              tileColor: Colors.white,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: controller.employees[index].image
                                      .toString(),
                                  progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  const SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CupertinoActivityIndicator()),
                                  errorWidget: (context, url, error) =>
                                  const SizedBox(
                                      width: 55,
                                      height: 50,
                                      child: Icon(Icons.error)),
                                ),
                              ),
                              title: Text(
                                "${controller.employees[index].firstName} ${controller.employees[index].lastName}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle:
                              controller.employees[index].company != null
                                  ? Text(
                                "Company : ${controller.employees[index].company!.name}",
                                style: const TextStyle(fontSize: 12),
                              )
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
                  )
                ),
                controller.isLoading
                    ? Positioned(
                  bottom: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CupertinoActivityIndicator(
                            color: Colors.grey[900],
                          )),
                    ),
                  ),
                )
                    : Container()
              ],
            ) : Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CupertinoActivityIndicator(
                  color: Colors.grey[900],
                )),
            );
          }
        ),
      ),
    );
  }
}
