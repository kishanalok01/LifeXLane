import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class BluetoothProvider extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;

  BluetoothDevice? get connectedDevice => _connectedDevice;

  void establishConnection(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      _connectedDevice = device;
      notifyListeners();
    } catch (e) {
      // Handle connection error
      print('Error: $e');
    }
  }

  void closeConnection() {
    _connectedDevice?.disconnect();
    _connectedDevice = null;
    notifyListeners();
  }
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 9));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        devices = results.map((scanResult) => scanResult.device).toList();
      });
    });
  }

  void _connectToDevice(BuildContext context, BluetoothDevice device) async {
    final bluetoothProvider =
        Provider.of<BluetoothProvider>(context, listen: false);
    bluetoothProvider.establishConnection(device);
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('lifeXlane'),
        backgroundColor: const Color.fromARGB(255, 230, 81, 0),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Account"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Devices"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Logout"),
              ),
            ];
          })
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _startScan,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 230, 81, 0)),
            ),
            child: const Text('Scan Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id.toString()),
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
          Navigator.pushNamed(context, '/other_page'); //move to next page
        },
        label: const Text('Continue'),
        icon: const Icon(Icons.arrow_forward),
        backgroundColor: Colors.orange[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
