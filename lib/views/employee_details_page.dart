import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_data_controller.dart';

class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: GetBuilder<EmployeeDataController>(builder: (snapshot) {
          return snapshot.details != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.details!.image.toString(),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) => const SizedBox(
                                width: 55,
                                height: 50,
                                child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${snapshot.details!.firstName} ${snapshot.details!.lastName}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            textWidget("Email",
                                snapshot.details!.email.toString() ?? ''),
                            textWidget("Phone",
                                snapshot.details!.phone.toString() ?? ''),
                            textWidget(
                              "Address",
                              "${snapshot.details!.address!.address}\n${snapshot.details!.address!.city}",
                            ),
                            textWidget(
                                "Age", snapshot.details!.age.toString() ?? ''),
                            textWidget("Gender",
                                snapshot.details!.gender.toString() ?? ''),
                            textWidget("Height",
                                snapshot.details!.height.toString() ?? ''),
                            textWidget("Weight",
                                snapshot.details!.weight.toString() ?? ''),
                            textWidget(
                              "Company Details",
                              "${snapshot.details!.company.name}\n${snapshot.details!.company.address.address}, \n${snapshot.details!.company.address.city}, \n${snapshot.details!.company.address.postalCode}, ${snapshot.details!.company.address.state}",
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : const Center(child: CupertinoActivityIndicator());
        }),
      ),
    );
  }

  Widget textWidget(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Text(
            "$title :  ",
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            subtitle.toString(),
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
