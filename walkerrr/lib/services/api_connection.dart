import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:walkerrr/providers/user_provider.dart';

// const baseAPI = 'https://walkerrr-backend.onrender.com';
const baseAPI = 'https://walkerrr-backend.cyclic.app';

Future<void>? postUser(postedEmail, uid, displayname) async {
  final url = Uri.parse('$baseAPI/api/users');
  await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
          {'email': postedEmail, 'uid': uid, 'displayName': displayname}));
  // print('------- postUser on api_connection\n $postedEmail $uid $displayname');
  return;
}

Future<void> deleteUserDB(uid) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  // print('------- deleteUserDB on api_connection \n $uid');
  return;
}

Future getUserFromDB(uid) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final user = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  final parsedUser = jsonDecode(user.body)[0];
  // print('------- getUserFromDB on api_connection\n$parsedUser');

  return parsedUser;
}

Future getUsers() async {
  final url = Uri.parse('$baseAPI/api/users');
  final users = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });
  final parsedUsers = jsonDecode(users.body);
  // print('------- getUsers on api_connection\n$parsedUsers');
  return parsedUsers;
}

Future<void> patchUsername(uid, newUsername) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'displayName': newUsername}));
  // print('------- patchUsername on api_connection\n$newUsername');
}

Future<void> patchEmail(uid, newEmail) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'email': newEmail}));
  // print('------- postEmail on api_connection\n$newEmail');
}

Future<void> patchQuestsToDB(uid, newQuest) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentQuests = userObject["quests"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'quests': [newQuest]
      }));
  // print('------- patchQuests on api_connection\n$newQuest');
}

Future<void> patchComplete(uid, currentQuest) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentQuests = userObject["quests"];
  final removeable = [];
  currentQuests.asMap().forEach((index, quest) => {
        if (quest["questTitle"] == currentQuest)
          {quest["questCompleted"] = true, removeable.add(quest)},
      });
  for (var quest in removeable) {
    currentQuests.remove(quest);
  }
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'quests': currentQuests}));
  // print(
  // '------- patchComplete on api_connection\n$currentQuest $currentQuests');
}

Future<void> patchCoins(uid, increment) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentCoins = userObject["coins"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'coins': currentCoins + increment}));
  // print('------- patchCoins on api_connection\n$currentCoins + $increment');
}

Future<void> patchTrophiesToDB(uid, newTrophy) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  final currentTrophies = userObject["trophies"];
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'trophies': [...currentTrophies, newTrophy]
      }));
  // print('------- patchTrophies on api_connection\n$newTrophy');
}

Future<void> patchArmour(uid, newArmour) async {
  final url = Uri.parse('$baseAPI/api/users/$uid');
  await http.patch(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({"equippedArmour": newArmour}));
  // print('------- patchArmour on api_connection\n$newArmour');
}
