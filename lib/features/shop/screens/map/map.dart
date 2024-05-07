import 'dart:async';
import 'dart:math';

import 'package:bluecart1/common/widgets/appbar/appbar.dart';
import 'package:bluecart1/utils/constants/image_strings.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import '../../../../ble/ble_scanner.dart';
import '../../../../providers/cart.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Stream<StepCount> _stepCountStream;
  int _steps = 0; // Initialize steps as an integer
  late final FlutterReactiveBle _ble;
  final List<DiscoveredDevice> _devices = [];
  late StreamSubscription _subscription;
  bool _isScanning = false;
  bool _isStarted = false;

  void updateSelectList(List<int> newList) {
    setState(() {
      selectList = newList;
    });
  }

  void resetRSSI(Map<String, int> newList, int i) {
    setState(() {
      rssiIdMap.forEach((deviceId, _) {
        rssiIdMap[deviceId] = i;
      });
    });
  }

  void updateRssiValue(String deviceId, int rssiValue) {
    setState(() {
      if (rssiIdMap.containsKey(deviceId)) {
        rssiIdMap[deviceId] = rssiValue;
      }
    });
  }

  void updateRSSI(int i) {
    setState(() {
      lowestRssi = i;
    });
  }

  void markerPos() {
    setState(() {
      print(startVertex);
      if (startVertex == 0) {
        markerX = 74;
        markerY = 355;
      } else if (startVertex == 1) {
        markerX = 182;
        markerY = 355;
      } else if (startVertex == 2) {
        markerX = 289;
        markerY = 355;
      } else if (startVertex == 3) {
        markerX = 74;
        markerY = 185;
      } else if (startVertex == 4) {
        markerX = 182;
        markerY = 185;
      } else if (startVertex == 5) {
        markerX = 289;
        markerY = 185;
      } else if (startVertex == 6) {
        markerX = 74;
        markerY = 10;
      } else if (startVertex == 7) {
        markerX = 182;
        markerY = 10;
      } else if (startVertex == 8) {
        markerX = 289;
        markerY = 10;
      }
    });
  }

  void setDefaultSizePath() {
    setState(() {
      w12 = 191;
      w21 = 81;
      w01 = 81;
      w10 = 186;
      w36 = 192;
      w63 = 18;
      w03 = 22;
      w30 = 193;
    });
  }

  void updateLocation(int l) {
    setState(() {
      startVertex = l;
    });
  }

  void updateLocationC(int l) {
    setState(() {
      startVertexC = l;
    });
  }

  void updateResultList(List<int> newList) {
    setState(() {
      resultList = newList;
    });
  }

  void updaten01(bool v) {
    setState(() {
      n01 = v;
    });
  }

  void updaten03(bool v) {
    setState(() {
      n03 = v;
    });
  }

  void updaten12(bool v) {
    setState(() {
      n12 = v;
    });
  }

  void updaten14(bool v) {
    setState(() {
      n14 = v;
    });
  }

  void updaten25(bool v) {
    setState(() {
      n25 = v;
    });
  }

  void updaten34(bool v) {
    setState(() {
      n34 = v;
    });
  }

  void updaten36(bool v) {
    setState(() {
      n36 = v;
    });
  }

  void updaten45(bool v) {
    setState(() {
      n45 = v;
    });
  }

  void updaten47(bool v) {
    setState(() {
      n47 = v;
    });
  }

  void updaten58(bool v) {
    setState(() {
      n58 = v;
    });
  }

  void updaten67(bool v) {
    setState(() {
      n67 = v;
    });
  }

  void updaten78(bool v) {
    setState(() {
      n78 = v;
    });
  }

  void isReached(bool v) {
    setState(() {
      isReach = v;
    });
  }

  void updateTextMessage(String i) {
    setState(() {
      textMessage = i;
    });
  }

  final database = FirebaseDatabase.instance.ref();
  FirebaseFunctions functions = FirebaseFunctions.instance;
  String textMessage =
      'Please move to a corner or junction for precise location';
  int startVertex = 0;
  int startVertexC = 0;
  int lowestRssi = -100;
  bool isReach = false;
  double markerX = 76;
  double markerY = 356;
  Map<String, int> keyIdMap = {
    '64:B7:08:50:B0:6E': 0,
    '64:B7:08:4F:A1:A6': 1,
    '64:B7:08:4F:06:1E': 2,
    '34:98:7A:71:74:DE': 3,
    '34:98:7A:71:72:46': 4,
    '64:B7:08:4F:53:32': 5,
    '34:98:7A:71:7E:B6': 6,
    '08:D1:F9:98:07:F6': 7,
    '08:B6:1F:3C:40:7E': 8,
  };
  Map<String, int> rssiIdMap = {
    '64:B7:08:50:B0:6E': -999,
    '64:B7:08:4F:A1:A6': -999,
    '64:B7:08:4F:06:1E': -999,
    '34:98:7A:71:74:DE': -999,
    '34:98:7A:71:72:46': -999,
    '64:B7:08:4F:53:32': -999,
    '34:98:7A:71:7E:B6': -999,
    '08:D1:F9:98:07:F6': -999,
    '08:B6:1F:3C:40:7E': -999,
  };
  bool n01 = false;
  bool n03 = false;
  bool n12 = false;
  bool n14 = false;
  bool n25 = false;
  bool n34 = false;
  bool n36 = false;
  bool n47 = false;
  bool n45 = false;
  bool n58 = false;
  bool n67 = false;
  bool n78 = false;
  late List<dynamic> cList;
  List<int> newList = [];
  List<int> selectList = [];
  List<int> resultList = [];
  double? heading = 0;
  // int _steps = 0;
  double w12 = 191;
  double w21 = 81;
  double w01 = 81;
  double w10 = 186;
  double w36 = 192;
  double w63 = 18;
  double w03 = 22;
  double w30 = 193;

  @override
  void initState() {
    super.initState();
    _ble = FlutterReactiveBle();
    _activateListeners();
    _initCompass();
    _initStreams();
  }

  void _initStreams() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      setState(() {
        _steps = event.steps; // Store steps as an integer
      });
    }, onError: (error) {
      setState(() {
        _steps = 0; // Reset steps in case of error
      });
      print('Step Count Error: $error');
    });
  }

  void _initCompass() {
    FlutterCompass.events!.listen((event) {
      setState(() {
        heading = event.heading;
      });
    });
  }

  Future<void> callFirebaseFunction(List<dynamic> dataList) async {
    cList = Provider.of<CartProvider>(context, listen: false).cartItems;
    print('prov list: $cList');
    final Map<String, int> referenceMap = {
      'A102': 0,
      'A103': 3,
      'A104': 6,
      'C102': 2,
      'C103': 5,
      'C104': 8,
      'Front Office': 1,
      'Back Office': 7,
    };
    final List<int> DList = [];
    cList.forEach((item) {
      // Check if item is a key in the referenceMap
      if (referenceMap.containsKey(item)) {
        // Add the corresponding value to the newList
        // context.read<CartIDProvider>().addItemToCart(item: item);
        DList.add(referenceMap[item]!);
        selectList.add(referenceMap[item]!);
      }
    });
    DList.sort();
    selectList.sort();
    selectList = selectList.toSet().toList();
    print("selectList: $selectList");
    print('map List: $DList');
    try {
      updateSelectList(selectList);
      final HttpsCallable algoFunction =
          FirebaseFunctions.instance.httpsCallable('calculateSquare');

      if (DList.contains(startVertex)) {
        DList.remove(startVertex);
      }
      print('map updated List: $DList');
      // dataList.sort();
      final HttpsCallableResult response = await algoFunction.call({
        'start_vertex': startVertex,
        'productList': DList,
        'dataList': dataList,
      });

      print('Response from Firebase function: ${response.data['result']}');
      resultList =
          response.data['result'].toString().split('').map(int.parse).toList();
      print('Result list: $resultList');
      updateResultList(resultList);
      // setOutput(response.data['result']);
      updaten01(false);
      updaten03(false);
      updaten12(false);
      updaten14(false);
      updaten25(false);
      updaten34(false);
      updaten36(false);
      updaten45(false);
      updaten47(false);
      updaten58(false);
      updaten67(false);
      updaten78(false);
      for (int i = 0; i < resultList.length - 1; i += 1) {
        int currentValue = resultList[i];
        int nextValue = resultList[i + 1];
        int pathValue = (currentValue * 10) + nextValue;
        if (currentValue == 0) {
          if (nextValue == 1) {
            updaten01(true);
          }
          if (nextValue == 3) {
            updaten03(true);
          }
        }
        if (pathValue > 9) {
          if (pathValue == 10) {
            updaten01(true);
          }
          if (pathValue == 30) {
            updaten03(true);
          }
          if (pathValue == 14 || pathValue == 41) {
            updaten14(true);
          }
          if (pathValue == 12 || pathValue == 21) {
            updaten12(true);
          }
          if (pathValue == 34 || pathValue == 43) {
            updaten34(true);
          }
          if (pathValue == 45 || pathValue == 54) {
            updaten45(true);
          }
          if (pathValue == 25 || pathValue == 52) {
            updaten25(true);
          }
          if (pathValue == 36 || pathValue == 63) {
            updaten36(true);
          }
          if (pathValue == 74 || pathValue == 47) {
            updaten47(true);
          }
          if (pathValue == 58 || pathValue == 85) {
            updaten58(true);
          }
          if (pathValue == 67 || pathValue == 76) {
            updaten67(true);
          }
          if (pathValue == 78 || pathValue == 87) {
            updaten78(true);
          }
        }
        // Do something with currentValue and nextValue
        print('$currentValue, $nextValue');
        print('$pathValue');
        pathValue = 0;
      }
    } catch (error) {
      print('Error calling Firebase function: $error');
    }
  }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _activateListeners();
  //   _initCompass();
  // }

  // void _initCompass() {
  //   FlutterCompass.events!.listen((event) {
  //     setState(() {
  //       heading = event.heading;
  //     });
  //   });
  // }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
    });

    _subscription = _ble.scanForDevices(withServices: []).listen((device) {
      setState(() {
        if (device.id == '64:B7:08:50:B0:6E' ||
            device.id == '64:B7:08:4F:A1:A6' ||
            device.id == '64:B7:08:4F:06:1E' ||
            device.id == '34:98:7A:71:74:DE' ||
            device.id == '34:98:7A:71:72:46' ||
            device.id == '64:B7:08:4F:53:32' ||
            device.id == '34:98:7A:71:7E:B6' ||
            device.id == '08:D1:F9:98:07:F6' ||
            device.id == '08:B6:1F:3C:40:7E') {
          if (device.rssi > -85) {
            final index = _devices.indexWhere((d) => d.id == device.id);
            if (index != -1) {
              _devices[index] = device;
            } else {
              _devices.add(device);
            }
            updateRssiValue(device.id, device.rssi);
            // if (device.rssi > lowestRssi) {
            //   lowestRssi = device.rssi;
            //   int i = keyIdMap[device.id]!;
            //   updateRSSI(lowestRssi);
            //   updateLocation(i);
            // }
            // if (_devices.isEmpty) {
            //   updateLocation(-1);
            // }

            print(_devices);
          }
        }
      });
    });
  }

  Future<void> currentLocation() async {
    int n = -999;
    String id = '';
    int i = 0;
    int x = 0;
    resetRSSI(rssiIdMap, -999);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wait a few seconds for the live location update',
            style: TextStyle(color: TColors.white)),
        duration: Duration(seconds: 3),
        backgroundColor: TColors.dark,
        // Adjust duration as needed
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    rssiIdMap.forEach((key, value) {
      i = i + 1;
      if (value > n) {
        n = value;
        String id = key;
        x = i - 1;
      }
    });
    updateLocation(x);
    markerPos();
  }

  Future<void> currentLocate() async {
    int n = -999;
    String id = '';
    int i = 0;
    int x = 0;
    resetRSSI(rssiIdMap, -999);
    await Future.delayed(const Duration(seconds: 4));
    rssiIdMap.forEach((key, value) {
      i = i + 1;
      if (value > n) {
        n = value;
        String id = key;
        x = i - 1;
      }
    });
    updateLocation(x);
    // markerPos();
  }

  void _start() {
    currentLocation();
    _startScan();
  }

  void start() async {
    setState(() {
      _isStarted = true;
    });
    updaten01(false);
    updaten03(false);
    updaten12(false);
    updaten14(false);
    updaten25(false);
    updaten34(false);
    updaten36(false);
    updaten45(false);
    updaten47(false);
    updaten58(false);
    updaten67(false);
    updaten78(false);
    List<int> tempResult = resultList;
    List<int> tempSelect = selectList;
    // print(tempSelect);
    for (int i = 0; i < tempResult.length - 1; i++) {
      double compass;

      isReached(false);
      // print(tempResult[i]);
      print(tempResult[i]);
      if (tempResult[i] == 0) {
        if (tempResult[i + 1] == 1) {
          int stepTotal = 0;
          updaten01(true);
          isReached(false);
          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 320 || compass < 50) {
              stepTotal = stepTotal + stepp;
              m01(22, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('The front office is on your left');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
                print("hi");
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten01(false);
          }
        }
      }
      if (tempResult[i] == 3) {
        if (tempResult[i + 1] == 4) {
          int stepTotal = 0;
          updaten34(true);

          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 320 || compass < 50) {
              stepTotal = stepTotal + stepp;
              m01(18, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten34(false);
          }
        }
      }
      if (tempResult[i] == 6) {
        if (tempResult[i + 1] == 7) {
          int stepTotal = 0;

          updaten67(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }

            if (compass >= 320 || compass < 50) {
              stepTotal = stepTotal + stepp;
              m01(18, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  if (tempResult[i + 1] == 7) {
                    updateTextMessage('The back office is on your right');
                  }
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten67(false);
          }
        }
      }
      if (tempResult[i] == 1) {
        if (tempResult[i + 1] == 0) {
          int stepTotal = 0;
          updaten01(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 140 && compass < 230) {
              stepTotal = stepTotal + stepp;
              m10(22, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is ahead of you');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten01(false);
          }
        }
      }
      if (tempResult[i] == 4) {
        if (tempResult[i + 1] == 3) {
          int stepTotal = 0;
          updaten34(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 140 && compass < 230) {
              stepTotal = stepTotal + stepp;
              m10(18, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is ahead of you');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten34(false);
          }
        }
      }
      if (tempResult[i] == 7) {
        if (tempResult[i + 1] == 6) {
          int stepTotal = 0;
          updaten67(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 140 && compass < 230) {
              stepTotal = stepTotal + stepp;
              m10(18, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is ahead of you');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten67(false);
          }
        }
      }
      if (tempResult[i] == 1) {
        if (tempResult[i + 1] == 2) {
          int stepTotal = 0;
          updaten12(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 320 || compass < 50) {
              stepTotal = stepTotal + stepp;
              m12(18, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is ahead of you');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten12(false);
          }
        }
      }
      if (tempResult[i] == 4) {
        if (tempResult[i + 1] == 5) {
          int stepTotal = 0;
          updaten45(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 320 || compass < 50) {
              stepTotal = stepTotal + stepp;
              m12(19, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is ahead of you');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten45(false);
          }
        }
      }
      if (tempResult[i] == 7) {
        if (tempResult[i + 1] == 8) {
          int stepTotal = 0;
          updaten78(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 320 || compass < 50) {
              stepTotal = stepTotal + stepp;
              m12(21, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is ahead of you');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten78(false);
          }
        }
      }
      if (tempResult[i] == 2) {
        if (tempResult[i + 1] == 1) {
          int stepTotal = 0;
          updaten12(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 140 && compass < 230) {
              stepTotal = stepTotal + stepp;
              m21(18, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('The front office is on your right');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten12(false);
          }
        }
      }
      if (tempResult[i] == 5) {
        if (tempResult[i + 1] == 4) {
          int stepTotal = 0;
          updaten45(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 140 && compass < 230) {
              stepTotal = stepTotal + stepp;
              m21(19, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                // if (selectList.contains(tempResult[i + 1])) {
                //
                //   updateTextMessage('Your destination is ahead of you');
                // }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten45(false);
          }
        }
      }
      if (tempResult[i] == 8) {
        if (tempResult[i + 1] == 7) {
          int stepTotal = 0;
          updaten78(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 140 && compass < 230) {
              stepTotal = stepTotal + stepp;
              m21(21, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('The back office is on your left');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten78(false);
          }
        }
      }
      if (tempResult[i] == 0) {
        if (tempResult[i + 1] == 3) {
          int stepTotal = 0;
          updaten03(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 230 && compass < 320) {
              stepTotal = stepTotal + stepp;
              m03(20, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your left');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten03(false);
          }
        }
      }
      if (tempResult[i] == 1) {
        if (tempResult[i + 1] == 4) {
          int stepTotal = 0;
          updaten14(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 230 && compass < 320) {
              stepTotal = stepTotal + stepp;
              m03(20, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                // if (selectList.contains(tempResult[i + 1])) {
                //
                //   updateTextMessage('Your destination is ahead of you');
                // }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten14(false);
          }
        }
      }
      if (tempResult[i] == 2) {
        if (tempResult[i + 1] == 5) {
          int stepTotal = 0;
          updaten25(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 230 && compass < 320) {
              stepTotal = stepTotal + stepp;
              m03(20, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your right');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten25(false);
          }
        }
      }
      if (tempResult[i] == 3) {
        if (tempResult[i + 1] == 0) {
          int stepTotal = 0;
          updaten03(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 50 && compass < 140) {
              stepTotal = stepTotal + stepp;
              m30(20, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your right');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten03(false);
          }
        }
      }
      if (tempResult[i] == 4) {
        if (tempResult[i + 1] == 1) {
          int stepTotal = 0;
          updaten14(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 50 && compass < 140) {
              stepTotal = stepTotal + stepp;
              m30(20, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                // if (selectList.contains(tempResult[i + 1])) {
                //
                //   updateTextMessage('Your destination is on your left');
                // }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten14(false);
          }
        }
      }
      if (tempResult[i] == 5) {
        if (tempResult[i + 1] == 2) {
          int stepTotal = 0;
          updaten25(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 50 && compass < 140) {
              stepTotal = stepTotal + stepp;
              m30(20, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your left');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten25(false);
          }
        }
      }
      if (tempResult[i] == 3) {
        if (tempResult[i + 1] == 6) {
          int stepTotal = 0;
          updaten36(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 230 && compass < 320) {
              stepTotal = stepTotal + stepp;
              m36(29, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your left');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten36(false);
          }
        }
      }
      if (tempResult[i] == 4) {
        if (tempResult[i + 1] == 7) {
          int stepTotal = 0;
          updaten47(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 230 && compass < 320) {
              stepTotal = stepTotal + stepp;
              m36(29, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                // if (selectList.contains(tempResult[i + 1])) {
                //
                //   updateTextMessage('Your destination is on your left');
                // }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten47(false);
          }
        }
      }
      if (tempResult[i] == 5) {
        if (tempResult[i + 1] == 8) {
          int stepTotal = 0;
          updaten58(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 230 && compass < 320) {
              stepTotal = stepTotal + stepp;
              m36(29, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your right');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten58(false);
          }
        }
      }
      if (tempResult[i] == 6) {
        if (tempResult[i + 1] == 3) {
          int stepTotal = 0;
          updaten36(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 50 && compass < 140) {
              stepTotal = stepTotal + stepp;
              m63(29, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your right');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten36(false);
          }
        }
      }
      if (tempResult[i] == 7) {
        if (tempResult[i + 1] == 4) {
          int stepTotal = 0;
          updaten47(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 50 && compass < 140) {
              stepTotal = stepTotal + stepp;
              m63(29, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                // if (selectList.contains(tempResult[i + 1])) {
                //
                //   updateTextMessage('Your destination is on your left');
                // }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten47(false);
          }
        }
      }
      if (tempResult[i] == 8) {
        if (tempResult[i + 1] == 5) {
          int stepTotal = 0;
          updaten58(true);
          isReached(false);

          while (isReach == false) {
            int temps = _steps;
            int stepp = 0;
            await Future.delayed(const Duration(seconds: 1));
            if (heading! < 0) {
              compass = (heading! + 360);
            } else {
              compass = heading!;
            }
            print(compass);
            currentLocate();
            if (temps < _steps) {
              stepp = _steps - temps;
              temps = _steps;
            }
            if (compass >= 50 && compass < 140) {
              stepTotal = stepTotal + stepp;
              m63(29, tempResult[i + 1], stepTotal);
              if (startVertex == tempResult[i + 1]) {
                isReached(true);
                if (selectList.contains(tempResult[i + 1])) {
                  updateTextMessage('Your destination is on your left');
                }
              } else {
                updateTextMessage('Move slightly according to the map');
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Face the correct direction and proceed forward',
                      style: TextStyle(color: TColors.warning)),
                  duration: Duration(seconds: 2),
                  backgroundColor: TColors.dark,
                  // Adjust duration as needed
                ),
              );
            }
          }
          print("infinte loop");
          if (isReach == true) {
            updaten58(false);
          }
        }
      }
      if (tempResult[i + 1] == startVertex) {
        // updateLocation(tempResult[i + 1]);
        markerPos();
      }
    }
  }

  void m01(int st, int x, int stepTotal) async {
    // double compass = 0;
    // print(_steps);
    // while (isReach == false) {
    //   await Future.delayed(Duration(seconds: 1));
    // currentLocate();
    // if (startVertex == x) {
    //   isReached(true);
    // }

    // print('map updated List: $stepTotal');

    // if (heading! < 0) {
    //   compass = (heading! + 360);
    // } else {
    //   compass = heading!;
    // }
    // int stepTotal = 0;
    // int temps = _steps;
    //   int stepp = 0;
    //   if (temps < _steps) {
    //     stepp = _steps - temps;
    //     temps = _steps;
    //   }
    // print('compass value: $compass');
    // if (compass >= 320 || compass < 50) {
    //   stepTotal = stepTotal + stepp;
    // } else {
    //   // stepTotal = stepTotal - stepp;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Face the correct direction and proceed forward',
    //           style: TextStyle(color: TColors.warning)),
    //       duration: Duration(seconds: 2),
    //       backgroundColor: TColors.dark,
    //       // Adjust duration as needed
    //     ),
    //   );
    // }
    // print('hi');
    // currentLocate();
    // if (startVertex == x) {
    //   isReached(true);
    //   if (selectList.contains(x)) {
    //     if (x == 1) {
    //       updateTextMessage('The front office is on your left');
    //     } else if (x == 7) {
    //       updateTextMessage('The back office is on your right');
    //     }
    //   }
    // } else {
    //   updateTextMessage('Move slightly according to the map');
    // }
    // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       if (x == 1) {
    //         updateTextMessage('The front office is on your left');
    //       } else if (x == 7) {
    //         updateTextMessage('The back office is on your right');
    //       }
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w01 = 181;
        markerX = 174;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w01 = 161;
        markerX = 154;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w01 = 141;
        markerX = 134;
      });
    } else if (stepTotal > st - 14) {
      setState(() {
        w01 = 121;
        markerX = 114;
      });
    } else if (stepTotal > st - 17) {
      setState(() {
        w01 = 101;
        markerX = 94;
      });
    }
    // }
  }

  void m10(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (isReach == false) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    // if (temps < _steps) {
    //   stepp = _steps - temps;
    //   temps = _steps;
    // }
    // print('compass value: $compass');
    // if (compass >= 140 && compass < 230) {
    //   // stepTotal = stepTotal + stepp;
    // } else {
    //   // stepTotal = stepTotal - stepp;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Face the correct direction and proceed forward',
    //           style: TextStyle(color: TColors.warning)),
    //       duration: Duration(seconds: 2),
    //       backgroundColor: TColors.dark,
    //       // Adjust duration as needed
    //     ),
    //   );
    // }
    // // if (stepTotal > st) {
    // currentLocate();
    // if (startVertex == x) {
    //   isReached(true);
    //   if (selectList.contains(x)) {
    //     updateTextMessage('Your destination is ahead of you');
    //   }
    // } else {
    //   updateTextMessage('Move slightly according to the map');
    // }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w10 = 286;
        markerX = 94;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w10 = 266;
        markerX = 114;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w10 = 246;
        markerX = 134;
      });
    } else if (stepTotal > st - 14) {
      setState(() {
        w10 = 226;
        markerX = 154;
      });
    } else if (stepTotal > st - 17) {
      setState(() {
        w10 = 206;
        markerX = 174;
      });
    }
    // }
  }

  void m12(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (stepTotal <= 24) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    //   // if (temps < _steps) {
    //   //   stepp = _steps - temps;
    //   //   temps = _steps;
    //   // }
    //   print('compass value: $compass');
    //   if (compass >= 320 || compass < 50) {
    //     // stepTotal = stepTotal + stepp;
    //   } else {
    //     // stepTotal = stepTotal - stepp;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Face the correct direction and proceed forward',
    //             style: TextStyle(color: TColors.warning)),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: TColors.dark,
    //         // Adjust duration as needed
    //       ),
    //     );
    //   }
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       updateTextMessage('Your destination is ahead of you');
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       updateTextMessage('Your destination is ahead of you');
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w12 = 286;
        markerX = 282;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w12 = 271;
        markerX = 262;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w12 = 251;
        markerX = 242;
      });
    } else if (stepTotal > st - 13) {
      setState(() {
        w12 = 231;
        markerX = 222;
      });
    } else if (stepTotal > st - 16) {
      setState(() {
        w12 = 211;
        markerX = 202;
      });
      // }
    }
  }

  void m21(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (stepTotal <= 24) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    //   // if (temps < _steps) {
    //   //   stepp = _steps - temps;
    //   //   temps = _steps;
    //   // }
    //   print('compass value: $compass');
    //   if (compass >= 140 && compass < 230) {
    //     // stepTotal = stepTotal + stepp;
    //   } else {
    //     // stepTotal = stepTotal - stepp;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Face the correct direction and proceed forward',
    //             style: TextStyle(color: TColors.warning)),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: TColors.dark,
    //         // Adjust duration as needed
    //       ),
    //     );
    //   }
    //   // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       if (x == 1) {
    //         updateTextMessage('The front office is on your right');
    //       } else if (x == 7) {
    //         updateTextMessage('The back office is on your left');
    //       }
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w21 = 181;
        markerX = 189;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w21 = 181;
        markerX = 209;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w21 = 141;
        markerX = 229;
      });
    } else if (stepTotal > st - 14) {
      setState(() {
        w21 = 121;
        markerX = 249;
      });
    } else if (stepTotal > st - 17) {
      setState(() {
        w21 = 101;
        markerX = 269;
      });
      // }
    }
  }

  void m03(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (stepTotal <= 24) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    //   // if (temps < _steps) {
    //   //   stepp = _steps - temps;
    //   //   temps = _steps;
    //   // }
    //   print('compass value: $compass');
    //   if (compass >= 230 && compass < 320) {
    //     // stepTotal = stepTotal + stepp;
    //   } else {
    //     // stepTotal = stepTotal - stepp;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Face the correct direction and proceed forward',
    //             style: TextStyle(color: TColors.warning)),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: TColors.dark,
    //         // Adjust duration as needed
    //       ),
    //     );
    //   }
    //   // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       if (x == 3) {
    //         updateTextMessage('Your destination is on your left');
    //       } else if (x == 5) {
    //         updateTextMessage('Your destination is on your right');
    //       }
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w03 = 172;
        markerY = 205;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w03 = 142;
        markerY = 235;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w03 = 112;
        markerY = 265;
      });
    } else if (stepTotal > st - 14) {
      setState(() {
        w03 = 82;
        markerY = 295;
      });
    } else if (stepTotal > st - 17) {
      setState(() {
        w03 = 52;
        markerY = 325;
      });
      // }
    }
  }

  void m30(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (stepTotal <= 24) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    //   // if (temps < _steps) {
    //   //   stepp = _steps - temps;
    //   //   temps = _steps;
    //   // }
    //   print('compass value: $compass');
    //   if (compass >= 50 && compass < 140) {
    //     // stepTotal = stepTotal + stepp;
    //   } else {
    //     // stepTotal = stepTotal - stepp;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Face the correct direction and proceed forward',
    //             style: TextStyle(color: TColors.warning)),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: TColors.dark,
    //         // Adjust duration as needed
    //       ),
    //     );
    //   }
    //   // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       updateTextMessage('Your destination is ahead of you');
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w30 = 343;
        markerY = 335;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w30 = 305;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w30 = 275;
      });
    } else if (stepTotal > st - 14) {
      setState(() {
        w30 = 245;
      });
    } else if (stepTotal > st - 17) {
      setState(() {
        w30 = 215;
      });
      // }
    }
  }

  void m36(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (stepTotal <= 24) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    //   // if (temps < _steps) {
    //   //   stepp = _steps - temps;
    //   //   temps = _steps;
    //   // }
    //   print('compass value: $compass');
    //   if (compass >= 230 && compass < 320) {
    //     // stepTotal = stepTotal + stepp;
    //   } else {
    //     // stepTotal = stepTotal - stepp;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Face the correct direction and proceed forward',
    //             style: TextStyle(color: TColors.warning)),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: TColors.dark,
    //         // Adjust duration as needed
    //       ),
    //     );
    //   }
    //   // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       if (x == 6) {
    //         updateTextMessage('Your destination is on your left');
    //       } else if (x == 8) {
    //         updateTextMessage('Your destination is on your right');
    //       }
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w36 = 342;
        markerY = 35;
      });
    } else if (stepTotal > st - 9) {
      setState(() {
        w36 = 312;
        markerY = 65;
      });
    } else if (stepTotal > st - 15) {
      setState(() {
        w36 = 282;
        markerY = 95;
      });
    } else if (stepTotal > st - 20) {
      setState(() {
        w36 = 252;
        markerY = 125;
      });
    } else if (stepTotal > st - 25) {
      setState(() {
        w36 = 222;
        markerY = 155;
      });
      // }
    }
  }

  void m63(int st, int x, int stepTotal) async {
    // int stepTotal = 0;
    // int temps = _steps;
    // double compass = 0;
    // print(_steps);
    // while (stepTotal <= 24) {
    //   await Future.delayed(Duration(seconds: 1));
    //   // print('map updated List: $stepTotal');
    //   // int stepp = 0;
    //   if (heading! < 0) {
    //     compass = (heading! + 360);
    //   } else {
    //     compass = heading!;
    //   }
    //   // if (temps < _steps) {
    //   //   stepp = _steps - temps;
    //   //   temps = _steps;
    //   // }
    //   print('compass value: $compass');
    //   if (compass >= 50 && compass < 140) {
    //     // stepTotal = stepTotal + stepp;
    //   } else {
    //     // stepTotal = stepTotal - stepp;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Face the correct direction and proceed forward',
    //             style: TextStyle(color: TColors.warning)),
    //         duration: Duration(seconds: 2),
    //         backgroundColor: TColors.dark,
    //         // Adjust duration as needed
    //       ),
    //     );
    //   }
    //   // if (stepTotal > st) {
    //   currentLocate();
    //   if (startVertex == x) {
    //     isReached(true);
    //     if (selectList.contains(x)) {
    //       updateTextMessage('Your destination is ahead of you');
    //     }
    //   } else {
    //     updateTextMessage('Move slightly according to the map');
    //   }
    // } else
    if (stepTotal > st - 4) {
      setState(() {
        w63 = 168;
        markerY = 160;
      });
    } else if (stepTotal > st - 7) {
      setState(() {
        w63 = 138;
        markerY = 130;
      });
    } else if (stepTotal > st - 10) {
      setState(() {
        w63 = 108;
        markerY = 100;
      });
    } else if (stepTotal > st - 14) {
      setState(() {
        w63 = 78;
        markerY = 70;
      });
    } else if (stepTotal > st - 17) {
      setState(() {
        w63 = 48;
        markerY = 40;
      });
      // }
    }
  }

  void stop() {
    setState(() {
      _isStarted = false;
    });
  }

  void _stopScan() {
    _subscription.cancel();
    setState(() {
      _isScanning = false;
    });
  }

  void _activateListeners() {
    database.child("ack").onValue.listen((event) {
      final Map<dynamic, dynamic>? des = event.snapshot.value as Map?;
      print("Map RTDB: $des");
      if (des != null) {
        newList.clear(); // Clear the previous list
        // Iterate through the map
        des.forEach((key, value) {
          if (value == 1) {
            // Extract the device number and add it to the new list
            int deviceNumber = int.parse(key.toString().substring(3));
            newList.add(deviceNumber);
          }
        });
        newList.sort();
        print("newlist RTDB: $newList");
        // callFirebaseFunction(newList);
        // Print the new list
        print("New List: $newList");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_devices);
    // print(heading! < 0 ? 360 + heading! : heading!);

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Map',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _start,
        backgroundColor: TColors.dark.withOpacity(0.9),
        child: const Icon(
          Iconsax.location,
          color: TColors.grey,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.width * 0.11,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: TColors.darkGrey, width: 1.5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: SizedBox(
                          width: THelperFunctions.screenWidth() / 4,
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.location,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                startVertex.toString(),
                                style: TextStyle(fontSize: 27),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.57,
                        height: MediaQuery.of(context).size.width * 0.11,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: TColors.darkGrey, width: 1.5),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        child: SizedBox(
                          width: THelperFunctions.screenWidth() / 4,
                          child: Row(
                            children: [
                              const Icon(
                                Iconsax.send_1,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                selectList.join(", "),
                                style: TextStyle(fontSize: 26),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems / 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  height: MediaQuery.of(context).size.width * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TColors.accent, width: 1.5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: SizedBox(
                    width: THelperFunctions.screenWidth() / 4,
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.routing,
                          size: 22,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: resultList.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final int item = entry.value;
                            return Row(
                              children: [
                                Text(
                                  '$item',
                                  style: const TextStyle(fontSize: 26),
                                ),
                                if (index != resultList.length - 1)
                                  const Icon(
                                    Iconsax.arrow_right_1,
                                    size: 20,
                                    color: TColors.textWhite,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems / 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  height: MediaQuery.of(context).size.width * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TColors.darkGrey, width: 1.5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  child: SizedBox(
                    width: THelperFunctions.screenWidth() / 4,
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.bluetooth,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          newList.join(", "),
                          style: TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                Container(
                  child: Stack(
                    children: [
                      Image.asset(
                        TImages.map,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                      //bottom 3 vertical
                      Positioned(
                        top: w30,
                        left: 81,
                        bottom: w03,
                        child: Visibility(
                          visible: n03,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              // height: 185,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: w30,
                        left: 191,
                        bottom: w03,
                        child: Visibility(
                          visible: n14,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const SizedBox(
                              // height: 185,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: w30,
                        left: 297,
                        bottom: w03,
                        child: Visibility(
                          visible: n25,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              // height: 185,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                      //top 3 vertical
                      Positioned(
                        top: w63,
                        left: 81,
                        bottom: w36,
                        child: Visibility(
                          visible: n36,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              // height: 190,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: w63,
                        left: 191,
                        bottom: w36,
                        child: Visibility(
                          visible: n47,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              // height: 190,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: w63,
                        left: 297,
                        bottom: w36,
                        child: Visibility(
                          visible: n58,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              // height: 190,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                      //right 3 hori
                      Positioned(
                        top: 18,
                        left: w12,
                        right: w21,
                        child: Visibility(
                          visible: n78,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 15,
                              // width: 121,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 193,
                        left: w12,
                        right: w21,
                        child: Visibility(
                          visible: n45,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 15,
                              // width: 121,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 363,
                        left: w12,
                        right: w21,
                        child: Visibility(
                          visible: n12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 15,
                              // width: 121,
                            ),
                          ),
                        ),
                      ),
                      //left 3 hori
                      Positioned(
                        top: 18,
                        left: w01,
                        right: w10,
                        child: Visibility(
                          visible: n67,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 15,
                              // width: 125,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 193,
                        left: w01,
                        right: w10,
                        child: Visibility(
                          visible: n34,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 15,
                              // width: 125,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 363,
                        left: w01,
                        right: w10,
                        child: Visibility(
                          visible: n01,
                          child: Container(
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 15,
                              // width: 125,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: markerY,
                        left: markerX,
                        child: Transform.rotate(
                          angle: ((((heading! + 90) ?? 0) * (pi / 180) * 1)),
                          child: Image.asset(
                            TImages.marker,
                            width: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems / 2,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TColors.darkGrey, width: 1.5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  child: SizedBox(
                    width: THelperFunctions.screenWidth() / 4,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Iconsax.location,
                              size: 22,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                'Welcome to BlueWay',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, top: 1),
                            child: Text(
                              textMessage,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border:
                              Border.all(color: TColors.darkGrey, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: InkWell(
                          onTap: _isStarted ? stop : start,
                          child: SizedBox(
                            width: THelperFunctions.screenWidth() / 3,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.arrow_right_4,
                                      size: 22,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        _isStarted ? 'stop' : 'start',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: TSizes.spaceBtwItems / 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border:
                              Border.all(color: TColors.darkGrey, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            width: THelperFunctions.screenWidth() / 3,
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.arrow_right_2,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'exit',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: TSizes.spaceBtwItems / 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.23,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border:
                              Border.all(color: TColors.darkGrey, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: InkWell(
                          onTap: () => callFirebaseFunction(newList),
                          child: SizedBox(
                            width: THelperFunctions.screenWidth() / 3,
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.routing,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'path',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: TSizes.spaceBtwItems / 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border:
                              Border.all(color: TColors.darkGrey, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: InkWell(
                          onTap: () async {
                            try {
                              await database.update({
                                'ack/esp0': 0,
                                'ack/esp1': 0,
                                'ack/esp2': 0,
                                'ack/esp3': 0,
                                'ack/esp4': 0,
                                'ack/esp5': 0,
                                'ack/esp6': 0,
                                'ack/esp7': 0,
                                'ack/esp8': 0
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: SizedBox(
                            width: THelperFunctions.screenWidth() / 3,
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.bluetooth,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'ble',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // IconButton(
                      //     onPressed: () async {
                      //       try {
                      //         await database.update({
                      //           'ack/esp0': 1,
                      //           'ack/esp1': 1,
                      //           'ack/esp2': 1,
                      //           'ack/esp3': 1,
                      //           'ack/esp4': 1,
                      //           'ack/esp5': 1,
                      //           'ack/esp6': 1,
                      //           'ack/esp7': 1,
                      //           'ack/esp8': 1
                      //         });
                      //       } catch (e) {
                      //         print(e);
                      //       }
                      //     },
                      //     icon: Icon(Iconsax.square)),
                      // IconButton(
                      //     onPressed: () => callFirebaseFunction(newList),
                      //
                      //     icon: Icon(Iconsax.call)),
                    ],
                  ),
                ),
              ],
            ),
            // const RoundedImage(
            //   width: double.infinity,
            //   imageUrl: TImages.map,
            //   applyImageRadius: true,
            // ),
            // Container(
            //   child: Stack(
            //     children: [
            //       Image.asset(
            //         TImages.map,
            //         fit: BoxFit.fitWidth,
            //         width: double.infinity,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
