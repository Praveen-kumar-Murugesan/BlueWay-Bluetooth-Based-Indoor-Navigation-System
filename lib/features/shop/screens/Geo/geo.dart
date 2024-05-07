import 'package:bluecart1/utils/constants/colors.dart';
import 'package:bluecart1/utils/constants/image_strings.dart';
import 'package:bluecart1/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';

class GeoScreen extends StatefulWidget {
  const GeoScreen({Key? key}) : super(key: key);

  @override
  _GeoScreenState createState() => _GeoScreenState();
}

class _GeoScreenState extends State<GeoScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  double? heading = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initStreams();
    _initCompass();
  }

  void _initCompass() {
    FlutterCompass.events!.listen((event) {
      setState(() {
        heading = event.heading;
      });
    });
  }

  void _initStreams() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen((PedestrianStatus event) {
      setState(() {
        _status = event.status;
      });
    }, onError: (error) {
      setState(() {
        _status = 'Pedestrian Status not available';
      });
      print('Pedestrian Status Error: $error');
    });

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((StepCount event) {
      setState(() {
        _steps = event.steps.toString();
      });
    }, onError: (error) {
      setState(() {
        _steps = 'Step Count not available';
      });
      print('Step Count Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "WalkStats",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: TColors.darkGrey, width: 1.5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                    child: SizedBox(
                      width: THelperFunctions.screenWidth() / 2,
                      child: Column(
                        children: [
                          const Text(
                            'Steps Taken',
                            style: TextStyle(fontSize: 22),
                          ),
                          const Text(
                            "",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            _steps,
                            style: const TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Divider(
                  //   height: 100,
                  //   thickness: 0,
                  //   color: Colors.white,
                  // ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: TColors.darkGrey, width: 1.5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      child: Column(
                        children: [
                          const Text(
                            'Pedestrian Status',
                            style: TextStyle(fontSize: 22),
                          ),
                          Icon(
                            _status == 'walking'
                                ? Icons.directions_walk
                                : _status == 'stopped'
                                    ? Icons.accessibility_new
                                    : Icons.error,
                            size: 40,
                          ),
                          Center(
                            child: Text(
                              _status,
                              style:
                                  _status == 'walking' || _status == 'stopped'
                                      ? const TextStyle(fontSize: 22)
                                      : const TextStyle(
                                          fontSize: 22, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.94,
              height: THelperFunctions.screenHeight() * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: TColors.darkGrey, width: 1.5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  Text(
                    "${heading!.ceil()}°",
                    style: const TextStyle(
                        fontSize: 36.0, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(dark ? TImages.cadrant : TImages.bcadrant),
                        Transform.rotate(
                          angle: ((heading ?? 0) * (pi / 180) * -1),
                          child: Image.asset(
                            TImages.compass,
                            scale: 1.1,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
