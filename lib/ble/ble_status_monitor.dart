// import 'package:ble_react2/ble/reactive_state.dart';
import 'package:bluecart1/ble/reactive_state.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:stream_provider_ble/src/ble/reactive_state.dart';

class BleStatusMonitor implements ReactiveState<BleStatus?> {
  const BleStatusMonitor(this._ble);

  final FlutterReactiveBle _ble;

  @override
  Stream<BleStatus?> get state => _ble.statusStream;
}
