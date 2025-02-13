import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:mazzraati_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:mazzraati_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:mazzraati_vendor_app/localization/language_constrants.dart';

class LocationPicker extends StatefulWidget {
  final GoogleMapController? googleMapController;

  const LocationPicker({super.key, this.googleMapController});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _controller;
  final LatLng _initialPosition = const LatLng(24.7136, 46.6753); // Riyadh
  LatLng? _selectedLocation;
  String? _selectedAddress;
  final TextEditingController _searchController = TextEditingController();

  final String _googleApiKey = kIsWeb
      ? "AIzaSyAL0mf-wYCEO4N6xNkiJaau55bfRxdB4yk"
      : Platform.isAndroid
          ? "AIzaSyD57bzQp-wwWq2tZDtc82x7sNAsHTBw1Ho"
          : "AIzaSyD85M3foh7pZqcVbO8hVL15gNTYW13M0a0";

  @override
  void initState() {
    super.initState();
    if (widget.googleMapController != null) {
      _controller = widget.googleMapController!;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onTap(LatLng position) async {
    _selectedLocation = position;
    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&language=ar&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'].isNotEmpty) {
          final address = data['results'][0]['formatted_address'];

          setState(() {
            _selectedAddress = address;
            Provider.of<AuthController>(context, listen: false)
                .setAddress(address, location: position);
            Provider.of<AuthController>(context, listen: false)
                .shopAddressController
                .text = address;
          });
        } else {
          setState(() {
            _selectedAddress = getTranslated('address_not_found', context);
            Provider.of<AuthController>(context, listen: false)
                .setAddress("None");
          });
        }
      } else {
        throw Exception('Failed to fetch address');
      }
    } catch (e) {
      print(e);
      setState(() {
        _selectedAddress = "Address not found";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        await _getLocation();
      } else {
        print(getTranslated("permission_denied", context));
      }
    } else if (status.isGranted) {
      await _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      _controller.animateCamera(CameraUpdate.newLatLng(currentLatLng));

      _selectedLocation = currentLatLng;
      await _getAddressFromLatLng(currentLatLng);
    } catch (e) {
      print('${getTranslated("could_not_get_location", context) ?? ""}: $e');
    }
  }

  Future<List<dynamic>> _fetchSuggestions(String input) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_googleApiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['predictions'];
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<void> _moveToLocation(String placeId) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = data['result']['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);

      _controller.animateCamera(CameraUpdate.newLatLng(latLng));
      _onTap(latLng); // Update the selected location and address
    } else {
      throw Exception('Failed to fetch location details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: _selectedLocation!,
                      )
                    }
                  : {},
            ),
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: getTranslated("search_location", context) ??
                    "Search Location",
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              ),
            ),
            suggestionsCallback: _fetchSuggestions,
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion['description']),
              );
            },
            onSuggestionSelected: (suggestion) async {
              await _moveToLocation(suggestion['place_id']);
            },
          ),
        ),
      ),
      bottomNavigationBar: (_selectedAddress != null)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Text(
                    ' ${Provider.of<AuthController>(context, listen: false).address}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButtonWidget(
                      btnTxt: getTranslated(
                              "confirm_picked_location", context) ??
                          "Confirm Picked Location", //"Confirm Picked Location",
                      onTap: () {
                        if (Provider.of<AuthController>(context, listen: false)
                                .selectedLocation ==
                            Null) {
                          showCustomSnackBarWidget(
                              getTranslated("location_not_selected", context) ??
                                  "Location Not Selected",
                              context);
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                )
              ],
            )
          : const SizedBox(),
    );
  }
}
