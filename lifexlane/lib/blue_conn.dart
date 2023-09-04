import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class BluetoothProvider extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;

  BluetoothDevice? get connectedDevice => _connectedDevice;

  Future<void> establishConnection(BluetoothDevice device) async {
    try {
      await FlutterBluetoothSerial.instance.connect(device);
      _connectedDevice = device;
      notifyListeners();
    } catch (e) {
      // Handle connection error
      print('Error: $e');
    }
  }

  void closeConnection() async {
    try {
      await FlutterBluetoothSerial.instance.disconnect();
    } catch (e) {
      print('Error: $e');
    }
    _connectedDevice = null;
    notifyListeners();
  }
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    FlutterBluetoothSerial.instance.startDiscovery().listen((device) {
      if (device is BluetoothDevice) {
        setState(() {
          devices.add(device as BluetoothDevice);
        });
      }
    });
  }

  void _connectToDevice(BuildContext context, BluetoothDevice device) async {
    final bluetoothProvider =
        Provider.of<BluetoothProvider>(context, listen: false);
    await bluetoothProvider.establishConnection(device);
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.cancelDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _startScan,
            child: Text('Scan Devices'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 230, 81, 0)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address),
                  onTap: () {
                    _connectToDevice(context, device);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/home_page'); //move to next page
        },
        label: Text('Continue'),
        icon: Icon(Icons.arrow_forward),
        backgroundColor: Colors.orange[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
