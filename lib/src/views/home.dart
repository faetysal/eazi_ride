import 'dart:async';

import 'package:eazi_ride/src/components/input.dart';
import 'package:eazi_ride/src/components/loader.dart';
import 'package:eazi_ride/src/components/map.dart';
import 'package:eazi_ride/src/config.dart';
import 'package:eazi_ride/src/controllers/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Home extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) {
          return Stack(
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
                initialChildSize: 0.4,
                minChildSize: 0.4,
                maxChildSize: 1,
                snap: true,
                builder:(context, scrollController) {
                  return Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      )
                    ),
                    child: SafeArea(
                      top: false,
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                        itemCount: 2,
                        itemBuilder: (ctx, idx) {
                          if (idx == 0) {
                            return Container(
                              height: kToolbarHeight + 150,
                              alignment: Alignment.topCenter,
                              child: GestureDetector(
                                onTap: () => controller.bottomSheetController.animateTo(
                                  1, 
                                  duration: Duration(milliseconds: 100), 
                                  curve: Curves.linear
                                ),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.centerLeft,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: colorGrey.withOpacity(.2)
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search),
                                      const SizedBox(width: 8,),
                                      Text('Where to?')
                                    ]
                                  )
                                ),
                              )
                            );
                          }

                          return Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text('Expand')
                            ),
                          );

                          return Container(
                            height: 100,
                            color: Colors.amber,
                            margin: EdgeInsets.only(bottom: 12),
                          );
                        }
                      )
                    ),
                  );
                },
              ),
              Positioned(
                top: kToolbarHeight,
                left: 16,
                right: 16,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Container(
                    width: double.infinity,
                    // color: Colors.yellow,
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                placeholder: 'Pickup point',
                              ),
                              Input(
                                placeholder: 'Where to?',
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
          );
        },
        onLoading: const Loader()
      )
    );
  }
}