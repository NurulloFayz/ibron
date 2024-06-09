
import 'dart:convert';

import 'package:dio/dio.dart';


import '../../models/address_model.dart';
import 'app_lat_long.dart';


class AddressDetail {
  Future<AddressDetailModel?> getAddressDetail(AppLatLong latLong) async {
    String mapApiKey = "5a634596-1169-4faf-8e29-1dbbb9562526";
    // try {
    //   final Map<String, dynamic> request = {
    //     'apikey': YandexConstants.yandexGeoSuggestApiKey,
    //     'text': searchText,
    //     'bbox': YandexConstants.bbox,
    //     'rspn': 1,
    //     'format': 'json',
    //     'results': 20,
    //     'attrs': 'uri',
    //     'lang': localSource.locale,
    //     // localSource.locale,
    //   };
    //   if (firstPoint != null) {
    //     request['ull'] = '${firstPoint.longitude}, ${firstPoint.latitude}';
    //   }
    //   final Response response = await dio.get(
    //     YandexConstants.yandexGeosuggestUrl,
    //     queryParameters: request,
    //   );
    //   return Right(YandexGeoSuggestResponse.fromJson(response.data));
    // } on DioException catch (error, stacktrace) {
    //   log('Exception occurred: $error stacktrace: $stacktrace');
    //   return Left(
    //     ServerError.withDioError(error: error).failure,
    //   );
    // }

    try {
      Map<String, String> queryParams = {
        'apikey': mapApiKey,
        'geocode': "${latLong.lat},${latLong.long}",
        'lang': 'uz',
        'format': 'json',
        'results': '1'
      };
      Dio yandexDio = Dio();
      var response = await yandexDio.get("https://geocode-maps.yandex.ru/1.x/",
          queryParameters: queryParams);
      return AddressDetailModel.fromJson(json.decode(response.data));
    } catch (e) {
      print("Error $e");
    }
  }
}