import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../models/favourite_model.dart';

class SavedPage extends StatefulWidget {
  static const String id = 'saved_page';

  SavedPage({Key? key});

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late Future<List<FavouriteModel>> futureFavouriteModels;

  @override
  void initState() {
    super.initState();
    futureFavouriteModels = getId().then((userId) {
      return fetchFavouriteModels(userId);
    });
  }

  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? 'no id';
    print('id is $userId');
    return userId;
  }

  Future<List<FavouriteModel>> fetchFavouriteModels(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('https://ibron.onrender.com/ibron/api/v1/favorites?user_id=$userId'));

      if (response.statusCode == 200) {
        List<FavouriteModel> favouriteModels = [];
        final jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          for (var favouriteJson in jsonData) {
            favouriteModels.add(FavouriteModel.fromJson(favouriteJson));
          }
        }
        return favouriteModels;
      } else {
        throw Exception('Failed to load favourite models: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load favourite models: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Services'),
      ),
      body: Center(
        child: FutureBuilder<List<FavouriteModel>>(
          future: futureFavouriteModels,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data!.isEmpty) {
                return Text('No saved services found.');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].address),
                      // You can display more details as needed
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
