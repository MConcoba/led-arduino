import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hcled/utils/common_widget.dart';
import 'package:hcled/utils/constans.dart';
import 'package:hcled/utils/extension.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class ElevatorControll extends HookConsumerWidget {
  const ElevatorControll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = context.height();
    final counter = useState(1);
    final nextFloor = useState(1);
    final position = useState(2);
    final isMoving = useState(false);
    final isShimada = useState(false);
    final isEmergency = useState(false);
    final isPressedPhoneButton = useState(false);
    final isPressedOpenButton = useState(false);
    final isPressedCloseButton = useState(false);
    final bluetooth = FlutterBluetoothSerial.instance;
    final bluetoothState = useState(false);
    final isConnecting = useState(false);
    final connection = useState<BluetoothConnection?>(null);
    final devices = useState<List<BluetoothDevice>>([]);
    final deviceConnected = useState<BluetoothDevice?>(null);

    final isDoorState =
        useState(closedState); //[opened, closed, opening, closing]

    final isAboveSelectedList = useState(List.generate(max + 1, (_) => false));
    final isUnderSelectedList =
        useState(List.generate(min * (-1) + 1, (_) => false));

    void receiveData() {
      connection.value?.input?.listen((event) async {
        print(event.length);
        if (event.length == 23 || event.length == 2) {
          isMoving.value = true;
          try {
            List<int> lastTwoElements = [];
            if (event.length < 3) {
              lastTwoElements = event;
            } else if (event.length == 23) {
              lastTwoElements = event.sublist(event.length - 2);
            }

            if (lastTwoElements[0] < lastTwoElements[1]) {
              position.value = 1;
            }

            if (lastTwoElements[0] > lastTwoElements[1]) {
              position.value = 0;
            }

            if (lastTwoElements[0] == lastTwoElements[1]) {
              position.value = 2;
              isMoving.value = false;
            }
            isAboveSelectedList.value[lastTwoElements[0]] = false;

            counter.value = lastTwoElements[0];
          } catch (e) {
            print(
                "Error: $e"); // Salida: Error: FormatException: Invalid number (or string format)
          }
        } else {
          //List<int> lastTwoElements = event.sublist(event.length - 2);
          print(event);
          print(String.fromCharCodes(event));
          if (String.fromCharCodes(event) == 'E') {
            isPressedPhoneButton.value = true;
          }

          if (String.fromCharCodes(event) == 'F') {
            isPressedPhoneButton.value = false;
          }
        }
      });
    }

    void sendData(String data) {
      if (connection.value?.isConnected ?? false) {
        //print(ascii.encode(data));
        connection.value?.output.add(ascii.encode(data));
      }
    }

    void getDevices() async {
      var res = await bluetooth.getBondedDevices();
      devices.value = res;
    }

    void connectToLedDevice() async {
      getDevices();
      await Future.delayed(const Duration(seconds: 2));
      BluetoothDevice? ledDevice;
      print(connection.value?.isConnected.toString());
      if (connection.value != null &&
          connection.value?.isConnected == true &&
          deviceConnected.value?.name == 'HC-05') {
        return;
      }

      for (final device in devices.value) {
        if (device.name == 'HC-05') {
          ledDevice = device;
          print(ledDevice.name);
          break;
        }
      }

      if (ledDevice != null) {
        try {
          print('Intentando conectar con "led01"...');
          await connection.value?.finish();
          connection.value =
              await BluetoothConnection.toAddress(ledDevice.address);
          print(connection);
          deviceConnected.value = ledDevice;
          isConnecting.value = false;
          receiveData();
          print('Conexión exitosa con "led01".');
        } catch (e) {
          print("Error al conectar con el dispositivo LED: $e");
          await bluetooth.requestDisable();
          await Future.delayed(const Duration(seconds: 1));
          await bluetooth.requestEnable();

          connectToLedDevice();
        }
      } else {
        // Mostrar alerta si el dispositivo no está disponible
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Dispositivo no disponible'),
              content: const Text('El dispositivo "led01" no está disponible.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Permission.location.request();
        await Permission.bluetooth.request();
        await Permission.bluetoothScan.request();
        await Permission.bluetoothConnect.request();

        bluetooth.state.then((state) async {
          // setState(() => bluetoothState = state.isEnabled);
          bluetoothState.value = state.isEnabled;
          if (!bluetoothState.value) {
            await bluetooth.requestEnable();
          }
        });
        bluetooth.onStateChanged().listen((state) async {
          switch (state) {
            case BluetoothState.STATE_OFF:
              //setState(() => bluetoothState = false);
              bluetoothState.value = false;
              await bluetooth.requestEnable();
              break;
            case BluetoothState.STATE_ON:
              //setState(() => bluetoothState = true);
              bluetoothState.value = true;
              break;
          }
        });

        connectToLedDevice();
      });

      return () {
        // Cleanup code here
      };
    }, []);

    pressedOpen() {
      isPressedOpenButton.value = true;
      //selectButton.playAudio(audioPlayer, isSoundOn.value);
      //Vibration.vibrate(duration: vibTime, amplitude: vibAmp);
      Future.delayed(const Duration(milliseconds: flashTime)).then((_) {
        if (!isMoving.value &&
            !isEmergency.value &&
            (isDoorState.value == closedState ||
                isDoorState.value == closingState)) {
          //context.openDoor().speakText(flutterTts, isSoundOn.value);
          isDoorState.value = openingState;
          "isDoorState: ${isDoorState.value}".debugPrint();
        }
      });
    }

    pressedClose() {
      isPressedCloseButton.value = true;
    }

    pressedAlert() async {
      isPressedPhoneButton.value = true;
      sendData('E');
    }

    floorSelected(int i, bool selectFlag) async {
      if (!isEmergency.value) {
        if (i == counter.value) {
        } else if (!selectFlag) {
        } else if (!i.isSelected(
            isAboveSelectedList.value, isUnderSelectedList.value)) {
          i.trueSelected(isAboveSelectedList.value, isUnderSelectedList.value);
          if (counter.value < i && i < nextFloor.value) nextFloor.value = i;
          if (counter.value > i && i > nextFloor.value) nextFloor.value = i;
          if (i.onlyTrue(isAboveSelectedList.value, isUnderSelectedList.value))
            nextFloor.value = i;
          "$nextString${nextFloor.value}".debugPrint();
          (counter.value < nextFloor.value)
              ? position.value = 1
              : (counter.value > nextFloor.value)
                  ? position.value = 0
                  : position.value = 2;
          isMoving.value = false;

          sendData(i.toString());
        }
      }
    }

    floorCanceled(int i) async {
      if (i.isSelected(isAboveSelectedList.value, isUnderSelectedList.value) &&
          i != nextFloor.value) {
        i.falseSelected(isAboveSelectedList.value, isUnderSelectedList.value);
        if (i == nextFloor.value) {
          nextFloor.value = (counter.value < nextFloor.value)
              ? counter.value.upNextFloor(
                  isAboveSelectedList.value, isUnderSelectedList.value)
              : counter.value.downNextFloor(
                  isAboveSelectedList.value, isUnderSelectedList.value);
        }
        "$nextString${nextFloor.value}".debugPrint();
      }
    }

    final displayNumber = useMemoized(
        () => HookBuilder(builder: (context) {
              return Text(
                counter.value.displayNumber(),
                style: const TextStyle(
                  color: lampColor,
                  fontSize: 85,
                  fontWeight: FontWeight.normal,
                  fontFamily: numberFont,
                ),
              );
            }),
        [counter.value]);

    Widget floorButton(int i, bool selectFlag) => GestureDetector(
          child: floorButtonImage(
              context,
              i,
              isShimada.value,
              //i.isSelected([false, false, false, true, true ], false)),
              //false),
              i.isSelected(
                  isAboveSelectedList.value, isUnderSelectedList.value)),
          onTap: () => floorSelected(i, selectFlag),
          onLongPress: () => floorCanceled(i),
          onDoubleTap: () => floorCanceled(i),
        );

    Widget floorButtons(List<int> n, List<bool> nFlag) =>
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          floorButton(n[0], nFlag[0]),
          SizedBox(width: context.buttonMargin()),
          floorButton(n[1], nFlag[1]),
          SizedBox(width: context.buttonMargin()),
        ]);

    Widget displayArrowNumber() => Container(
          padding: EdgeInsets.only(top: context.displayPadding()),
          width: context.displayWidth(),
          height: context.displayHeight(),
          color: darkBlackColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              //shimadaLogoImage(context, isShimada.value),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: context.displayArrowWidth(),
                    height: context.displayArrowHeight(),
                    child: Image.asset(counter.value.arrowImage(
                        isMoving.value, nextFloor.value, position.value)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    //margin: EdgeInsets.only(bottom: 10.0),
                    width: context.displayNumberWidth(),
                    height: context.displayNumberHeight(),
                    child: displayNumber,
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        );

  Widget controlBT(BuildContext context) {
  return Row(
    children: [
      SizedBox(width: context.buttonMargin()),
      Expanded(
        child: Text(
          'Elevador conectado: ${deviceConnected.value?.name ?? 'ninguno'}',
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}


    return Scaffold(
      backgroundColor: grayColor,
      body: Center(
        child: Stack(children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              width: context.displayWidth(),
              height: height,
              decoration: metalDecoration(),
              child: Column(children: [
                const Spacer(flex: 2),
                controlBT(context),
                const Spacer(flex: 1),
                //SizedBox(height: context.displayMargin()),
                displayArrowNumber(),
                SizedBox(height: context.displayMargin()),
                const Spacer(flex: 1),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTapDown: (_) => pressedOpen(),
                    onTapUp: (_) => isPressedOpenButton.value = false,
                    onTapCancel: () => isPressedOpenButton.value = false,
                    child: operationImage(context, "open", isShimada.value,
                        isPressedOpenButton.value),
                  ),
                  SizedBox(width: context.buttonMargin()),
                  GestureDetector(
                    onTapDown: (_) => pressedClose(),
                    onTapUp: (_) => isPressedCloseButton.value = false,
                    onTapCancel: () => isPressedCloseButton.value = false,
                    child: operationImage(context, "close", isShimada.value,
                        isPressedCloseButton.value),
                  ),
                  SizedBox(
                      width: context.floorButtonSize() +
                          1 * context.buttonMargin()),
                  GestureDetector(
                    onTapDown: (_) => pressedAlert(),
                    child: operationImage(context, "alert", isShimada.value,
                        isPressedPhoneButton.value),
                  )
                ]),
                const Spacer(flex: 1),
                SizedBox(height: context.buttonMargin()),
                floorButtons(floors1, isFloors1),
                SizedBox(height: context.buttonMargin()),
                floorButtons(floors2, isFloors2),
                SizedBox(height: context.buttonMargin()),
                const Spacer(flex: 3),
                SizedBox(height: context.admobHeight())
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
