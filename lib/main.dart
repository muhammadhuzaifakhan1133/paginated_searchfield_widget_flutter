import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginatedsearchfield_example/search_field_widget.dart';
import 'package:paginatedsearchfield_example/utils/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:searchfield/searchfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LeaveSearchPage(),
    );
  }
}

class LeaveModel {
  int? id;
  SysUser? sysUser;
  String? name;
  String? date;

  LeaveModel({this.id, this.sysUser, this.name, this.date});

  LeaveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sysUser = json['sys_user'] != null
        ? new SysUser.fromJson(json['sys_user'])
        : null;
    name = json['name'];
    date = json['date'];
  }
}

class SysUser {
  int? uid;
  String? name;

  SysUser({this.uid, this.name});

  SysUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
  }
}

class LeaveSearchPageController extends GetxController {
  List<LeaveModel> leaves = [];
  int currentPage = 1;
  bool isDataFetched = false;
  bool hasMoreData = true;
  bool isLoading = false;

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  getLeaves(String search, int page) async {
    String url =
        "https://demo.softcodix.com/attendance/api/leave/?page=$page&search=$search";
    print(url);
    final response = await http.get(Uri.parse(url), headers: {
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM0NzAwNTI1LCJpYXQiOjE3MzQ2MTQxMjUsImp0aSI6IjA0ZTY4YTZkOGNhMTQzNmE5MmMwZDM0ZDQzMWJmN2UwIiwidXNlcl9pZCI6MX0.qx1kRFt3nmYrEy6ayrB_U8FcUxn4j9FUYH4BiMeSqJg"
    });
    final data = jsonDecode(response.body);
    print("Fetched Data: $data");
    int count = 1;
    for (var holiday in data["results"]) {
      final leaveModel = LeaveModel.fromJson(holiday);
      leaves.add(leaveModel);
      count++;
    }
    print("Leaves Count: ${leaves.length}");
    if (count < 10) {
      hasMoreData = false;
    }
  }
}

class LeaveSearchPage extends StatefulWidget {
  @override
  State<LeaveSearchPage> createState() => _LeaveSearchPageState();
}

class _LeaveSearchPageState extends State<LeaveSearchPage> {
  late LeaveSearchPageController controller;

  hello() async {
    await controller.getLeaves("", 1);
    controller.isDataFetched = true;
    controller.update();
  }

  @override
  void initState() {
    controller = Get.put(LeaveSearchPageController());
    hello();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveSearchPageController>(builder: (_) {
      if (!controller.isDataFetched) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Leave Search'),
          backgroundColor: AppColors.appThemeColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchableTextfield(
                  // New Param: whether more data exist on server
                  hasMore: controller.hasMoreData,
                  // New param: fetching new page for existing query
                  onFetchNextPage: (query, page) async {
                    controller.currentPage = page;
                    await controller.getLeaves(query, page);
                    controller.update();
                  },
                  // New param: fetching suggestion for new query
                  onFetchNewSuggestion: (query) async {
                    controller.leaves.clear();
                    controller.currentPage = 1;
                    controller.hasMoreData = true;

                    controller.isLoading = true;
                    controller.update();
                    await controller.getLeaves(query, 1);
                    controller.isLoading = false;
                    controller.update();
                  },
                  // New param: whether loading in progress or not
                  isLoading: controller.isLoading,
                  // New Param: current running page for the data
                  currentPage: controller.currentPage,
                  
                  onSubmit: (p0) {
                    // controller.enableFocusOfIthRowJthColumn(
                    //     destinationRow: i, destinationColumn: 1);
                  },
                  hintText: "Account Title",
                  width: Get.context!.width <= 1370
                      ? 180
                      : Get.context!.width * 0.1313,
                  focusNode: controller.focusNode,
                  textController: controller.textController,
                  suggestions: controller.leaves,
                  selectKey: (e) {
                    final leave = e as LeaveModel;
                    return leave.name ?? "";
                  },
                  showValue: (e) {
                    final leave = e as LeaveModel;
                    return leave.name ?? "";
                  },
                  onSuggestionTap: (SearchFieldListItem selectedField) {
                    // final selectedAccount =
                    //     selectedField.item as AccountModel;
                    // controller.formAccounts[i] = selectedAccount;
                    // // controller.selectedAccounts(selectedAccount);
                    // controller.enableFocusOfIthRowJthColumn(
                    //     destinationRow: i, destinationColumn: 1);
                  }),
            ),
          ],
        ),
      );
    });
  }
}
