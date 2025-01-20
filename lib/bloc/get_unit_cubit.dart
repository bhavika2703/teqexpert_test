import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'get_unit_state.dart';

class GetUnitCubit extends Cubit<GetUnitState> {
  GetUnitCubit() : super(GetUnitInitial());

  int currentPage = 1;
  bool moreData = true;
  final int perPage = 10;
  List<dynamic> items = [];

  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NzY0MjcwM2E4MjQzY2JiYWZhMDg1OTIiLCJlbWFpbCI6Im93bmVyMUB5b3BtYWlsLmNvbSIsImV4cCI6MTczODc1MzA2OSwicm9sZSI6ImxhbmRsb3JkIn0.7YE6NPkaL8a-DeTSKAKoIH8XXI-pwpGZm9Cu8VkFc5Y";

  getHeader(token) async {
    print('Token for header: $token');

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Cache-Control': 'no-cache',
      'User-Agent': 'MyApp/1.0',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
    return header;
  }

  Future<void> fetchData({bool isRefreshData = false}) async {
    if (isRefreshData) {
      currentPage = 1;
      moreData = true;
      items.clear();
    }

    if (!moreData) return;

    emit(GetLoadingState());
    try {
      final response = await http.get(
        Uri.parse(
          'https://5drz7jg9-5050.inc1.devtunnels.ms/api/landLord/unit/getAllUnit/676428378431d5b5a3566bfd?page=$currentPage&limit=$perPage',
        ),
        headers: await getHeader(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> newData = data['response']['units'];

        if (newData.length < perPage) {
          moreData = false;
        }

        items.addAll(newData);
        currentPage++;
        emit(GetSuccessState(items, moreData));
      } else {
        emit(GetErrorState(
            'Failed to load data. HTTP Status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(GetErrorState('Something went wrong: $e'));
    }
  }
}
