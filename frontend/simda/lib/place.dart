import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place with ClusterItem {
final int feedId;
final bool isClosed;
final LatLng latLng;
final int emotion;
Place({required this.feedId, required this.latLng, this.isClosed = false, required this.emotion});

@override
String toString() {
return 'Place $feedId (closed : $isClosed)';
}

@override
LatLng get location => latLng;

}