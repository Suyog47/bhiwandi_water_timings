import 'package:bhiwandi_water_timings/constants/colors.dart';
import 'package:bhiwandi_water_timings/constants/heights.dart';
import 'package:bhiwandi_water_timings/constants/size_helpers.dart';
import 'package:bhiwandi_water_timings/controllers/data_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final TextEditingController _newsTextController =
      TextEditingController();
  late ValueNotifier<String> areaNotifier;
  final DataController _dataController = Get.find();
  late List<TableRow> header = [];
  late List<TableRow> arr = [];

  @override
  void initState() {
    setTableHeader();
    setTiming(_dataController.timings);
    areaNotifier = ValueNotifier(_dataController.areas[0]);
    super.initState();
  }

  void setTableHeader() {
    header = [
      const TableRow(
          decoration: BoxDecoration(
            color: amberColor,
          ),
          children: [
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      "From",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )),
            TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      "Till",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )),
          ]),
    ];
  }

  void setTiming(dynamic timing) {
    setState(() {
      timing.forEach((e) {
        arr.add(
          TableRow(
              decoration: const BoxDecoration(
                color: lightGreyColor,
              ),
              children: [
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          e['from'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    )),
                TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Center(
                        child: Text(
                          e['till'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    )),
              ]),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text(
            "Dashboard",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: whiteColor),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                height30,
                Column(
                  children: [
                    const Text(
                      "Select an area",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    height10,
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 2)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      child: ValueListenableBuilder<String>(
                          valueListenable: areaNotifier,
                          builder: (_, area, __) {
                            return DropdownButton<String>(
                              value: area,
                              borderRadius: BorderRadius.circular(10),
                              onChanged: (newValue) {
                                areaNotifier.value = newValue!;
                                _dataController.getTimings(newValue);
                                setState(() {
                                  arr.clear();
                                  if (_dataController.timings[0]['from'] !=
                                      null) {
                                    setTiming(_dataController.timings);
                                  }
                                });
                              },
                              items: _dataController.areas
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                    ),
                  ],
                ),
                height30,
                height10,
                (arr.isNotEmpty)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Estimated Timings set for this area",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          height10,
                          height10,
                          Table(
                            border: TableBorder.all(color: blackColor),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: header,
                          ),
                          Table(
                            border: TableBorder.all(color: blackColor),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: arr,
                          ),
                        ],
                      )
                    : const Text(
                        "Sorry, No timings are set for this area",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                height30,
                height10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "News:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    height10,
                    Obx(() {
                      _newsTextController.text = _dataController.news.value;
                      return Container(
                        height: 140,
                        decoration: BoxDecoration(
                            border: Border.all(color: greyColor, width: 2.0),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: TextField(
                            minLines: 8,
                            maxLines: 10,
                            controller: _newsTextController,
                            enabled: false,
                            style: const TextStyle(
                              fontSize: 18,
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
