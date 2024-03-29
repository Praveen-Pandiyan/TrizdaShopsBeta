import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'data.dart';
import 'package:intl/intl.dart';
import 'package:stopper/stopper.dart';
import 'package:url_launcher/url_launcher.dart';

class SimPro extends StatefulWidget {
  SimPro({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SimProState createState() => _SimProState();
}

class _SimProState extends State<SimPro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Upload product',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ))),
          elevation: 0.5,
        ),
        body: SimpleProd());
  }
}

class SimpleProd extends StatefulWidget {
  @override
  _SimpleProdState createState() => _SimpleProdState();
}

class _SimpleProdState extends State<SimpleProd> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ValueChanged _onChanged = (val) => print(val);
  List<Widget> commentWidgets = [];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    var tstyle = TextStyle(
        fontFamily: 'Roboto-Regular',
        decoration: TextDecoration.underline,
        decorationColor: Colors.orange,
        decorationThickness: 2,
        fontSize: 20);
    pr.style(
        message: 'Uploading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormBuilder(
                key: _fbKey,
                // autovalidate: true,
                initialValue: {},
                readOnly: false,
                child: Column(children: <Widget>[
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Basic info",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),
                  // form options
                  FormBuilderImagePicker(
                    attribute: 'images',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Images',
                    ),
                    maxImages: 5,
                    iconColor: Colors.orange,
                    // readOnly: true,
                    validators: [
                      FormBuilderValidators.required(),
                      (images) {
                        if (images.length < 2) {
                          return 'Two or more images required.';
                        }
                        return null;
                      }
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'product_name',
                    decoration: const InputDecoration(
                      labelText: "Product title",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          // borderSide: new BorderSide(),
                          ),
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2, allowEmpty: false),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                  ),

                  SizedBox(height: 15),
                  FormBuilderTypeAhead(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category',
                    ),
                    attribute: 'category',
                    onChanged: _onChanged,
                    itemBuilder: (context, country) {
                      return ListTile(
                        title: Text(country),
                      );
                    },
                    controller: TextEditingController(text: ''),
                    initialValue: '',
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return allCat.where((country) {
                          return country.toLowerCase().contains(lowercaseQuery);
                        }).toList(growable: false)
                          ..sort((a, b) => a
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(
                                  b.toLowerCase().indexOf(lowercaseQuery)));
                      } else {
                        return allCat;
                      }
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderChoiceChip(
                    selectedColor: Colors.grey[200],
                    backgroundColor: Colors.white,
                    attribute: "color",
                    elevation: 0,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Product color',
                    ),
                    options: [
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.red),
                        value: "red",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.redAccent),
                        value: "light red",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.pink),
                        value: "pink",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.pinkAccent),
                        value: "light pink",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.orange),
                        value: "orange",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.yellow[700]),
                        value: "yellow",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.blue),
                        value: "blue",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.lightBlue),
                        value: "light blue",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.green),
                        value: "green",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.lightGreen),
                        value: "light green",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.purple),
                        value: "purple",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.deepPurple),
                        value: "dark purple",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.brown),
                        value: "brown",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.yellow),
                        value: "yellow",
                      ),
                      FormBuilderFieldOption(
                        child: Opacity(
                            opacity: 0.4,
                            child: Icon(
                              Icons.lens,
                              color: Colors.black12,
                            )),
                        value: "white",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.grey),
                        value: "grey",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.blueGrey),
                        value: "blue grey",
                      ),
                      FormBuilderFieldOption(
                        child: Icon(Icons.lens, color: Colors.black),
                        value: "black",
                      ),
                    ],
                  ),

                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'S_dis',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Short discription',
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.numeric(),

                      FormBuilderValidators.minLength(20, allowEmpty: false),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'F_dis',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full discription (optional)',
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      // FormBuilderValidators.numeric(),

                      // FormBuilderValidators.minLength(20),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Pricing and delivery",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                      attribute: "price",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // contentPadding: EdgeInsets.only(
                        //     top: 20), // add padding to adjust text
                        isDense: false,
                        labelText: "Price (₹)",
                        // prefixIcon: Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 15), // add padding to adjust icon
                        //   child: Icon(Icons.attach_money),
                        // ),
                      ),
                      validators: [
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70000),
                      ],
                      keyboardType: TextInputType.number),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                      attribute: "sales_price",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // contentPadding: EdgeInsets.only(
                        //     top: 20), // add padding to adjust text
                        isDense: false,
                        labelText: "Sales Price (₹)",
                        // prefixIcon: Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 15), // add padding to adjust icon
                        //   child: Icon(Icons.attach_money),
                        // ),
                      ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70000),
                      ],
                      keyboardType: TextInputType.number),
                  SizedBox(height: 15),
                  FormBuilderChoiceChip(
                    attribute: 'delivery_vehicle',
                    spacing: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select delivery vehicle',
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: '2',
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('two wheeler'),
                          )),
                      FormBuilderFieldOption(
                          value: '4',
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('four wheeler'),
                          )),
                    ],
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Stack Management",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                      attribute: "num_stacks",
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        labelText: "Number of stacks",
                        prefixIcon: Icon(Icons.format_list_numbered_rtl),
                      ),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(1000),
                      ],
                      keyboardType: TextInputType.number),

                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Offer coupon (optional)",
                      style: tstyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 15),

                  FormBuilderTextField(
                    attribute: 'coupon_code',
                    decoration: const InputDecoration(
                      labelText: "Coupon code",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          // borderSide: new BorderSide(),
                          ),
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.max(10),
                      // FormBuilderValidators.minLength(4),
                    ],
                    maxLines: 1,
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: 'D_price',
                    decoration: const InputDecoration(
                      labelText: "Discount price",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          // borderSide: new BorderSide(),
                          ),
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.max(70),
                      // FormBuilderValidators.minLength(2),
                    ],
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                  ),
                  SizedBox(height: 15),
                  FormBuilderDateRangePicker(
                    attribute: 'date_range',
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 20)),
                    format: DateFormat('dd-MM-yyyy'),
                    onChanged: _onChanged,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Validity',
                    ),
                  ),
                  // FormBuilderDropdown(
                  //   attribute: "gender",
                  //   decoration: InputDecoration(labelText: "Gender"),
                  //   // initialValue: 'Male',
                  //   hint: Text('Select Gender'),
                  //   validators: [FormBuilderValidators.required()],
                  //   items: ['Male', 'Female', 'Other']
                  //       .map((gender) => DropdownMenuItem(
                  //           value: gender, child: Text("$gender")))
                  //       .toList(),
                  // ),
                  SizedBox(height: 15),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Theme.of(context).accentColor,
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xfffc7f03), Color(0xfffabd05)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showStopper(
                          context: context,
                          stops: [0.5 * height, height],
                          builder:
                              (context, scrollController, scrollPhysics, stop) {
                            return Column(
                              children: [
                                TextField(),
                                Expanded(
                                    child: new ListView(
                                  children: commentWidgets,
                                )),
                                RaisedButton(
                                    child: Text("dhd"),
                                    onPressed: () {
                                      setState(() {
                                        commentWidgets.add(
                                          Text("kkk"),
                                        );
                                      });
                                    })
                              ],
                            );
                          });
                    },
                  ),

                  SizedBox(height: 15),
                  FormBuilderCheckbox(
                    decoration: InputDecoration(
                      border: null,
                    ),
                    leadingInput: true,
                    attribute: 'accept_terms',
                    tristate: false,
                    label: new RichText(
                      textScaleFactor: 2,
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: 'I have read and agree to the trizda`s ',
                            style: new TextStyle(color: Colors.black),
                          ),
                          new TextSpan(
                            text: 'terms and conditions',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launch(
                                    'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                              },
                          ),
                        ],
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.requiredTrue(
                        errorText:
                            "You must accept terms and conditions of trizda to continue",
                      ),
                    ],
                  ),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Theme.of(context).accentColor,
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xfffc7f03), Color(0xfffabd05)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _fbKey.currentState.reset();
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Theme.of(context).accentColor,
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xfffc7f03), Color(0xfffabd05)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var data = _fbKey.currentState;
                      StorageReference storageReference =
                          await FirebaseStorage.instance.ref();
                      var _images = data.fields['images'].currentState.value;
                      var imgurl = null;

                      DocumentReference ref = Firestore.instance
                          .collection("my_collection")
                          .document();
                      String prod_Id = ref.documentID;

                      //function to call

                      addImageToFirebase(index, image) async {
                        //CreateRefernce to path.
                        StorageReference ref =
                            storageReference.child("product_pics/$prod_Id/");
                        print("hello");
                        StorageUploadTask storageUploadTask =
                            ref.child("img$index.jpg").putFile(image);

                        if (storageUploadTask.isSuccessful ||
                            storageUploadTask.isComplete) {
                          final String url = await ref.getDownloadURL();
                          print("The download URL is " + url);
                        } else if (storageUploadTask.isInProgress) {
                          storageUploadTask.events.listen((event) {
                            double percentage = 100 *
                                (event.snapshot.bytesTransferred.toDouble() /
                                    event.snapshot.totalByteCount.toDouble());
                            print("THe percentage " + percentage.toString());
                          });

                          StorageTaskSnapshot storageTaskSnapshot =
                              await storageUploadTask.onComplete;
                          var downloadUrl1 =
                              await storageTaskSnapshot.ref.getDownloadURL();
                          print("Download URL " + downloadUrl1.toString());
                          return downloadUrl1.toString();
                        } else {
                          //Catch any cases here that might come up like canceled, interrupted
                        }
                      }

                      //get url of thumnail
                      getUrl() async {
                        // ignore: avoid_init_to_null
                        String url = null;
                        StorageReference ref = FirebaseStorage.instance
                            .ref()
                            .child(
                                "product_pics/$prod_Id/images/img0_512x512.jpg");
                        await Future.delayed(const Duration(seconds: 2), () {});
                        try {
                          await ref
                              .getDownloadURL()
                              .then((value) => {url = value.toString()})
                              .catchError((error) async => {
                                    await Future.delayed(
                                        const Duration(seconds: 2), () {}),
                                    await ref
                                        .getDownloadURL()
                                        .then(
                                            (value) => {url = value.toString()})
                                        .catchError((error) async => {
                                              await Future.delayed(
                                                  const Duration(seconds: 5),
                                                  () {}),
                                              url = (await ref.getDownloadURL())
                                                  .toString()
                                            })
                                  });
                        } on Exception catch (_) {
                          print('never reached');
                        }

                        return url;
                      }

                      if (data.saveAndValidate()) {
                        await pr.show();
                        for (var i = 0; i < _images.length; i++) {
                          await addImageToFirebase(i, _images[i]);
                        }
                        imgurl = await getUrl();
                        print(_fbKey.currentState.value);
                        await Firestore.instance
                            .collection('products')
                            .document("$prod_Id")
                            .setData({
                          "title":
                              data.fields['product_name'].currentState.value,
                          "cato": data.fields['category'].currentState.value,
                          "price": data.fields['price'].currentState.value,
                          "s_price":
                              data.fields['sales_price'].currentState.value,
                          "image": imgurl,
                          "s_dis": data.fields['S_dis'].currentState.value,
                          "f_dis": data.fields['F_dis'].currentState.value,
                          "color": data.fields['color'].currentState.value,
                          "del_vech": data
                              .fields['delivery_vehicle'].currentState.value,
                        });
                        await pr.hide();
                        Navigator.pop(context);
                      } else {
                        print('validation failed');
                        // Firestore.instance
                        //     .collection('products')
                        //     .document("there")
                        //     .setData({
                        //   "prod_n":
                        //       data.fields['product_name'].currentState.value,
                        //   "cato": data.fields['category'].currentState.value,
                        //   "price": data.fields['price'].currentState.value,
                        //   "s_price":
                        //       data.fields['sales_price'].currentState.value,
                        //   "image": imgurl,
                        //   // "clr":data.fields['color_picker'].currentState.value,
                        // });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttributeDialog extends StatefulWidget {
  @override
  _AttributeDialogState createState() => new _AttributeDialogState();
}

class _AttributeDialogState extends State<AttributeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: _c,
        height: 20.0,
        width: 20.0,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Switch'),
            onPressed: () => setState(() {
                  _c == Colors.redAccent
                      ? _c = Colors.blueAccent
                      : _c = Colors.redAccent;
                }))
      ],
    );
  }
}
