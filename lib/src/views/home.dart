import 'dart:async';

import 'package:eazi_ride/src/components/button.dart';
import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/loader.dart';
import 'package:eazi_ride/src/components/map.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/controllers/home.dart';
import 'package:eazi_ride/src/services/http.dart';
import 'package:eazi_ride/src/services/ride.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Home extends StatelessWidget {
  final Http http = Get.put(Http());
  final RideService rideService = Get.put(RideService());

  final HomeController controller = Get.put(HomeController());
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) {
          return Obx(() => Stack(
            children: [
              GoogleMap(
                compassEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * .4, 
                ),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(6.577571, 3.349315),
                  zoom: 14.4746,
                ),
                style: controller.mapStyle,
                onMapCreated: (GoogleMapController ctrl) {
                  mapController.complete(ctrl);
                },
              ),
              DraggableScrollableSheet(
                controller: controller.bottomSheetController,
                initialChildSize: 0.5,
                minChildSize: 0.5,
                maxChildSize: 1,
                snap: true,
                builder:(context, scrollController) {
                  return Card(
                    margin: EdgeInsets.zero,
                    shape:const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Obx(() {
                          if (controller.rideState.value == RideState.initial) {
                            return ListView(
                              padding: EdgeInsets.only(top: 0),
                              controller: scrollController,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.gotoSelectLocation();
                                  },
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: colorGrey.withOpacity(.1),
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.search),
                                        const SizedBox(width: 8,),
                                        Text('Where to?')
                                      ]
                                    )
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildLocHistoryItem(),
                                const SizedBox(height: 8,),
                                _buildLocHistoryItem(),
                                const SizedBox(height: 8,),
                                _buildLocHistoryItem(),
                              ],
                            );
                          }

                          if (controller.rideState.value == RideState.selectLocation) {
                            return ListView.separated(
                              controller: scrollController,
                              padding: EdgeInsets.only(top: 200),
                              itemBuilder:(ctx, idx) {
                                final prediction = controller.predictions[idx];
                                final subtitle = prediction['terms']?[prediction['terms'].length - 2];

                                return _buildLocHistoryItem(
                                  title: prediction['description'],
                                  subtitle: subtitle['value'],
                                  onTap: () {
                                    if (controller.activeField == ActiveField.from) {
                                      controller.fromController.text = prediction['description'];
                                      controller.fromId = prediction['place_id'];
                                      if (controller.toId?.isEmpty ?? true) {
                                        FocusScope.of(context).requestFocus(controller.toFocus);
                                        controller.predictions.clear();
                                      }
                                    }

                                    if (controller.activeField == ActiveField.to) {
                                      controller.toController.text = prediction['description'];
                                      controller.toId = prediction['place_id'];
                                      if (controller.fromId?.isEmpty ?? true) {
                                        FocusScope.of(context).requestFocus(controller.fromFocus);
                                        controller.predictions.clear();
                                      }
                                    }

                                    print('fromId: ${controller.fromId}');
                                    print('toId: ${controller.toId}');
                                    if ((controller.fromId?.isNotEmpty ?? false) && (controller.toId?.isNotEmpty ?? false)) {
                                      controller.gotoSelectRide();
                                    }
                                  }
                                );
                              }, 
                              separatorBuilder: (context, index) => const SizedBox(height: 4), 
                              itemCount: controller.predictions.length
                            );
                          }

                          if (controller.rideState.value == RideState.selectRide) {
                            return Stack(
                              children: [
                                ListView(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  children: [
                                    Text('Choose your vehicle type', style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    )),
                                    const SizedBox(height: 16,),
                                    _buildVehicleType(
                                      title: 'Regular',
                                      time: '2 mins',
                                      capacity: 4,
                                      amount: '3,200',
                                      selected: controller.rideType.value == RideType.regular,
                                      onTap: () => controller.rideType.value = RideType.regular
                                    ),
                                    const SizedBox(height: 16),
                                    _buildVehicleType(
                                      title: 'Executive',
                                      time: '3 mins',
                                      capacity: 4,
                                      amount: '5000',
                                      selected: controller.rideType.value == RideType.executive,
                                      onTap: () => controller.rideType.value = RideType.executive
                                    ),
                                    const SizedBox(height: 16),
                                    _buildVehicleType(
                                      title: 'Economy',
                                      time: '7 mins',
                                      capacity: 4,
                                      amount: '2,500',
                                      selected: controller.rideType.value == RideType.economy,
                                      onTap: () => controller.rideType.value = RideType.economy
                                    ),
                                    // const SizedBox(height: ,)
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 100,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: Button(
                                              label: 'Book Now',
                                              onPressed: () {},
                                            )
                                          )
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 60,
                                          height: 50,
                                          // color: Colors.yellow,
                                          child: Button(label: 'T', onPressed: () {}),
                                        )
                                      ],
                                    ),
                                  )
                                )
                              ],
                            );
                          }

                          return Container();
                        })
                      )
                    ),
                  );
                },
              ),

              if (controller.rideState.value == RideState.selectLocation)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                top: controller.locationPickerPos.value,
                left: 16,
                right: 16,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.rideState.value = RideState.initial;
                                controller.bottomSheetController.reset();
                              },
                              child: Icon(Icons.close)
                            ),
                            const SizedBox(width: 8,),
                            Text('Select Location')
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          // color: Colors.yellow,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black)
                                ),
                                height: 110,
                                width: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: TimelineTile(
                                        isFirst: true,
                                        afterLineStyle: LineStyle(thickness: 1),
                                        indicatorStyle: IndicatorStyle(
                                          width: 12,
                                          height: 12,
                                          color: Colors.green
                                        ),
                                        alignment: TimelineAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: TimelineTile(
                                        isLast: true,
                                        beforeLineStyle: LineStyle(thickness: 1),
                                        indicatorStyle: IndicatorStyle(
                                          width: 12,
                                          height: 12,
                                          color: Colors.red
                                        ),
                                        alignment: TimelineAlign.center,
                                      ),
                                    ),
                                  ] 
                                )
                              ),
                              const SizedBox(width: 12,),
                              Expanded(
                                child: Column(
                                  children: [
                                    Input(
                                      controller: controller.fromController,
                                      placeholder: 'Pickup point',
                                      onChanged: (v) {
                                        controller.getLocation(v);
                                      },
                                      focusNode: controller.fromFocus,
                                    ),
                                    Input(
                                      controller: controller.toController,
                                      placeholder: 'Where to?',
                                      onChanged: (v) {
                                        controller.getLocation(v);
                                      },
                                      focusNode: controller.toFocus,
                                    )
                                  ],
                                )
                              )
                            ],
                          )
                        )
                      ],
                    )
                  )
                ),
              )
            ],
          ));
        },
        onLoading: const Loader()
      )
    );
  }

  Widget _buildLocHistoryItem({String? title, String? subtitle, Function()? onTap}) {
    return ListTile(
      // tileColor: colorGrey.withOpacity(.1),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorGrey.withOpacity(.1),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Icon(Icons.history, size: 30,)
      ),
      title: Text(title ?? '', style: TextStyle(
        fontWeight: FontWeight.w500
      )),
      subtitle: Text(subtitle ?? '', style: TextStyle(
        color: colorGrey
      )),
      onTap: onTap,
    );
  }

  Widget _buildVehicleType({String? title, String? time, int? capacity, String? amount, bool selected = false, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: selected ? BoxDecoration(
          border: Border.all(color: colorPrimary),
          borderRadius: BorderRadius.circular(8)
        ) : null,
        child: ListTile(
          leading: Container(
            width: 70,
            height: 70,
            color: colorPrimary,
          ),
          title: Text(title ?? ''),
          subtitle: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.watch_later_outlined, size: 16,),
                    const SizedBox(width: 2,),
                    Text(time ?? '', style: TextStyle(
                      fontSize: 12
                    ))
                  ]
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person_4_outlined, size: 16,),
                    const SizedBox(width: 2,),
                    Text('${capacity ?? 0}', style: TextStyle(
                      fontSize: 12
                    ))
                  ]
                ),
              )
            ],
          ),
          trailing: Text(amount ?? ''),
        )
      ),
    );
  }
}