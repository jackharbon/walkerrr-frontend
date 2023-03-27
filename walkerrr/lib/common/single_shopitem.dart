import 'package:flutter/material.dart';
import 'package:walkerrr/common/styling_variables.dart';
import 'package:walkerrr/providers/user_provider.dart';
import 'package:walkerrr/services/api_connection.dart';

class SingleShopItem extends StatefulWidget {
  const SingleShopItem(
      {super.key,
      required this.name,
      required this.price,
      required this.assetName});

  final String name;
  final Widget assetName;
  final int price;

  @override
  State<SingleShopItem> createState() => _SingleShopItemState();
}

class _SingleShopItemState extends State<SingleShopItem> {
  bool isButtonActive = true;
  final currentTrophies = userObject['trophies'];
  String buttonText = "Buy";

  var _backgroundColor = GlobalStyleVariables.equipmentButtonActiveColour;

  @override
  Widget build(BuildContext context) {
    if (currentTrophies != null) {
      currentTrophies.forEach((trophy) => {
            if (trophy["name"] == widget.name)
              {
                isButtonActive = false,
                buttonText = "Purchased",
                _backgroundColor =
                    GlobalStyleVariables.equipmentButtonInactiveColour,
              }
            else
              {
                GlobalStyleVariables.equipmentButtonActiveColour,
              }
          });
    }

    if (isButtonActive == false) {}
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          border: Border.all(
              color: GlobalStyleVariables.equipmentItemBorderColour, width: 1),
          color: GlobalStyleVariables.equipmentItemBackgroundColour),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widget.assetName,
            Text(widget.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text("Price: ${widget.price} Coins"),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _backgroundColor,
                ),
                onPressed: isButtonActive
                    ? () {
                        setState(() {
                          final currentCoins = userObject["coins"];
                          if (currentCoins >= widget.price) {
                            final newShopItem = {
                              "name": widget.name,
                              "price": widget.price
                            };
                            patchTrophiesToDB(userObject['uid'], newShopItem);
                            userObject["coins"] = currentCoins - widget.price;
                            patchCoins(userObject['uid'], -widget.price);
                            final currentTrophies = userObject["trophies"];
                            userObject["trophies"] = [
                              ...currentTrophies,
                              newShopItem
                            ];
                            isButtonActive = false;
                          }
                        });
                      }
                    : null,
                child: Text(buttonText))
          ]),
    );
  }
}
