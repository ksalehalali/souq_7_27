// @dart=2.9
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/models/ads_model.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/providers/auth.dart';
import '../screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddNewAd extends StatefulWidget {
  static const routeName = "AddNewAd";
  final BuildContext ctx;
  final isEdit;
  String id;

  AddNewAd(this.ctx, this.id, this.isEdit);

  @override
  _AddNewAdState createState() => _AddNewAdState();
}

bool loadingImage = false;
var time = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());
String priceText;
double price = 0;
int views = 0;
int likes = 0;
File imageG;
File image;
File image2;
File image3;
File image4;
File image5;
File image6;
File image7;
String imageUrl;
String imageUrl2;
String imageUrl3;
String imageUrl4;
String imageUrl5;
String imageUrl6;
String imageUrl7;
int phone;

var _editedProduct;

DocumentSnapshot oldData;

var _initialValues = {
  "date": '',
  "name": '',
  "description": '',
  "price": 0.0,
  "imagesUrl": '',
  "area": '',
  "category": '',
  "department": '',
  "status": '',
  "isFavorite": '',
  "uid": '',
  "likes": '',
  "views": '',
  "phone": 0,
  "isRequest": '',
};

class _AddNewAdState extends State<AddNewAd> {
  @override
  didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.isEdit == true) getEditInfo();
  }

  bool choseCategory = true;
  bool choseCategory2 = true;
  bool statusShow = true;
  bool showAreaTextField = false;
  var dropItemsGames = [
    '???????? ?????????? ????????????',
    '?????????? ????????????',
    '?????????? ??????????????',
    "?????????? ???????????? ??????????????",
    "????????"
  ];
  var dropItemsOccupationsAndServices = [
    '???????? ?????????? ????????????',
    '????????????',
    '?????????? ????????????',
    "?????????? ??????????????",
    "?????????? ??????????????",
    "?????????? ??????????",
    "????????"
  ];
  var dropItemsFood = [
    '???????? ?????????? ????????????',
    '?????????? ?????????? - ????????',
    '????????????',
    "?????????? ??????????",
    "????????"
  ];
  var dropItemsLivestocks = [
    '???????? ?????????? ????????????',
    '??????????',
    '??????????',
    "????????",
    "??????????"
  ];
  var dropItemsFarming = [
    '???????? ?????????? ????????????',
    '?????????? ????????????',
    '???????? ???????????? ??????????',
    "?????? ?????????????? ????????????????",
    "?????????? - ??????????"
  ];
  var dropItemsClothes = [
    '???????? ?????????? ????????????',
    '?????????? ????????????',
    '?????????? ????????????',
    "?????????? ??????????-??????????",
    "?????????? ??????????",
    "??????????"
  ];
  var dropItemsHome = [
    '???????? ?????????? ????????????',
    '?????????? ????????????????',
    '????????',
    "?????????????? - ????????",
    "?????????? ????????????",
    "?????????? - ???????????? - ??????????????",
    "????????"
  ];
  var dropItemsDevicesAndElectronics = [
    '???????? ?????????? ????????????',
    '???????????? - ??????????????',
    '?????????????? ??????????',
    "?????????????? - ??????????",
    "????????????",
    "?????????????? - ?????????? ????????????",
    "????????"
  ];
  var dropItemsCars = [
    '???????? ?????????? ????????????',
    '???????????? ??????????',
    '???????????? ??????????????',
    "?????? ????????",
    "???????????? ?????????? ??????????"
  ];
  var dropItemsMobile = [
    '???????? ?????????? ????????????',
    '??????',
    '??????????',
    '??????????????',
    '?????????? ????????????????',
    '??????????????????'
  ];
  var dropItemsCategory2 = [
    '???????? ?????????? ????????????',
  ];
  var dropSelectItemCategory2 = '???????? ?????????? ????????????';
  String category2 = '';

  var dropItemsCategory = [
    '???????? ?????????? ??????????????',
    '???????????????? - ????????????????',
    '????????????????',
    '?????????? - ????????????????????',
    '?????????? ????????????',
    '?????? ????????????',
    '????????????',
    '?????????????? ??????????????????',
    '??????????????',
    '??????????????',
    '??????????',
    '??????????',
    '??????????'
  ];
  var dropSelectItemCategory = '???????? ?????????? ??????????????';
  String category = '';
  List<String> dropItemsArea = [
    '???????? ????????????????',
  ];

  var dropSelectItemArea = '???????? ????????????????';
  String area = '';
  String area2 = '';
  String description;
  String name;
  bool chacked = false;
  bool chacked2 = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  var status = '????????????';
  List<String> urlImages = [
    'https://firebasestorage.googleapis.com/v0/b/souq-alfurat-89023.appspot.com/o/WhatsApp%20Image%202020-09-15%20at%2011.23.35%20AM.jpeg?alt=media&token=a7c3f2d7-2629-4519-9c61-93444f989688',
  ];
  String imageUrl;

  upImage() async {
    loadingImage = true;

    var storageImage = FirebaseStorage.instance.ref().child(_image.path);
    var taskUpload = storageImage.putFile(_image);
    imageUrl = await (await taskUpload.onComplete).ref.getDownloadURL();
    print(imageUrl);
    loadingImage = false;
    setState(() {
      urlImages.add(imageUrl);
      loadingImage = false;

      print(urlImages);

      //show
      if (image == null) {
        image = _image;
      } else if (image2 == null) {
        image2 = _image;
      } else if (image3 == null) {
        image3 = _image;
      } else if (image4 == null) {
        image4 = _image;
      } else if (image5 == null) {
        image5 = _image;
      } else if (image6 == null) {
        image6 = _image;
      } else if (image7 == null) {
        image7 = _image;
      }
    });
  }

  File _image;

  Future getImage(context) async {
    imageG = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 1000,
      maxHeight: 950,
    );
    setState(() {
      _image = imageG;
    });
    upImage();
  }

  getInfoDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var infoData = androidInfo.androidId;
    setState(() {
      deviceNo = infoData;
    });
  }

  getIosInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    setState(() {
      deviceNo = iosInfo.identifierForVendor;
      print(deviceNo);
    });
  }

  String deviceNo = '';

  int currentIndex = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      getInfoDevice();
    } else {
      getIosInfo();
    }
    addNewZ();
  }

  QuerySnapshot documentsAds;
  List<String> newZList = [];
  DocumentSnapshot usersList;

  //get edit info

  addNewZ() async {
    var firestore = Firestore.instance;

    QuerySnapshot qusListUsers =
        await firestore.collection('ZonesIOS').getDocuments();
    if (qusListUsers != null) {
      for (int i = 0; qusListUsers.documents.length > newZList.length; i++) {
        setState(() {
          newZList.add(qusListUsers.documents[i]['Z']);
        });
      }
      if (newZList.length > 1) {
        setState(() {
          dropItemsArea = newZList;
        });
      }
    }
  }

  getEditInfo() {
    if (widget.isEdit == true) {
      print('from did change');
      oldData =
          Provider.of<Products>(context, listen: false).findById(widget.id);
      _initialValues = {
        'id': oldData['id'],
        'name': oldData['name'],
        'description': oldData['description'],
        'price': oldData['price'],
        'area': oldData['area'],
        'phone': oldData['phone'],
        'status': oldData['status'],
        'deviceNo': oldData['deviceNo'],
        'category': oldData['category'],
        'uid': oldData['uid'],
        'department': oldData['department'],
        'imagesUrl': oldData['imagesUrl'],
        'isFavorite': oldData['isFavorite'],
        'isRequest': oldData['isRequest'],
        'views': oldData['views'],
        'likes': oldData['likes'],
        'creatorId': oldData['creatorId'],
        'creatorName': oldData['creatorName']

      };
      //urlImages = oldData['imagesUrl'];
      category = oldData['category'];
      category2 = oldData['department'];
      status = oldData['status'];
      area = oldData['area'];
      likes = oldData['likes'];
      views = oldData['views'];
    }
    print(oldData['department']);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    newZList.clear();
    nameController.clear();

      image = null;
      image2 = null;
      image3 = null;
      image4 = null;
      image5 = null;
      image6 = null;
      image7 = null;
      imageUrl = null;
      imageUrl2 = null;
      imageUrl3 = null;
      imageUrl4 = null;
      imageUrl5 = null;
      imageUrl6 = null;
      imageUrl7 = null;
      urlImages.clear();

    _initialValues = {
      "date": '',
      "name": '',
      "description": '',
      "price": 0.0,
      "imagesUrl": '',
      "area": '',
      "category": '',
      "department": '',
      "status": '',
      "isFavorite": false,
      "uid": '',
      "likes": '',
      "views": '',
      "phone": 0,
      "isRequest": false,
    };
  }

  Widget build(BuildContext context) {
    final userGetData =
        Provider.of<Auth>(context, listen: false).gitCurrentUserInfo();
    final creatorName = Provider.of<Auth>(context, listen: false).nameUser;
    final userId = Provider.of<Auth>(context, listen: false).userId;
    return Material(
        color: Colors.white60,
        child: Stack(overflow: Overflow.visible, children: <Widget>[
          Scaffold(
            body: Form(
              key: _formkey,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 1,
                        ),
                        InkWell(
                          onTap: () {
                            print(creatorName);
                          },
                          child: Text(
                            '?????? ????????????',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Montserrat-Arabic Regular',
                                height: 1.5),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              loadingImage = false;
                              widget.id = '';
                              Navigator.pushReplacementNamed(
                                  context, HomeScreen.routeName);
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 33,
                            )),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      color: Colors.grey[300],
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 4)),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: 5, top: 3, right: 5),
                              child: Stack(
                                alignment: Alignment(1, -2),
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      getImage(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue),
                                      height: 60,
                                      width: 85,
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '?????? ????????',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    'Montserrat-Arabic Regular',
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-1, 0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        onPressed: deleteImage),
                                  ),
                                  loadingImage
                                      ? Opacity(
                                          opacity: 0.6,
                                          child: Container(
                                            color: Colors.white,
                                            height: 60,
                                            width: 85,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 18),
                                              child: Center(
                                                child: SpinKitFadingCircle(
                                                  color: Colors.red,
                                                  size: 70,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(),
                                ],
                              )),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              image7 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image7 != null
                                          ? Image.file(
                                              image7,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              image6 != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: image6 != null
                                          ? Image.file(
                                              image6,
                                              fit: BoxFit.fill,
                                            )
                                          : Container(),
                                    )
                                  : Container(),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image5 != null
                                    ? Image.file(
                                        image5,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image4 != null
                                    ? Image.file(
                                        image4,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image3 != null
                                    ? Image.file(
                                        image3,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 50,
                                height: 50,
                                child: image2 != null
                                    ? Image.file(
                                        image2,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                              ),
                              Padding(padding: EdgeInsets.only(right: 4)),
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: image != null
                                      ? Image.file(
                                          image,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Container(
                      width: MediaQuery.of(context).size.width - 5,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.grey[300],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // ignore: deprecated_member_use
                        setState(() {
                          choseCategory = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back_ios,
                            size: 26,
                            color: Colors.grey[600],
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 1),
                              child: Text(
                                '???? ???????? ???????? ???????? ???? ?????????????? ?????? ??',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    height: 1.5),
                              )),
                        ],
                      ),
                    ),
                    choseCategory
                        ? Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.end,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                      iconSize: 30,
                                      style:
                                          TextStyle(color: Colors.green[800]),
                                      items: dropItemsCategory
                                          .map((String selectItem) {
                                        return DropdownMenuItem(
                                            value: selectItem,
                                            child: Text(selectItem));
                                      }).toList(),
                                      isExpanded: false,
                                      dropdownColor: Colors.grey[200],
                                      iconDisabledColor: Colors.green[800],
                                      iconEnabledColor: Colors.green[800],
                                      icon: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Icon(
                                            Icons.menu,
                                            size: 26,
                                          )),
                                      onChanged: (String theDate) {
                                        setState(() {
                                          dropItemsCategory2 = null;
                                          dropSelectItemCategory = null;
                                          dropSelectItemCategory2 = null;
                                          dropSelectItemCategory = theDate;
                                          category = dropSelectItemCategory;
                                          if (dropSelectItemCategory ==
                                              dropItemsCategory[2]) {
                                            dropItemsCategory2 =
                                                dropItemsMobile;
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsMobile[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[1]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsCars;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsCars[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[3]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsDevicesAndElectronics;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 =
                                                dropItemsDevicesAndElectronics[
                                                    1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[4]) {
                                            choseCategory2 = false;
                                            statusShow = false;
                                            category2 = dropSelectItemCategory;
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[5]) {
                                            choseCategory2 = true;
                                            statusShow = false;
                                            dropItemsCategory2 =
                                                dropItemsOccupationsAndServices;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 =
                                                dropItemsOccupationsAndServices[
                                                    1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[6]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsHome;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsHome[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[7]) {
                                            choseCategory2 = false;
                                            statusShow = true;
                                            category2 = dropSelectItemCategory;
                                            category = dropSelectItemCategory;
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[8]) {
                                            choseCategory2 = true;
                                            statusShow = false;
                                            dropItemsCategory2 =
                                                dropItemsLivestocks;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsLivestocks[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[9]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsFarming;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsFarming[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[10]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsGames;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsGames[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[11]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 =
                                                dropItemsClothes;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsClothes[1];
                                          } else if (dropSelectItemCategory ==
                                              dropItemsCategory[12]) {
                                            choseCategory2 = true;
                                            statusShow = true;
                                            dropItemsCategory2 = dropItemsFood;
                                            dropSelectItemCategory2 =
                                                dropSelectItemCategory2;
                                            category2 = dropItemsFood[1];
                                          }
                                        });
                                        print(category);
                                        print(category2);
                                      },
                                      value: dropSelectItemCategory,
                                      elevation: 9,
                                    ),
                                    Text(
                                      ': ???????? ?????????? ?????????????? ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily:
                                              'Montserrat-Arabic Regular',
                                          height: 0.5),
                                    ),
                                  ],
                                ),
                                choseCategory2
                                    ? Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.end,
                                        children: <Widget>[
                                          DropdownButton<String>(
                                            iconSize: 28,
                                            style: TextStyle(
                                                color: Colors.green[800]),
                                            items: dropItemsCategory2
                                                .map((String selectItem) {
                                              return DropdownMenuItem(
                                                  value: selectItem,
                                                  child: Text(selectItem));
                                            }).toList(),
                                            isExpanded: false,
                                            dropdownColor: Colors.grey[200],
                                            iconDisabledColor:
                                                Colors.green[800],
                                            iconEnabledColor: Colors.green[800],
                                            icon: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 5),
                                                child: Icon(
                                                  Icons.menu,
                                                  size: 27,
                                                )),
                                            onChanged: (String theDate) {
                                              setState(() {
                                                dropSelectItemCategory2 =
                                                    theDate;
                                                category2 =
                                                    dropSelectItemCategory2;
                                              });
                                              print(category);
                                              print(category2);
                                            },
                                            value: dropSelectItemCategory2,
                                            elevation: 7,
                                          ),
                                          Text(
                                            ': ???????? ?????????? ???????????? ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    'Montserrat-Arabic Regular',
                                                height: 0.5),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 10, bottom: 2, top: 2),
                          child: SizedBox(
                            height: 54,
                            width: 240,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '???????? ?????? ??????????????';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                name = val;
                              },
                              onChanged: (val) {
                                name = val;
                              },
                              maxLines: 1,
                              initialValue: _initialValues['name'].toString(),
                              maxLength: 32,
                              //controller: nameController,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: '"???????? : "?????????? ?? ??????????',
                                hintStyle: TextStyle(fontSize: 12, height: 1),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '???? ?????? ??????????????',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat-Arabic Regular',
                              height: 1),
                        ),
                      ],
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: 10, left: 5, bottom: 2, top: 4),
                          child: SizedBox(
                            height: 80,
                            width: 230,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '???????? ???????????? ???????? ??????????????';
                                }
                                return null;
                              },
                              initialValue:
                                  _initialValues['description'].toString(),
                              onSaved: (val) {
                                description = val;
                              },
                              maxLines: 10,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: '???? ???????????? ???????? ?????????????? ',
                                fillColor: Colors.grey,
                                hoverColor: Colors.grey,
                              ),
                              cursorRadius: Radius.circular(5),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(
                            '???? ?????? ??????????????',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat-Arabic Regular',
                                height: 1.8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 5,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        Text(
                          ': ???????? ???????????? ???????? ???? ???????????? ',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat-Arabic Regular',
                              height: 1.8),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            CheckboxListTile(
                              title: Text(
                                '????????',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    height: 0.5),
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: chacked,
                              onChanged: (value) {
                                setState(() {
                                  chacked = value;
                                  chacked2 = false;
                                  status = '????????';
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text(
                                '????????????',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Montserrat-Arabic Regular',
                                    height: 0.5),
                              ),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: chacked2,
                              onChanged: (value) {
                                setState(() {
                                  chacked2 = value;
                                  chacked = false;
                                  status = '????????????';
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            DropdownButton<String>(
                              iconSize: 22,
                              style: TextStyle(color: Colors.green[800]),
                              items: dropItemsArea.map((String selectItem) {
                                return DropdownMenuItem(
                                    value: selectItem, child: Text(selectItem));
                              }).toList(),
                              isExpanded: false,
                              dropdownColor: Colors.grey[200],
                              iconDisabledColor: Colors.green[800],
                              iconEnabledColor: Colors.green[800],
                              icon: Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.menu,
                                    size: 26,
                                  )),
                              onChanged: (String theArea) {
                                setState(() {
                                  dropSelectItemArea = theArea;
                                  area2 = theArea;
                                  showAreaTextField = true;
                                });
                              },
                              value: dropSelectItemArea,
                              elevation: 7,
                            ),
                            Text(
                              '???????? ???????????????? ???? ???????? ????????????',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Montserrat-Arabic Regular',
                                  height: 1),
                            ),
                            showAreaTextField
                                ? SizedBox(
                                    height: 54,
                                    width: 200,
                                    child: TextFormField(
                                      controller: areaController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return '???????? ???????????? ...';
                                        }
                                        return null;
                                      },
                                      onSaved: (val){
                                        area = '$area2 - $val';
                                      },
                                      maxLength: 30,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        hintText: '... ???????? ???????????? ??????',
                                        hintStyle:
                                            TextStyle(fontSize: 12, height: 1),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.green),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueAccent,
                            ),
                            height: 30,
                            width: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 3, left: 3, right: 1),
                            child: SizedBox(
                              width: 230,
                              height: 38,
                              child: TextFormField(
                                initialValue:
                                    _initialValues['price'].toString(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return ' ???? ?????? ??????????????';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return ' Please provide a valid number';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return ' Please enter a number';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  price = double.parse(val);
                                },
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      '!... ???????? ?????????? ?????????????? ,?????????? ????????????????',
                                  hintStyle: TextStyle(fontSize: 12, height: 1),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 2, top: 1),
                              child: Icon(
                                Icons.attach_money,
                                size: 40,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Container(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 6, bottom: 3, left: 3, right: 1),
                            child: SizedBox(
                              width: 230,
                              height: 38,
                              child: TextFormField(
                                initialValue:
                                    _initialValues['phone'].toString(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '!... ???????? ?????? ??????????';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  phone = int.parse(val);
                                },
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText:
                                      '!... ???????? ?????? ??????????, ?????????? ????????????????',
                                  hintStyle: TextStyle(fontSize: 12, height: 1),
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                ),
                                cursorRadius: Radius.circular(10),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 2, top: 1),
                              child: Icon(
                                Icons.phone_iphone,
                                size: 40,
                                color: Colors.blueAccent,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 5,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3, bottom: 10),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 140,
                            height: 54,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  final isValid =
                                      _formkey.currentState.validate();
                                  _formkey.currentState.save();
                                  FocusScope.of(context).unfocus();
                                  _editedProduct = Product(
                                    time: DateFormat('yyyy-MM-dd-HH:mm')
                                        .format(DateTime.now()),
                                    creatorName: creatorName,
                                    id: '',
                                    name: name,
                                    creatorId:userId ,
                                    description: description,
                                    price: price,
                                    area: area,
                                    phone: phone,
                                    status: status,
                                    deviceNo: deviceNo,
                                    category: category,
                                    uid: userId,
                                    department: category2,
                                    imagesUrl: urlImages,
                                    isFavorite: false,
                                    isRequest: false,
                                    views: views,
                                    likes: likes,
                                  );

                                  if (urlImages.length > 1) {
                                    if (widget.isEdit) {
                                      print(widget.id);
                                      try {
                                        print(_editedProduct.area);
                                        await Provider.of<Products>(context,
                                                listen: false)
                                            .updateProduct(
                                                widget.id, _editedProduct);
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      'An error occurred!'),
                                                  content:
                                                      Text('SomeThing Wrong'),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                      child: Text('Okay!'),
                                                    )
                                                  ],
                                                ));
                                      }
                                    } else {
                                      try {
                                        await Provider.of<Products>(context,
                                                listen: false)
                                            .addProduct(_editedProduct);
                                         Navigator.of(context).pop();
                                      } catch (e) {
                                        await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                      'An error occurred!'),
                                                  content:
                                                      Text('SomeThing Wrong'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                      child: Text('Okay!'),
                                                    )
                                                  ],
                                                ));
                                      }
                                    }
                                  } else {
                                    await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              title: Text('???? ???????? ????????',style: Theme.of(context).textTheme.headline3,),
                                              content: Text('?????? ???????? ????????????',style: Theme.of(context).textTheme.headline3),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: Text('Okay !',style: Theme.of(context).textTheme.headline3),
                                                )
                                              ],
                                            ));
                                  }
                                },
                                child: Card(
                                  color: Colors.blue[900],
                                  child: Center(
                                    child: Text('???????? ????????????',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily:
                                                'Montserrat-Arabic Regular',
                                            height: 1,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  deleteImage() {
    setState(() {
      image = null;
      image2 = null;
      image3 = null;
      image4 = null;
      image5 = null;
      image6 = null;
      image7 = null;
      imageUrl = null;
      imageUrl2 = null;
      imageUrl3 = null;
      imageUrl4 = null;
      imageUrl5 = null;
      imageUrl6 = null;
      imageUrl7 = null;
      urlImages.clear();
    });
  }

  showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.blue,
        fontSize: 17,
        textColor: Colors.white);
  }
}
