import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ble/ble_scanner.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleScannerState?>(
        builder: (_, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
        ),
      );
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({required this.scannerState});

  final BleScannerState scannerState;

  @override
  Widget build(BuildContext context) {
    print('Discovered Devices: ${scannerState.discoveredDevices}');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: ListView(
                children: scannerState.discoveredDevices
                    .map(
                      (device) => ListTile(
                        title: Text(device.name),
                        subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                        leading: const Icon(Icons.bluetooth),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(scannerState.scanIsInProgress ? 'Stop' : 'Scan'),
                onPressed: () {
                  if (scannerState.scanIsInProgress) {
                    // Stop scanning logic
                    Provider.of<BleScanner>(context, listen: false).stopScan();
                  } else {
                    // Start scanning logic
                    Provider.of<BleScanner>(context, listen: false)
                        .startScan([]);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
