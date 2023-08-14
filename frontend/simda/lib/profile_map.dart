import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simda/main.dart';
import 'package:simda/models/FeedDto.dart';
import 'package:simda/models/UserDto.dart';
import 'package:simda/place.dart';
import 'package:simda/providers/feed_providers.dart';

class ProfileMapPage extends StatefulWidget {
  const ProfileMapPage({super.key});

  @override
  State<ProfileMapPage> createState() => _ProfileMapPage();
}

class _ProfileMapPage extends State<ProfileMapPage> {
  int likes = 0;
  bool isVisible = false;
  bool writeComment = false;
  int _userId = 0;

  List<FeedDto> feed = [];
  FeedProviders feedProvider = FeedProviders();

  Future<void> getValueFromSecureStorage() async {
    try {
      int storeUserId = int.parse((await storage.read(key: "userId"))!);
      var temp = UserDto(
          email: (await storage.read(key: 'email'))!,
          nickname: (await storage.read(key: 'nickname'))!,
          profileImg: (await storage.read(key: 'profileImg'))!,
          userId: int.parse((await storage.read(key: 'userId'))!),
          userRole: int.parse((await storage.read(key: 'userRole'))!));
      setState(() {
        _userId = storeUserId;
      });
    } catch (e) {
      print("Error reading from secure storage: $e");
    }
  }

  Future initFeed() async {
    feed = await feedProvider.getUserFeedList(_userId);
    setState(() {
    });
  }

  //클러스터 매니저를 선언만 late 예약어로 나중에 할당
  late ClusterManager _manager;

  //구글맵 컨트롤러를 Completer로 선언
  final Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? mapController;

  //마커들을 담아줄 Set을 선언 및 초기화
  Set<Marker> markers = Set();

  //지도의 초기 위치를 담아줄 CameraPosition
  // final CameraPosition _startCameraPosition =
  // const CameraPosition(target: LatLng(37.5013068, 127.0396597), zoom: 8.0);
  LatLng currentPosition = const LatLng(37.5013068, 127.0396597); // 이게 역삼인가?

  //지도의 표시될 객체들의 리스트
  List<Place> items = [];

  //예시데이터를 파싱해온 list를  item리스트에 담는 메서드
  void _addMarkers() {
    // print("63번 실행 : addMarkers");
    // print("마커를 추가해보겠습니다. ${feed.length}");
    for (int i = 0; i < feed.length; i++) {
      items.add(Place(
        feedId: feed[i].feedId,
        emotion: feed[i].emotion,
        latLng: LatLng(feed[i].lat, feed[i].lng),
      ));
      print("${feed[i].feedId}번 글 제목: ${feed[i].title}");
    }
  }

  //State초기화메서드
  @override
  void initState() {
    super.initState();
    //list에 데이터를 먼저 넣어줌
    //클러스터 매니저 초기화
    _manager = _initClusterManager();
    getValueFromSecureStorage().then((value) =>
        _addMarkersAndInitializeClusterManager()
    );
  }

  void _addMarkersAndInitializeClusterManager() async {
    await initFeed();
    _addMarkers();
    // _manager = _initClusterManager(); // _initClusterManager()를 호출하여 초기화 >> 여기서 하면 initialize 오류가 생기는듯
  }

  //클러스터 매니저 초기화 메서드
  ClusterManager _initClusterManager() {
    print("108 : initCluster 실행");
    //ClusterManger<지도의 표시할 객체의 형> ("지도의 표시할 형의 리스트","지도에 있는 메서드를
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder);
  }

//마커 업데이트 메서드
  void _updateMarkers(Set<Marker> markers) {
    print("121: updateMarkers 실행");
    print('Updated ${markers.length} markers');
    print("아이템의 길이 : ${items.length}");
    setState(() {
      if (mounted) {
        this.markers = markers;
        // print(markers);
      }
    });
  }

  //마커를 만드는 메서드
  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
          (cluster) async {
        print("132번 실행 : markerBuilder");
        print("아이템의 길이 : ${items.length}");
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
            List<FeedDto> clickFeedList = [];
            cluster.items.forEach((p) {
              // 눌렀을 때 나오는 id와 주변 feedId를 비교하여, 일치하는 것만 list를 생성해 담아준다
              for(int i = 0; i < feed.length; i++) {
                if(p.feedId == feed[i].feedId) {
                  clickFeedList.add(feed[i]);
                }
              }
            });
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(cluster.location.latitude - 0.002,
                      cluster.location.longitude),
                  zoom: 8.0),
            ));
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.75,
                  minChildSize: 0.3,
                  builder: (context, scrollController) {
                    return ListView(
                      controller: scrollController,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '피드 보기',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          color: Colors.purple,
                        ),
                        // Add the rest of your content here
                        for (var item in clickFeedList.reversed) ...[
                          buildFeedItem(item),
                        ],
                      ],
                    );
                  },
                );
              },
            );
          },
          icon: await _getMarkerBitmapFromAsset(
              emotion, cluster.isMultiple ? 180 : 120,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Widget buildFeedItem(FeedDto feedItem) {
    // Customize this function to build each feed item
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 100 * 73,
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              feedItem.title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          feedItem.nickname,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          feedItem.regDate,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                        feedItem.likeCnt > 99
                            ? "99+"
                            : feedItem.likeCnt.toString(),
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        FeedDto feedDto = FeedDto(
                            content: feedItem.content,
                            emotion: feedItem.emotion,
                            feedId: feedItem.feedId,
                            img: feedItem.img,
                            lat: feedItem.lat,
                            likeCnt: feedItem.likeCnt + 1,
                            lng: feedItem.lng,
                            nickname: feedItem.nickname,
                            regDate: feedItem.regDate,
                            title: feedItem.title,
                            userId: feedItem.userId);
                        feedProvider.addLikes(feedDto);
                        setState(() {
                          feedItem.likeCnt++;
                        });
                      },
                      child: Image(
                          image: AssetImage(
                              'assets/images/flower${feedItem.emotion}.png'),
                          height: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.center,
            child: Image(image: NetworkImage(feedItem.img)),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  feedItem.content,
                  style: const TextStyle(height: 1.5),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  //이미지를 불러와 우리가 원하는 비트맵으롭 변환
  Future<BitmapDescriptor> _getMarkerBitmapFromAsset(int emotion, int size,
      {String? text}) async {
    // print("584번 실행 : getMarkerBit뭐시기");
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
          initialCameraPosition: CameraPosition(
            target: currentPosition,
            zoom: 8,
          ),
          markers: markers,
          onCameraMove: _manager.onCameraMove,
          onCameraIdle: _manager.updateMap,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),
      ]),
    );
  }
}
