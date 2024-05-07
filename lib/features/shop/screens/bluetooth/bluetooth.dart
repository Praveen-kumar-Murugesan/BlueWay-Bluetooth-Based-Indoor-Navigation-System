import 'package:bluecart1/common/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../../../../ble/ble_device_connector.dart';
import '../../../../ble/ble_device_interactor.dart';
import '../../../../ble/ble_logger.dart';
import '../../../../ble/ble_scanner.dart';
import '../../../../ble/ble_status_monitor.dart';
import '../../../../ui/ble_status_screen.dart';
import '../../../../ui/device_list.dart';

// const _themeColor = Colors.lightGreen;

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bleLogger = BleLogger();
    final _ble = FlutterReactiveBle();
    final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
    final _monitor = BleStatusMonitor(_ble);
    // final _connector = BleDeviceConnector(
    //   ble: _ble,
    //   logMessage: _bleLogger.addToLog,
    // );
    final _serviceDiscoverer = BleDeviceInteractor(
      bleDiscoverServices: _ble.discoverServices,
      readCharacteristic: _ble.readCharacteristic,
      writeWithResponse: _ble.writeCharacteristicWithResponse,
      writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
      subscribeToCharacteristic: _ble.subscribeToCharacteristic,
      logMessage: _bleLogger.addToLog,
    );

    return MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        // Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        // StreamProvider<ConnectionStateUpdate>(
        //   create: (_) => _connector.state,
        //   initialData: const ConnectionStateUpdate(
        //     deviceId: 'Unknown device',
        //     connectionState: DeviceConnectionState.disconnected,
        //     failure: null,
        //   ),
        // ),
      ],
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            "BLE Devices",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: HomeBLEScreen(),
      ),
    );
  }
}

class HomeBLEScreen extends StatelessWidget {
  const HomeBLEScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return const DeviceListScreen();
          } else {
            return BleStatusScreen(status: status ?? BleStatus.unknown);
          }
        },
      );
}
