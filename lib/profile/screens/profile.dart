import 'dart:async';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';
import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';
// import 'package:konek_app/Config/Config.dart';
import 'package:konek_app/content/uploadpic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../providers/profileprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../content/dashboard.dart';
import '../../content/home.dart';
import '../../features/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/myprofile';

  const MyProfile({super.key});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int _currentStep = 0;

  bool editStatus = false;


  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  var isLoadingSend = false;

  bool isLoading = true;

  String? _retrieveDataError;

  var _jsonResult;

  List<dynamic> _region = [];
  List<dynamic> _province = [];
  List<dynamic> _municipality = [];
  List<dynamic> _barangay = [];

  List<dynamic> _regionsId = [];
  String _provsId = '';
  String _munId = '';
  String _brgyId = '';
  List<dynamic> _tempMunicipalityKeys = [];
  List<dynamic> _tempMunicipality = [];
  var _tempRegion = {};

  String? _regionId;
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedMunicipality;
  String? _selectedBarangay;

  getPH() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/address.json");
    _jsonResult = json.decode(data);
    getRegion();
    getProvince();
    getMunicipality();
    getBarangay();
  }

  getRegion() {
    var region = [];
    final regions = _jsonResult.values.toList();
    _regionsId = _jsonResult.keys.toList();
    for (var x = 0; x < regions.length; x++) {
      region.add(regions[x]['region_name']);
    }

    setState(() {
      _region = region;
      _selectedRegion = _region[0];
      _regionId = _regionsId[0];
      // if (_userData['region'] == null) {
      //   _selectedRegion = _region[0];
      //   _regionId = _regionsId[0];
      // }
    });
  }

  String getRegionId() {
    int index = 0;
    for (var x = 0; x < _region.length; x++) {
      if (_selectedRegion == _region[x]) {
        index = x;
      }
    }

    // setState(() {
    //   _regionId = _regionsId[index];
    // });
    return _regionsId[index];
  }

  String getProvId() {
    int index = 0;
    for (var x = 0; x < _province.length; x++) {
      if (_selectedProvince == _province[x]) {
        index = x;
      }
    }

    // setState(() {
    //   _regionId = _provsId[index];
    // });

    return _provsId[index];
  }

  String getMunId() {
    int index = 0;
    for (var x = 0; x < _municipality.length; x++) {
      if (_selectedMunicipality == _municipality[x]) {
        index = x;
      }
    }

    // setState(() {
    //   _regionId = _regionsId[index];
    // });

    return _munId[index];
  }

  String getBrgyId() {
    int index = 0;
    for (var x = 0; x < _barangay.length; x++) {
      if (_selectedBarangay == _barangay[x]) {
        index = x;
      }
    }

    // setState(() {
    //   _regionId = _regionsId[index];
    // });

    return '123';
  }

  getProvince() {
    var tempProvince;
    var provinces = [];
    var region = [];
    var tempRegion = {};
    region = _jsonResult.values.toList();
    for (var x = 0; x < region.length; x++) {
      if (region[x]['region_name'] == _selectedRegion) {
        tempRegion = region[x];
        tempProvince = region[x]['province_list'].keys.toList();
        _provsId = region[x]['province_list'].keys.toList();
        for (var y = 0; y < tempProvince.length; y++) {
          provinces.add(tempProvince[y]);
        }
      }
    }

    setState(() {
      _tempRegion = tempRegion;
      _province = provinces;
      _selectedProvince = _province[0];
    });
  }

  // getProvince() {
  //   var tempProvince;
  //   var provinces = [];
  //   var region = [];
  //   var tempRegion = {};
  //   region = _jsonResult.values.toList();
  //   for (var x = 0; x < region.length; x++) {
  //     tempProvince = region[x]['province_list'].keys.toList();
  //     for (var y = 0; y < tempProvince.length; y++) {
  //       provinces.add(tempProvince[y]);
  //     }
  //   }

  //   provinces.sort((a, b) {
  //     return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
  //   });

  //   print(provinces);

  //   setState(() {
  //     _tempRegion = tempRegion;
  //     _province = provinces;

  //     _selectedProvince = _province[0];
  //   });
  // }

  changeRegion() {
    getProvince();
    getMunicipality();
    getBarangay();
  }

  changeProvince() {
    provinces.forEach((element) {
      if (_selectedProvince == element['provDesc']) {
        _provsId = element['provCode'];
      }
    });
    getMunicipalities(_provsId);
    // getBarangay(_provsId, );
  }

  getMunicipality() {
    var tempProvinceKeys;
    var tempProvince;
    var tempMunicipalitiesKeys;
    var tempMunicipalities;
    var municipalities = [];
    tempProvinceKeys = _tempRegion['province_list'].keys.toList();
    tempProvince = _tempRegion['province_list'].values.toList();

    for (var y = 0; y < tempProvinceKeys.length; y++) {
      if (tempProvinceKeys[y] == _selectedProvince) {
        tempMunicipalitiesKeys =
            tempProvince[y]['municipality_list'].keys.toList();
        _munId = tempProvince[y]['municipality_list'].keys.toList();
        tempMunicipalities =
            tempProvince[y]['municipality_list'].values.toList();

        for (var z = 0; z < tempMunicipalitiesKeys.length; z++) {
          municipalities.add(tempMunicipalitiesKeys[z]);
        }
        setState(() {
          _municipality = municipalities;

          _selectedMunicipality = municipalities[0];

          _tempMunicipalityKeys = tempMunicipalitiesKeys;
          _tempMunicipality = tempMunicipalities;
        });
      }
    }
  }

  getBarangay() {
    for (var a = 0; a < _tempMunicipalityKeys.length; a++) {
      if (_tempMunicipalityKeys[a] == _selectedMunicipality) {
        setState(() {
          _barangay = _tempMunicipality[a]['barangay_list'];
          _brgyId = _tempMunicipality[a]['barangay_list'];
          _selectedBarangay = _barangay[0];
          isLoading = false;
        });
      }
    }
  }


//Personal Information
  final txtFirstName = TextEditingController();
  final txtMiddleName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtCompleteAddress = TextEditingController();
  final txtPhoneNumber = TextEditingController();
  final txtSex = TextEditingController();
  final txtNewPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  final txtEmailAddress = TextEditingController();

  final fNameFocus = FocusNode();
  final mNameFocus = FocusNode();
  final lNameFocus = FocusNode();
  final addressFocus = FocusNode();
  final phoneFocus = FocusNode();

  final bool _isInit = false;
  var businessApplication;

  final bool _isKeptOn = false;
  final double _brightness = 1.0;
  static final int _currentPage = 0;
  final int _currentIndex = 0;
  var provinces = [];
  var municipalities = [];
  var barangays = [];

  var myProfile;

  final PageController _controller = PageController(
    initialPage: _currentPage,
  );

  String getImageName(filePath, ext) {
    var fileName = (filePath.path).split('/').last;
    if (fileName.contains('pdf')) {
      return "${txtFirstName.text.replaceAll(' ', '') + "_" + txtLastName.text.replaceAll(' ', '') + "_" + ext}.pdf";
    } else {
      return "${txtFirstName.text.replaceAll(' ', '') + "_" + txtLastName.text.replaceAll(' ', '') + "_" + ext}.png";
    }
  }

  void updateProfile() {
    var userInfo = {
      'm_name': txtMiddleName.text,
      'first_name': txtFirstName.text,
      'last_name': txtLastName.text,
      'address': txtCompleteAddress.text,
      'province': _provsId,
      'municipality': _munId,
      'barangay': _brgyId
    };

    // print(userInfo);
    updateMyProfile(userInfo);
  }

  void updateMyProfile(Map<String, dynamic> userInfo) async {
    try {
      bool isSaved = await Provider.of<ProfileProvider>(context, listen: false)
          .updateProfile(userInfo);
      if (isSaved) {
        setState(() {
          isLoadingSend = false;
        });
        AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          onDismissCallback: (BuildContext) {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
          },
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: "Update Profile",
          desc: "Successfully Updated",
          btnOkOnPress: () {
            // Navigator.pushReplacementNamed(context, Dashboard.routeName);
            // print(_selectedProvince);
          },
        ).show();

        // setState(() {
        //   _currentStep += 1;
        // });
      }
    } on HttpException catch (error) {
      // print(error);
      showError(error.toString());
    } catch (error) {
            if (error.toString().contains('Connection failed')) {
        showError('No Internet Connection');
      } else {
        showError('something went wrong');
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // print("here");
    //getProfile();
    // getPH();
  }

  getProfile() async {
    txtFirstName.text =
        myProfile['first_name'] == null ? '' : myProfile['first_name'];
    txtMiddleName.text =
        myProfile['middle_name'] == null ? '' : myProfile['middle_name'];
    txtLastName.text =
        myProfile['last_name'] == null ? '' : myProfile['last_name'];
    txtEmailAddress.text = myProfile['email'] == null ? '' : myProfile['email'];
    txtPhoneNumber.text =
        myProfile['mobile_no'] == null ? '' : myProfile['mobile_no'];
    txtCompleteAddress.text =
        myProfile['address'] == null ? '' : myProfile['address'];
  }

  Future<void> getMyProfile() async {
    var errorMessage;
    provinces = [];
    _province = [];
    try {
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      var prof = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfile();
      setState(() {
        myProfile = prof['data'];
        getProfile();
        // print(myProfile);
      });
    } on HttpException catch (error) {
      // print(error);
      showError(error.toString());
    } catch (error) {
      // showError(error.toString());
            if (error.toString().contains('Connection failed')) {
        showError('No Internet Connection');
      } else {
        showError('something went wrong');
      }
    }
  }

  Future<void> getProvinces() async {
    var errorMessage;
    provinces = [];
    _province = [];
    try {
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      var province = await Provider.of<ProfileProvider>(context, listen: false)
          .getProvince();
      setState(() {
        var userProv = '';
        var userProvCode = '';
        provinces = province['data'];
        provinces.forEach((element) {
          _province.add(element['provDesc']);
          if (myProfile['provCode'] != null) {
            if (myProfile['provCode'] == element['provCode']) {
              userProv = element['provDesc'];
              userProvCode = element['provCode'];
            }
          }
        });
        // print(_province);
        _selectedProvince = userProv == '' ? _province[0] : userProv;
        _provsId = myProfile['provCode'] == null
            ? provinces[0]['provCode'].toString()
            : myProfile['provCode'];
        getMunicipalities(_provsId);
      });
    } on HttpException catch (error) {
      // print(error);
      showError(error.toString());
    } catch (error) {
      if (error.toString().contains('Connection failed')) {
        showError('No Internet Connection');
      } else {
        showError('something went wrong');
      }
    }
  }

  Future<void> getMunicipalities(code) async {
    // print(code);
    var errorMessage;
    municipalities = [];
    _municipality = [];
    try {
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      var municipality =
          await Provider.of<ProfileProvider>(context, listen: false)
              .getCity(code);
      setState(() {
        var userMun = '';
        var userMunCode = '';
        municipalities = municipality['data'];
        municipalities.forEach((element) {
          _municipality.add(element['citymunDesc']);
          if (myProfile['citymunCode'] != null) {
            if (myProfile['citymunCode'] == element['citymunCode']) {
              userMun = element['citymunDesc'];
              _selectedMunicipality = element['citymunCode'];
            }
          }
        });
        _selectedMunicipality = userMun == '' ? _municipality[0] : userMun;
        _munId = myProfile['citymunCode'] == null
            ? municipalities[0]['citymunCode'].toString()
            : myProfile['citymunCode'];
        getBarangays(_munId);
      });
    } on HttpException catch (error) {
      // print(error);
      showError(error.toString());
    } catch (error) {
           if (error.toString().contains('Connection failed')) {
        showError('No Internet Connection');
      } else {
        showError('something went wrong');
      }
    }
  }

  Future<void> getBarangays(munCode) async {
    var errorMessage;
    barangays = [];
    _barangay = [];
    try {
      setState(() {
        isLoading = false;
      });
      //await Provider.of<Auth>(context, listen: false).login(txtUsernameController.text, txtPasswordController.text);
      var barangay = await Provider.of<ProfileProvider>(context, listen: false)
          .getBarangay(_provsId, munCode);
      setState(() {
        var userBrgy = '';
        var userBrgyCode = '';
        barangays = barangay['data'];
        barangays.forEach((element) {
          _barangay.add(element['brgyDesc']);
          if (myProfile['brgyCode'] != null) {
            if (myProfile['brgyCode'] == element['brgyCode']) {
              userBrgy = element['brgyDesc'];
              userBrgyCode = element['brgyCode'];
            }
          }
        });
        _selectedBarangay = userBrgy == '' ? _barangay[0] : userBrgy;
        _brgyId = myProfile['brgyCode'] == null
            ? barangays[0]['brgyCode']
            : myProfile['brgyCode'];
        isLoading = false;
      });
    } on HttpException catch (error) {
      // print(error);
      showError(error.toString());
    } catch (error) {
            if (error.toString().contains('Connection failed')) {
        showError('No Internet Connection');
      } else {
        showError('something went wrong');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //getUser();
    // editStatus = false;
    // getProfile();
    loadData();
    // txtFirstName.text = 'John';
    // txtMiddleName.text = 'Black';
    // txtLastName.text = 'Doe';
    // txtEmailAddress.text = 'johndoe@me.com';
    // txtPhoneNumber.text = '09123456789';
  }

  loadData() async {
    await getMyProfile();
    await getProvinces();
  }

  @override
  void dispose() {
    txtFirstName.dispose();
    txtMiddleName.dispose();
    txtLastName.dispose();
    txtEmailAddress.dispose();
    txtPhoneNumber.dispose();
    txtCompleteAddress.dispose();
    fNameFocus.dispose();
    mNameFocus.dispose();
    lNameFocus.dispose();
    addressFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  void enterVoucherCode() {
    late AwesomeDialog dialog;
    dialog = AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      keyboardAware: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Enter Voucher Code',
              // style: Theme.of(context).textTheme.titleLarge,
              style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 55, 57, 175),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              elevation: 0,
              color: Colors.blueGrey.withAlpha(40),
              child: TextFormField(
                // controller: txtCodeController,
                autofocus: true,
                minLines: 1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: InputBorder.none,
                  labelText: 'Voucher Code',
                  //prefixIcon: Icon(Icons.code),
                  errorStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 10,
                      color: Colors.redAccent[200],
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter voucher code';
                  }
                  // if (!value.contains('@')) {
                  //   return 'Invalid username';
                  // }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedButton(
              isFixedHeight: false,
              text: 'OK',
              color: const Color.fromARGB(255, 55, 57, 175),
              pressEvent: () {
                dialog.dismiss();
              },
            )
          ],
        ),
      ),
    );

    dialog.show();
  }

  // File? _imageGov;
  // final imagePickerGov = ImagePicker();
  // Future getImageGov() async {
  //   final imageGov = await imagePicker.pickImage(
  //       source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
  //   setState(() {
  //     _imageGov = File(imageGov!.path);
  //     isCheckPhotoGov = true;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 55, 57, 175),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.keyboard_arrow_left,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Dashboard.routeName);
                  } /*Navigator.of(context).pushReplacementNamed(TransactionPage.routeName)*/);
            }),
            automaticallyImplyLeading: false,
            title: Text('My Profile',
                style: GoogleFonts.poppins(
                    fontSize: useMobileLayout ? 16 : 18, color: Colors.white)),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey1,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              CustomFormField(
                                status: editStatus,
                                label: 'First Name',
                                controller: txtFirstName,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(mNameFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Middlename (optional)',
                                controller: txtMiddleName,
                                validator: (value) {
                                  return null;
                                },
                                initialValue: '',
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(lNameFocus);
                                },
                              ),
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Lastname',
                                controller: txtLastName,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(addressFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your lasst name';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Email Address',
                                controller: txtEmailAddress,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(phoneFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your TIN No.';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Mobile Number',
                                controller: txtPhoneNumber,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(addressFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              CustomFormField(
                                status: editStatus,
                                label: 'Address',
                                controller: txtCompleteAddress,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(phoneFocus);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your complete address';
                                  }
                                  return null;
                                },
                                initialValue: '',
                              ),
                              const SizedBox(height: 4),
                              // CustomFormField(
                              //   status: editStatus,
                              //   label: 'City',
                              //   controller: txtEducational,
                              //   onFieldSubmitted: (_) {
                              //     FocusScope.of(context)
                              //         .requestFocus(degreeFocus);
                              //   },
                              //   validator: (value) {
                              //     if (value.isEmpty) {
                              //       return 'Please enter your education attainment.';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: '',
                              // ),
                              // SizedBox(height: 4),
                              // CustomFormField(
                              //   status: editStatus,
                              //   label: 'Province',
                              //   controller: txtDegree,
                              //   onFieldSubmitted: (_) {
                              //     // FocusScope.of(context)
                              //     //     .requestFocus(
                              //     //         entityFocus);
                              //   },
                              //   validator: (value) {
                              //     if (value.isEmpty) {
                              //       return 'Please enter your degree/course.';
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: '',
                              // ),
                              const SizedBox(
                                height: 4,
                              ),
                              // CustomDropDown(
                              //   status: editStatus,
                              //   value: _selectedRegion,
                              //   items: _region,
                              //   title: "Region",
                              //   onChanged: (value) {
                              //     setState(() {
                              //       _selectedRegion = value.toString();
                              //       _regionId =
                              //           _regionsId[_region.indexOf(value)];
                              //       changeRegion();
                              //     });
                              //     return null;
                              //   },
                              //   validator: (value) {
                              //     if (value == null) {
                              //       return 'Please choose your region';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // const SizedBox(
                              //   height: 4,
                              // ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedProvince,
                                items: _province,
                                title: "Province",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedProvince = value.toString();
                                    changeProvince();
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your province';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedMunicipality,
                                items: _municipality,
                                title: "Municipality",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMunicipality = value.toString();
                                    var munCode;
                                    municipalities.forEach((element) {
                                      if (_selectedMunicipality ==
                                          element['citymunDesc']) {
                                        munCode = element['citymunCode'];
                                        _munId = element['citymunCode'];
                                      }
                                    });
                                    getBarangays(munCode);
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your city';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              CustomDropDown(
                                status: editStatus,
                                value: _selectedBarangay,
                                items: _barangay,
                                title: "Barangay",
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBarangay = value.toString();
                                    //_brgyId = (_barangay.indexOf(value) + 1).toString();
                                    barangays.forEach((element) {
                                      if (_selectedBarangay ==
                                          element['brgyDesc']) {
                                        _brgyId = element['brgyCode'];
                                      }
                                    });
                                  });
                                  return null;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please choose your barangay';
                                  }
                                  return null;
                                },
                              ),

                              // Container(
                              //   // height:  150,
                              //   //width: double.infinity,
                              //   width: useMobileLayout ? 600 : 700,

                              //   //height: useMobileLayout ? 90 : 150,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     color: Colors.white,
                              //   ),
                              //   padding: const EdgeInsets.symmetric(
                              //       vertical: 30, horizontal: 15),
                              //   child: Container(
                              //     child: SizedBox(
                              //       width: useMobileLayout ? 130 : 180,
                              //       height: 50,
                              //       child: ElevatedButton(
                              //         style: ElevatedButton.styleFrom(
                              //           foregroundColor: Colors.white,
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(50.0),
                              //           ),
                              //           backgroundColor: const Color.fromARGB(
                              //               255, 55, 57, 175), // foreground
                              //         ),
                              //         onPressed: () {
                              //           // enterVoucherCode();
                              //           Navigator.of(context)
                              //             .pushReplacementNamed(
                              //                 UploadPicture.routeName);
                              //         },
                              //         child: Text(
                              //           //useMobileLayout ? "+ APPLY" : "+ APPLY LOAN",
                              //           "VOUCHER CODE",
                              //           style: GoogleFonts.poppins(
                              //             textStyle: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: useMobileLayout ? 14 : 25,
                              //               fontWeight: FontWeight.w600,
                              //             ),
                              //           ),
                              //         ),
                              //         // color: Colors.white,
                              //         // textColor: Colors.black,
                              //         // splashColor: Colors.yellowAccent[800],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                ),
          bottomNavigationBar: !isLoading
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 5,
                      ),
                      editStatus == false
                          ? Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    editStatus = true;
                                  });
                                  // _formKey1.currentState.validate();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color.fromARGB(
                                      255, 55, 57, 175), // foreground
                                  //                color: Colors.yellow,
                                  // textColor: Colors.black,
                                  // splashColor: Colors.yellowAccent[800],
                                ),
                                child: Text(
                                  "EDIT PROFILE",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // color: Colors.green,
                                // textColor: Colors.black,
                                // splashColor: Colors.yellowAccent[800],
                              ),
                            )
                          : Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // _formKey1.currentState.validate();
                                  proceed();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color.fromARGB(
                                      255, 55, 57, 175), // foreground
                                  //                color: Colors.yellow,
                                  // textColor: Colors.black,
                                  // splashColor: Colors.yellowAccent[800],
                                ),
                                child: Text(
                                  "UPDATE",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  proceed() {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            onDismissCallback: (_) {
              //Navigator.of(context).pop();
            },
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            title: "Warning",
            desc: "Update Profile?",
            btnOkOnPress: () {
              isLoadingSend = true;
              updateProfile();
            },
            btnCancelOnPress: () {
              // Navigator.of(context).pop();
            })
        .show();
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  void awesomeDialog(DialogType dialogType, String title, String message) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      onDismissCallback: (_) {
        Navigator.of(context).pop();
      },
      context: context,
      animType: AnimType.scale,
      dialogType: dialogType,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null!;
  }

  Container dropDown(
      String? value,
      List<dynamic> items,
      String title,
      String? Function(Object?) onChanged,
      String? Function(Object?) validator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField(
        value: value,
        items: items
            .map((text) => DropdownMenuItem(
                  value: text,
                  child: Text('$text'),
                ))
            .toList(),
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // OutlineInputBorder
          // UnderlineInputBorder
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1,
            ),
          ),
          errorStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.redAccent[700],
            ),
          ),
          labelText: value != null ? title : null,
          labelStyle: value != null
              ? GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : null,
          hintText: value == null ? title : null,
          hintStyle: value == null
              ? GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
