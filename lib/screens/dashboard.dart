import 'package:bhiwandi_water_timings/constants/colors.dart';
import 'package:bhiwandi_water_timings/constants/heights.dart';
import 'package:bhiwandi_water_timings/controllers/data_controller.dart';
import 'package:bhiwandi_water_timings/utils/shared_preference_data.dart';
import 'package:bhiwandi_water_timings/utils/snackbars.dart';
import 'package:bhiwandi_water_timings/widgets/loaders.dart';
import 'package:bhiwandi_water_timings/widgets/table_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  late List<TableRow> arr = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    setTiming(_dataController.timings);
    areaNotifier =
        ValueNotifier(_dataController.selectedArea ?? _dataController.areas[0]);
    super.initState();
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            SmartRefresher(
              enablePullDown: true,
              header: const WaterDropMaterialHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
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
                                border:
                                    Border.all(color: Colors.grey, width: 2)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: ValueListenableBuilder<String>(
                                valueListenable: areaNotifier,
                                builder: (_, area, __) {
                                  return DropdownButton<String>(
                                    value: area,
                                    borderRadius: BorderRadius.circular(10),
                                    onChanged: (newValue) =>
                                        _onChanged(newValue),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                height10,
                                height10,
                                Table(
                                  border: TableBorder.all(color: blackColor),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                        decoration: const BoxDecoration(
                                          color: amberColor,
                                        ),
                                        children: [
                                          CustomTableUI()
                                              .headerTableCell(text: 'From'),
                                          CustomTableUI()
                                              .headerTableCell(text: 'Till'),
                                        ]),
                                  ],
                                ),
                                Table(
                                  border: TableBorder.all(color: blackColor),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: arr,
                                ),
                              ],
                            )
                          : const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30.0),
                              child: Text(
                                "No timings are set for this area",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    letterSpacing: 1.7),
                                textAlign: TextAlign.center,
                              ),
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
                            _newsTextController.text =
                                _dataController.news.value;
                            return Container(
                              height: 140,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: greyColor, width: 2.0),
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
                                    fontSize: 17,
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
            Obx(() {
              return FoldingCubeLoader(
                load: _dataController.load.value,
              );
            })
          ],
        ),
      ),
    );
  }

  void setTiming(dynamic timing) {
    arr.clear();
    if (timing[0]['id'] == null) {
      setState(() {
        arr = [];
      });
    } else {
      setState(() {
        timing.forEach((e) {
          arr.add(
            TableRow(
                decoration: const BoxDecoration(
                  color: lightGreyColor,
                ),
                children: [
                  CustomTableUI().bodyTableCell(text: e['from']),
                  CustomTableUI().bodyTableCell(text: e['till']),
                ]),
          );
        });
      });
    }
  }

  Future _onRefresh() async {
    await _dataController.getAllData();
    if (_dataController.response == 'success') {
      setTiming(_dataController.timings);
    } else {
      CustomSnackBar().alert(
          "Oops...something went wrong, please try again later", context,
          color: redColor);
    }
    _refreshController.refreshCompleted();
  }

  void _onChanged(area) {
    SharedPreferenceData().setData(area!);
    _dataController.selectedArea = area;
    areaNotifier.value = area;
    _dataController.getTimings(area);
    setTiming(_dataController.timings);
  }
}
