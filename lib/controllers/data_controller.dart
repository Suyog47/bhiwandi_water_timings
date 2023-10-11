import 'dart:convert';
import 'package:bhiwandi_water_timings/api_calls/data_api.dart';
import 'package:get/get.dart';

class DataController {
  RxInt load = 0.obs;
  String response = "";
  final data = List.empty(growable: true);
  final areas = List.empty(growable: true);
  final timings = List.empty(growable: true);
  RxString news = "".obs;
  dynamic selectedArea;

  Future getData(String id) async {
      try {
        load.value = 1;
        await DataApiCalls().getData(id).then((value) {
          if (value != "error") {
            dynamic res = jsonDecode(value);
            if (res['status'] == 200) {
              response = "success";
            } else {
              response = "failure";
            }
          }
          else {
            response = "failure";
          }
        });
      } finally {
        load.value = 0;
      }
  }

  Future getAllData() async {
    data.clear();
    try {
      load.value = 1;
      await DataApiCalls().getAllData().then((value) {
        if (value != "error") {
          dynamic res = jsonDecode(value);
          if (res['status'] == 200) {
            data.addAll(res['data']);
            getAreas(res['data']);
            response = "success";
          } else {
            response = "failure";
          }
        }
        else {
          response = "failure";
        }
      });
    } finally {
      load.value = 0;
    }
  }

  void getAreas(List dt) {
    areas.clear();
    for (var e in dt) {
      if(!areas.contains(e['name'])){
        areas.add(e["name"]);
      }
    }
    getTimings(selectedArea ?? areas[0]);
  }

  void getTimings(String area) {
    timings.clear();
    for (var e in data) {
      if(e['name'] == area){
        timings.add({'id': e['timingId'], 'from': e['fromTime'], 'till': e['tillTime']});
      }
    }
    getNews(area);
  }

  void getNews(String area) {
    news.value = "";
    for (var e in data) {
      if(e['name'] == area){
        news.value = e["news"] ?? '';
        break;
      }
    }
  }
}