import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GoogleMapController? mapController;
  int selectedIndex = 0;

  LatLng? currentLocation;

  // final CameraPosition initialCamera = const CameraPosition(
  //   target: LatLng(28.6139, 77.2090),
  //   zoom: 14,
  // );

  BitmapDescriptor? carIcon;
  BitmapDescriptor? userIcon;
  bool isLoadingLocation = true;
  bool showRatingSheet = false;
  Timer? _timer;
  int selectedMood = -1;

  Set<Marker> markers = {};

  Timer? carTimer;

  // Dummy nearby cars
  List<LatLng> carPositions = [];



  ///
  final ProfileController controller = Get.find<ProfileController>();
  @override
  void initState() {
    super.initState();

    checkLocationPermission();
    loadData();
  }

  void loadData() {
    controller.getAddressCustomer(context: context);
    Get.find<ProfileController>().getActivityData(
      context: context,
      typeOfSlug: 'ongoing',
    );

    Get.find<ProfileController>().customerWalletAmount();
    //customerWalletAmount
  }

  Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
    );

    final ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedBytes = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  // ================= USER PHOTO MARKER =================

  Future<BitmapDescriptor> createUserMarker() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    const size = 150.0;

    final Paint paint = Paint()..color = ColorResources.blueeebutton;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    final image = await loadNetworkImage(
      "assets/images/profile.png",
    ); // demo profile image

    paintImage(
      canvas: canvas,
      rect: const Rect.fromLTWH(15, 15, 120, 120),
      image: image,
      fit: BoxFit.cover,
    );

    final img = await recorder.endRecording().toImage(150, 150);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<ui.Image> loadNetworkImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }

  Future<void> getCurrentLocations() async {
    setState(() {
      isLoadingLocation = true; // Loader show
    });

    try {
      await Future.delayed(const Duration(seconds: 2)); // 2 sec delay

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation = LatLng(pos.latitude, pos.longitude);

      generateNearbyCars();

      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    } catch (e) {
      debugPrint("Location Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLocation = false; // Loader hide
        });
      }
    }
  }
  // ================= LOCATION =================

  Future<void> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            isLoadingLocation = false;
          });
        }
        return;
      }

      await getCurrentLocation();
    } catch (e) {
      debugPrint("Location permission Error: $e");
      if (mounted) {
        setState(() {
          isLoadingLocation = false;
        });
      }
    }
  }

  LatLng? currentLatLng;
  Future<void> getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation = LatLng(pos.latitude, pos.longitude);
      await Get.find<BookingController>().driverAvailableNearByApi(
        context: context,
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      currentLatLng = LatLng(pos.latitude, pos.longitude);
      generateNearbyCars();

      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    } catch (e) {
      debugPrint("Current location Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLocation = false;
        });
      }
    }

    //   setState(() {});
  }

  // ================= GENERATE RANDOM CARS =================

  void generateNearbyCars() {
    if (currentLocation == null) return;

    final random = Random();

    carPositions = List.generate(5, (index) {
      double lat =
          currentLocation!.latitude + (random.nextDouble() - 0.5) / 500;
      double lng =
          currentLocation!.longitude + (random.nextDouble() - 0.5) / 500;
      return LatLng(lat, lng);
    });

    startCarAnimation();
  }

  void startCarAnimation() {
    carTimer?.cancel();
    carTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return; // ✅ Prevent after dispose

      final random = Random();

      for (int i = 0; i < carPositions.length; i++) {
        carPositions[i] = LatLng(
          carPositions[i].latitude + (random.nextDouble() - 0.5) / 1000,
          carPositions[i].longitude + (random.nextDouble() - 0.5) / 1000,
        );
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    carTimer?.cancel();
    mapController = null;
    super.dispose();
  }
  // ================= MARKERS =================

  Set<Marker> buildMarkers() {
    final Set<Marker> m = {};

    if (currentLocation != null && userIcon != null) {
      m.add(
        Marker(
          markerId: const MarkerId("user"),
          position: currentLocation!,
          icon: userIcon!,
        ),
      );
    }

    if (carIcon != null) {
      for (int i = 0; i < carPositions.length; i++) {
        m.add(
          Marker(
            markerId: MarkerId("car_$i"),
            position: carPositions[i],
            icon: carIcon!,
            rotation: Random().nextDouble() * 360,
          ),
        );
      }
    }

    return m;
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GetBuilder<BookingController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.currentLatLng!,
                    zoom: 14,
                  ),

                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,

                  markers: controller.markers,

                  onMapCreated: (mapController) {
                    controller.mapController = mapController;
                  },
                ),
              );
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: ColorResources.whiteColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Where to?",
                    style: PoppinsMedium.copyWith(
                      color: ColorResources.blackcolor,
                    ),
                  ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.getsearchLocationScreen(),
                        arguments: {'addressdata': ''},
                      )?.then((_) {
                        Get.find<ProfileController>().getAddressCustomer(context: context);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/images/loaction.png"),
                          const SizedBox(width: 10),
                          Text(
                            "Enter location",
                            style: PoppinsReguler.copyWith(
                              color: ColorResources.textdetailsColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  GetBuilder<ProfileController>(
                    builder: (controller) {
                      final visibleAddressList = controller.addressList
                          .where((data) => !data.isNoAddressPlaceholder)
                          .toList();

                      if (controller.isLoadings == true) {
                        return const SizedBox(
                          height: 45,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                          ),
                        );
                      }

                      // ── Address list from customer-address-list API ──
                      if (visibleAddressList.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_off_rounded,
                                  size: 32,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "No trips yet",
                                  style: PoppinsMedium.copyWith(
                                    fontSize: 14,
                                    color: ColorResources.blackcolor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: visibleAddressList.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: Colors.grey.shade100),
                        itemBuilder: (context, index) {
                          final data = visibleAddressList[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Get.toNamed(
                                RouteHelper.getsearchLocationScreen(),
                                arguments: {'addressdata': data.address ?? ''},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: ColorResources.appColor
                                          .withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 20,
                                      color: ColorResources.appColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.label ?? "Saved Address",
                                          style: PoppinsMedium.copyWith(
                                            fontSize: 14,
                                            color: ColorResources.blackcolor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (data.address != null &&
                                            data.address!.isNotEmpty)
                                          Text(
                                            data.address!,
                                            style: PoppinsReguler.copyWith(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////// ========= location Item ===========================================

  Widget locationItem(String text, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        final controller = Get.find<ProfileController>();
        final selectedAddress = controller.addressList[index];

        print("Selected Address: ${selectedAddress.address}");
        Get.toNamed(
          RouteHelper.getsearchLocationScreen(),
          arguments: {'addressdata': selectedAddress.address},
        )?.then((_) {
          Get.find<ProfileController>().getAddressCustomer(context: context);
        });
        print("Selected Address: ${selectedAddress.address}");
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.spacingSize12,
          vertical: 10,
        ),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorResources.blueeebutton : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? ColorResources.blueeebutton
                : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: PoppinsReguler.copyWith(
            color: isSelected
                ? ColorResources.whiteColor
                : ColorResources.blackcolor11,
          ),
        ),
      ),
    );
  }
}
