import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  int likes = 0;
  bool isVisible = false;
  bool writeComment = false;

  //클러스터 매니저를 선언만 late 예약어로 나중에 할당
  late ClusterManager _manager;

  //구글맵 컨트롤러를 Completer로 선언
  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? mapController;

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
      if (mounted) {
        this.markers = markers;
      }
    });
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
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
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(cluster.location.latitude - 0.002,
                      cluster.location.longitude),
                  zoom: 17.0),
            ));
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.75,
                        minChildSize: 0.3,
                        builder: (context, ScrollController scrollController) =>
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: ListView(children: <Widget>[
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '피드 보기',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(Icons.close),
                                              iconSize: 28,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          height: 2,
                                          margin:
                                          const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          color: Colors.purple),
                                      Container(
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20, 10, 20, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '제목입니다~',
                                                            textAlign: TextAlign.left,
                                                            style:
                                                            TextStyle(fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '김짱구',
                                                            style:
                                                            TextStyle(fontSize: 10),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            '2023년 7월 21일 15:54',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors.black45),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(likes.toString(),
                                                          style: const TextStyle(
                                                              fontSize: 20)),
                                                      const SizedBox(width: 5),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            likes++;
                                                          });
                                                        },
                                                        child: const Image(
                                                            image: AssetImage(
                                                                'assets/images/flower2.png'),
                                                            height: 30),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20, 0, 20, 0),
                                              alignment: Alignment.center,
                                              child: const Image(
                                                  image: AssetImage(
                                                      'assets/images/think.png')),
                                            ),
                                            const SizedBox(height: 15),
                                            const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Text(
                                                    '이곳에 글의 내용이 들어갈 예정입니다. 글이 길어지면 어떻게 되는지 보기 위해 긴 글을 작성하고 있습니다. 이 곳은 글이 들어갈 자리입니다.',
                                                    style: TextStyle(height: 1.5),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 20),
                                                Container(
                                                  padding: const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                                  child: TextButton(
                                                    onPressed: () => {
                                                      setState(() {
                                                        isVisible = !isVisible;
                                                      })
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: const EdgeInsets.all(0),
                                                    ),
                                                    child: Text(
                                                        isVisible
                                                            ? "댓글 2개 닫기"
                                                            : "댓글 2개 보기",
                                                        style: const TextStyle(
                                                            color: Colors.black45)),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: isVisible,
                                                  child: Container(
                                                    padding: const EdgeInsets.fromLTRB(
                                                        20, 0, 20, 0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              const Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage:
                                                                    AssetImage(
                                                                        'assets/images/yuri.jpg'),
                                                                    radius: 25,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(width: 10),
                                                              Flexible(
                                                                flex: 1,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    const Row(
                                                                      children: [
                                                                        Text(
                                                                          '유리',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              14,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        ),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Text('10시간 전',
                                                                            style:
                                                                            TextStyle(
                                                                              fontSize:
                                                                              12,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold,
                                                                              color: Colors
                                                                                  .black45,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    const Text(
                                                                      // '짱구가 기분이 좋구나',
                                                                      '짱구가 기분이 좋구나 짱구가 기분이 좋구나 짱구가 기분이 좋구나 짱구가 기분이 좋구나 짱구가 기분이 좋구나',
                                                                      style: TextStyle(
                                                                          fontSize: 14),
                                                                    ),
                                                                    const SizedBox(
                                                                        width: 20),
                                                                    TextButton(
                                                                      onPressed: () => {
                                                                        setState(() {
                                                                          writeComment =
                                                                          !writeComment;
                                                                        })
                                                                      },
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        minimumSize:
                                                                        Size.zero,
                                                                        padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                        tapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .shrinkWrap,
                                                                      ),
                                                                      child: const Text(
                                                                        '답글 달기',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            12,
                                                                            color: Colors
                                                                                .black45),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height: 10),
                                                                    const Row(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        CircleAvatar(
                                                                          backgroundImage:
                                                                          AssetImage(
                                                                              'assets/images/shin.jpg'),
                                                                          radius: 25,
                                                                        ),
                                                                        SizedBox(
                                                                            width: 10),
                                                                        Flexible(
                                                                          flex: 1,
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    '김짱구',
                                                                                    style:
                                                                                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  SizedBox(
                                                                                      width: 10),
                                                                                  Text(
                                                                                      '9시간 전',
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black45,
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                              Text(
                                                                                // '응 좋아 좋아',
                                                                                '짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱! 짱구 기분 짱!',
                                                                                style: TextStyle(
                                                                                    fontSize:
                                                                                    14),
                                                                              ),
                                                                              SizedBox(
                                                                                  height:
                                                                                  10),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height: 10),
                                                                  ],
                                                                ),
                                                              ),
                                                            ]),
                                                        Visibility(
                                                          visible: writeComment,
                                                          child: const TextField(
                                                            style: TextStyle(
                                                                fontSize: 14.0),
                                                            cursorColor: Colors.black12,
                                                            cursorWidth: 1.0,
                                                            decoration: InputDecoration(
                                                              contentPadding:
                                                              EdgeInsets.fromLTRB(
                                                                  10, 0, 10, 0),
                                                              suffixIcon: Icon(
                                                                  Icons.send,
                                                                  color:
                                                                  Colors.black54),
                                                              prefixText: '@유리 ',
                                                              enabledBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Colors.black12,
                                                                    width: 0.0,
                                                                  )),
                                                              focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Colors.black12,
                                                                    width: 0.0,
                                                                  )),
                                                              filled: true,
                                                              fillColor: Colors.black12,
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: !writeComment,
                                                          child: TextField(
                                                            style: const TextStyle(
                                                                fontSize: 14.0),
                                                            cursorColor: Colors.black12,
                                                            cursorWidth: 1.0,
                                                            decoration: InputDecoration(
                                                              contentPadding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  10, 0, 10, 0),
                                                              suffixIcon: IconButton(
                                                                  icon: const Icon(
                                                                      Icons.send),
                                                                  color: Colors.black54,
                                                                  onPressed: () {}),
                                                              hintText:
                                                              '신짱구(으)로 댓글 달기...',
                                                              enabledBorder:
                                                              const OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Colors.black12,
                                                                    width: 0.0,
                                                                  )),
                                                              focusedBorder:
                                                              const OutlineInputBorder(
                                                                  borderSide:
                                                                  BorderSide(
                                                                    color: Colors.black12,
                                                                    width: 0.0,
                                                                  )),
                                                              filled: true,
                                                              fillColor: Colors.black12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ]),
                            ),
                      );
                    });
              },
            );
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
        assetPath = 'assets/images/flower0.png';
        break;
    //기쁨
      case 1:
        assetPath = 'assets/images/flower1.png';
        break;
    //평온
      case 2:
        assetPath = 'assets/images/flower2.png';
        break;
    //화남
      case 3:
        assetPath = 'assets/images/flower3.png';
        break;
    //슬픔
      case 4:
        assetPath = 'assets/images/flower4.png';
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
          markerHalfSize / 2.5, circlePaintBlack);

      // 빨간 원 그리기
      canvas.drawCircle(Offset(markerSize / 1.3, markerSize / 3.7),
          markerHalfSize / 3.3, circlePaint);
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
    return SafeArea(
      child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
        GoogleMap(
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _manager.setMapId(controller.mapId);
            setState(() {
              mapController = controller;
            });
          },
          initialCameraPosition: _startCameraPosition,
          markers: markers,
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
              child: ElevatedButton(
                onPressed: () async {
                  var gps = await getCurrentLocation();
                  mapController?.animateCamera(
                      CameraUpdate.newLatLng(LatLng(gps.latitude, gps.longitude)));
                  print(gps.latitude);
                  print(gps.longitude);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black87,
                ),
              ),
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
          ],
        )
      ]),
    );
  }
}
