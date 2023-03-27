import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:walkerrr/common/armor_variables.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/pages/navto_inv.dart';
import 'package:walkerrr/pages/navto_shop.dart';
import 'package:walkerrr/providers/step_provider.dart' as globalSteps;
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class MainPedometer extends StatefulWidget {
  const MainPedometer({super.key});

  @override
  State<MainPedometer> createState() => MainPedometerState();
}

class MainPedometerState extends State<MainPedometer>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String status = '?', steps = '0';
  bool isStepCountAvailable = true;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    if (isStepCountAvailable) {
      if (mounted) {
        setState(() {
          steps = event.steps.toString();
          globalSteps.StepsContext().updateGlobalSteps(event.steps);
        });
      }
      // print('----- onStepCount on steps_main_page:\n${event.steps}');
    }
  }

  void onStepManualCount(counter) async {
    if (!isStepCountAvailable) {
      setState(() {
        steps = counter.toString();
        globalSteps.StepsContext().updateGlobalSteps(counter);
      });
      await getUserFromDB(userObject['uid']);
      setState(() {
        status = 'stopped';
      });
    }
    // print('----- onStepManualCount on steps_main_page:\n$counter');
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      status = event.status;
    });
    // print('---- onPedestrianStatusChanged status on steps_main_page:\n$status');
  }

  void onPedestrianStatusError(error) {
    setState(() {
      status = 'Pedestrian Status not available';
    });
    // print('---- onPedestrianStatusError on steps_main_page:\n$error');
  }

  void onStepCountError(error) {
    setState(() {
      isStepCountAvailable = false;
      globalSteps.StepsContext().updateGlobalSteps(0);
    });
    // print('---- onStepCountError:errorMessage on steps_main_page:\n$error');
  }

  getCurrentlyEquipped() {
    // print("---- getCurrentlyEquipped on steps_main_page:\n$userObject");
    return userObject['equippedArmour'].toLowerCase();
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  //Floating Action Button Variables
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final currentlyEquipped = getCurrentlyEquipped();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        },
        child: Scaffold(
          floatingActionButton: SpeedDial(
            icon: CustomIcons.icon_add,
            activeIcon: CustomIcons.icon_x,
            foregroundColor: GlobalStyleVariables.stepsPlusMenuTextColour,
            backgroundColor: GlobalStyleVariables.stepsPlusMenuBackgroundColour,
            spacing: 3,
            openCloseDial: isDialOpen,
            renderOverlay: false,
            closeManually: false,
            spaceBetweenChildren: 4,
            children: [
              SpeedDialChild(
                child: Image.asset(
                  "assets/images/icon_BackPack.png",
                  height: 26,
                  fit: BoxFit.cover,
                ),
                label: "Inventory",
                backgroundColor: GlobalStyleVariables.stepsInventoryMenuColour,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalkerInventory()));
                },
              ),
              SpeedDialChild(
                child: Image.asset(
                  "assets/images/icon_Cart.png",
                  height: 26,
                  fit: BoxFit.cover,
                ),
                label: "Shop",
                backgroundColor: GlobalStyleVariables.stepsShopMenuColour,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalkerShop()));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Steps taken:',
                      style: TextStyle(
                          fontSize: 30,
                          color: GlobalStyleVariables.primaryTextLightColour),
                    ),
                  ),
                  // if (isStepCountAvailable)
                  Text(
                    steps,
                    style: const TextStyle(
                        fontSize: 40,
                        color: GlobalStyleVariables.primaryTextLightColour),
                  ),
                  if (!isStepCountAvailable)
                    const Text(
                      'Pedometer is not avaiable.',
                      style: TextStyle(
                          fontSize: 16,
                          color: GlobalStyleVariables.primaryTextLightColour),
                    ),
                  if (!isStepCountAvailable)
                    const Text(
                      'Use button "+" to simulate steps',
                      style: TextStyle(
                          fontSize: 16,
                          color: GlobalStyleVariables.primaryTextLightColour),
                    ),
                  if (!isStepCountAvailable)
                    IconButton(
                      iconSize: 60,
                      icon: const Icon(
                        Icons.add_circle_outline_outlined,
                        color: GlobalStyleVariables.primaryTextLightColour,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            counter++;
                            status = "walking";
                          },
                        );
                        onStepManualCount(counter);
                      },
                    ),
                  ValueListenableBuilder(
                      valueListenable: CurrentEquip.current,
                      builder: (context, value, child) {
                        return status == "walking"
                            ? WalkingArmorIcons().getWalkingSprite(value)
                            : IdleArmorIcons().getIdleSprite(value);
                      }),
                  const Text(
                    'Current Equipment:',
                    style: TextStyle(
                        fontSize: 20,
                        color: GlobalStyleVariables.primaryTextLightColour),
                  ),
                  Text(
                    currentlyEquipped.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20,
                        color: GlobalStyleVariables.primaryTextLightColour),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
