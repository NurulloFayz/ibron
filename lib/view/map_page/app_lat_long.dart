

class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({required this.lat,required this.long});
}
class MoscowLocation extends AppLatLong {
  const MoscowLocation({
    // 41.3335324,69.3013982
    super.long = 41.3335324,
    super.lat = 69.3013982,
  });
}