import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simda/place.dart';
import 'package:simda/write_page.dart';

//예시데이터
String data =
    '[{"feedId": 1,"userDTO": {"userId": 1,"userNick": "qudcks"},"emotion": 1,"lat": 37.5013068,"lng": 127.0396597},{"feedId": 2,"userDTO": {"userId": 1,"userNick": "qudcks"},"emotion": 1,"lat": 37.499154,"lng": 127.039028},{"feedId": 3,"userDTO": {"userId": 1,"userNick": "qudcks"},"emotion": 3,"lat": 37.503365,"lng": 127.039593},{"feedId": 4,"userDTO": {"userId": 1,"userNick": "qudcks"},"emotion": 4,"lat": 37.501170,"lng": 127.045211},{"feedId": 5,"userDTO": {"userId": 1,"userNick": "qudcks"},"emotion": 0,"lat": 37.501887,"lng": 127.037786}]';
List list = jsonDecode(data);

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  //클러스터 매니저를 선언만 late 예약어로 나중에 할당
  late ClusterManager _manager;

  //구글맵 컨트롤러를 Completer로 선언
  final Completer<GoogleMapController> _controller = Completer();

  //마커들을 담아줄 Set을 선언 및 초기화
  Set<Marker> markers = Set();

  //지도의 초기 위치를 담아줄 CameraPosition
  final CameraPosition _startCameraPosition =
      const CameraPosition(target: LatLng(37.5013068, 127.0396597), zoom: 17.0);

  //지도의 표시될 객체들의 리스트
  List<Place> items = [];

  //예시데이터를 파싱해온 list를  item리스트에 담는 메서드
  void _addMarkers() {
    for (var feed in list) {
      items.add(Place(
        feedId: feed['feedId'],
        emotion: feed['emotion'],
        latLng: LatLng(feed['lat'], feed['lng']),
      ));
    }
  }

  //State초기화메서드
  @override
  void initState() {
    //list에 데이터를 먼저 넣어줌
    _addMarkers();
    //클러스터 매니저 초기화
    _manager = _initClusterManager();
    super.initState();
  }

  //클러스터 매니저 초기화 메서드
  ClusterManager _initClusterManager() {
    //ClusterManger<지도의 표시할 객체의 형> ("지도의 표시할 형의 리스트","지도에 있는 메서드를
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

//지도가 생성되었을 때 컨트롤러를 받아옴
//   void _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//마커 업데이트 메서드
  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  //마커를 만드는 메서드
  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        int emotion = 0;
        if (cluster.isMultiple) {
          List checklist = [0, 0, 0, 0, 0];
          cluster.items.forEach((p) {
            checklist[p.emotion]++;
          });
          int maxIdx = 0;
          int maxVal = 0;
          for (int i = 0; i < 5; i++) {
            if (checklist[i] > maxVal) {
              maxIdx = i;
              maxVal = checklist[i];
            }
          }
          emotion = maxIdx;
        } else {
          emotion = cluster.items.first.emotion;
        }
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p.emotion));
          },
          icon: await _getMarkerBitmapFromAsset(
              emotion, cluster.isMultiple ? 180 : 120,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  //이미지를 불러와 우리가 원하는 비트맵으롭 변환
  Future<BitmapDescriptor> _getMarkerBitmapFromAsset(int emotion, int size,
      {String? text}) async {
    late String assetPath;
    switch (emotion) {
      //행복
      case 0:
        assetPath = 'assets/images/flowerGreen.png';
        break;
      //기쁨
      case 1:
        assetPath = 'assets/images/flowerYellow.png';
        break;
      //평온
      case 2:
        assetPath = 'assets/images/flowerPurple.png';
        break;
      //화남
      case 3:
        assetPath = 'assets/images/flowerPink.png';
        break;
      //슬픔
      case 4:
        assetPath = 'assets/images/flowerBlue.png';
        break;
    }
    ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui
        .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: size);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final double markerSize = size.toDouble();
    final double markerHalfSize = markerSize / 2;

    if (text != null) {
      // 마커 이미지의 너비와 높이

      final Paint circlePaint = Paint()..color = Colors.red;
      final Paint circlePaintBlack = Paint()..color = Colors.black;
// 마커 이미지 그리기

      final Canvas canvas = Canvas(pictureRecorder);

      // 이미지 그리기
      canvas.drawImage(image, const Offset(0, 0), Paint());

      canvas.drawCircle(Offset(markerSize / 1.3, markerSize / 3.7),
          markerHalfSize / 2.2, circlePaintBlack);

      // 빨간 원 그리기
      canvas.drawCircle(Offset(markerSize / 1.3, markerSize / 3.7),
          markerHalfSize / 2.7, circlePaint);
      // 텍스트 그리기
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: markerHalfSize / 2.3, // 텍스트 크기는 빨간 원 반지름의 크기로 설정
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(canvas, Offset(markerSize / 1.41, markerSize / 6.5));

      final ui.Image markerImage = await pictureRecorder
          .endRecording()
          .toImage(markerSize.toInt(), markerSize.toInt());
      final ByteData? byteData =
          await markerImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("Failed to load image from asset: $assetPath");
      }
      final Uint8List bytes = byteData.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(bytes);
    }

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to load image from asset: $assetPath");
    }
    final Uint8List bytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.bottomEnd, children: [
      GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _manager.setMapId(controller.mapId);
        },
        initialCameraPosition: _startCameraPosition,
        markers: markers,
        onCameraMove: _manager.onCameraMove,
        onCameraIdle: _manager.updateMap,
        zoomControlsEnabled: false,
      ),
      Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WritePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
            ),
            child: const Icon(Icons.add, color: Colors.black87),
          )),
    ]);
  }
}
