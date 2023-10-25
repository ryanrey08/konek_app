import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FileRequirements extends StatelessWidget {
  final String points;
  final String title;
  final String copy;

  FileRequirements({
    required this.points,
    required this.title,
    required this.copy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: Colors.blue[900]),
            children: <TextSpan>[
              TextSpan(
                  text: copy,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Text(points,
            style: TextStyle(
              fontSize: 12,
            )),
      ],
    ));
  }
}

class CustomFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function validator;
  final Function(String) onFieldSubmitted;
  final String initialValue;
  final bool status;

  CustomFormField(
      {required this.label,
      required this.controller,
      required this.validator,
      required this.onFieldSubmitted,
      required this.initialValue,
      required this.status});

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 900.0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: useMobileLayout ? 3 : 10),
      child: TextFormField(
        enabled: status,

        style: GoogleFonts.poppins(fontSize: useMobileLayout ? 16 : 18),
        // decoration: InputDecoration(
        //   border: OutlineInputBorder(),
        //   labelText: label,
        // ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          // OutlineInputBorder
          // UnderlineInputBorder
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
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
          labelText: label != "" ? label : null,
          labelStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: useMobileLayout ? 16 : 18,
              color: Colors.grey[400],
            ),
          ),
          helperStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        validator: (_) => validator(),
      ),
    );
  }
}

class StatementAccountListItem extends StatelessWidget {
  final String title;
  final String subtitle;

  StatementAccountListItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(color: Colors.black, fontSize: 13),
        children: <TextSpan>[
          TextSpan(
              text: subtitle,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class DrawerOptions extends StatelessWidget {
  DrawerOptions(
      {required this.dense,
      required this.title,
      required this.useMobileLayout,
      required this.iconData,
      required this.onTapFunc,
      required this.color});

  final bool dense;
  final String title;
  final bool useMobileLayout;
  final IconData iconData;
  final GestureTapCallback onTapFunc;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 900.0;
    return Container(
      child: ListTile(
        dense: dense,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: useMobileLayout ? 12 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          // style: SettingsStyle.listTileText(),
        ),
        leading:
            Icon(iconData, color: Color.fromARGB(255, 55, 57, 175), size: 20),
        trailing: Icon(Icons.keyboard_arrow_right, size: 15),
        onTap: onTapFunc,
      ),
    );
  }
}

class DragContainer extends StatelessWidget {
  final String label1;
  final String label2;
  final String location;

  DragContainer(
      {required this.label1, required this.label2, required this.location});

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 900.0;
    return Card(
      child: Container(
        height: 150,
        color: Colors.green[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                width: double.infinity,
                height: useMobileLayout ? 65 : 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(location),
                  ),
                ),
              ),
            ),
            Text(label2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: useMobileLayout ? 10 : 18, color: Colors.black)),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return Container(
      padding: EdgeInsets.only(top: 5),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          offset += 5;
          time = 800 + offset;
          return Shimmer.fromColors(
            child: ShimmerLayout(),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            period: Duration(milliseconds: time),
          );
        },
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final String? value;
  final List<dynamic> items;
  final String title;
  final String? Function(Object?) onChanged;
  final String? Function(Object?) validator;
  final bool status;

  const CustomDropDown(
      {Key? key,
      required this.value,
      required this.items,
      required this.title,
      required this.onChanged,
      required this.validator,
      required this.status})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField(
        value: widget.value,
        items: widget.items
            .map((text) => DropdownMenuItem(
                  child: Text('$text'),
                  value: text,
                ))
            .toList(),
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // OutlineInputBorder
          // UnderlineInputBorder
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: widget.value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: widget.value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: widget.value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: widget.value != null ? Colors.green : Colors.grey.shade400,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
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
          labelText: widget.value != null ? widget.title : null,
          labelStyle: widget.value != null
              ? GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : null,
          hintText: widget.value == null ? widget.title : null,
          hintStyle: widget.value == null
              ? GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        onChanged: widget.status ? widget.onChanged : null,
        validator: widget.validator,
      ),
    );
  }
}

class CustomDateTime extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final Function onSaved;
  final Function validator;
  final String labeltxtTitle;

  const CustomDateTime(
      {Key? key,
      required this.title,
      required this.controller,
      required this.focusNode,
      required this.onFieldSubmitted,
      required this.onSaved,
      required this.validator,
      required this.labeltxtTitle})
      : super(key: key);

  @override
  _CustomDateTimeState createState() => _CustomDateTimeState();
}

class _CustomDateTimeState extends State<CustomDateTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            backgroundColor: Colors.white,
          ),
        ),
        child: DateTimeField(
          controller: widget.controller,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          enabled: true,
          format: DateFormat("MMMM dd, yyyy"),
          // format: DateFormat("yyyy-MM-dd"),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              // lastDate: DateTime.now(),

              lastDate: DateTime(2050),
              // initialDatePickerMode: DatePickerMode.year
            ).then((pickedDate) {
              if (pickedDate == null) {
                return null;
              }
              setState(() {
                // final f = new DateFormat('yyyy-MM-dd');
                final f = new DateFormat('MMMM dd, yyyy');
                widget.controller.text = f.format(pickedDate).toString();
              });
              return pickedDate;
            });
          },
          focusNode: widget.focusNode,
          onFieldSubmitted: widget.onFieldSubmitted(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            // OutlineInputBorder
            // UnderlineInputBorder
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
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
            labelText: widget.labeltxtTitle,
            labelStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            helperStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          onSaved: widget.onSaved(),
          validator: widget.validator(),
          onChanged: (date) {
            print(date);
          },
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String title;
  final String helperText;
  final TextEditingController controller;
  final Function validator;
  final Function(String) onFieldSubmitted;
  final TextInputType keyboardtype;
  final List<TextInputFormatter> inputFormatters;

  const CustomTextField(
      {Key? key,
      required this.title,
      required this.helperText,
      required this.controller,
      required this.validator,
      required this.onFieldSubmitted,
      required this.keyboardtype,
      required this.inputFormatters})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              textCapitalization: TextCapitalization.words,
              controller: widget.controller,
              // inputFormatters: [
              //   UpperCaseTextFormatter(),
              // ],
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              enabled: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                // OutlineInputBorder
                // UnderlineInputBorder
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
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
                // labelText: widget.controller.text != "" ? widget.title : null,
                // labelStyle:  GoogleFonts.poppins(
                //         textStyle: TextStyle(
                //           fontSize: 16,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                hintText: widget.controller.text == "" ? widget.title : null,
                hintStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                helperText: widget.helperText,
                helperStyle: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              onFieldSubmitted: widget.onFieldSubmitted,
              validator: widget.validator(),
              // onChanged: (value) {
              //   if (widget.controller.text != value.toUpperCase())
              //     widget.controller.value = widget.controller.value
              //         .copyWith(text: value.toUpperCase());
              // },
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownCustom extends StatelessWidget {
  final String points;
  final String title;
  final String copy;

  DropDownCustom({
    required this.points,
    required this.title,
    required this.copy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: Colors.blue[900]),
            children: <TextSpan>[
              TextSpan(
                  text: copy,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Text(points,
            style: TextStyle(
              fontSize: 12,
            )),
      ],
    ));
  }
}

class ProductionCostList extends StatelessWidget {
  ProductionCostList(
      {required this.dense,
      required this.title,
      required this.useMobileLayout,
      required this.iconData,
      required this.onTapFunc,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.text4,
      required this.text5,
      required this.text6});

  final bool dense;
  final String title;
  final bool useMobileLayout;
  final IconData iconData;
  final GestureTapCallback onTapFunc;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 900.0;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: useMobileLayout
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2 - 25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'REF No.: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: text1,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Product: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: text2,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Area (Hectare): ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: text2,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Total Loan: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: text2,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Date: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: text2,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Request Status: ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: text2,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showError(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color(0xff404747),
    textColor: Colors.white,
    fontSize: 13.0,
  );
}

class ParticularDetails extends StatelessWidget {
  final String particularName;
  final String measurement;
  final String quantity;
  final String unit;
  final String amount;
  final Color color;

  ParticularDetails(
      {required this.particularName,
      required this.measurement,
      required this.quantity,
      required this.unit,
      required this.amount,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 900.0;

    var _selectedUnit;
    var _unitPrice = [400, 500, 600];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 40),
          width: useMobileLayout ? 250 : MediaQuery.of(context).size.width / 5,
          child: Text(
            particularName,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
          ),
        ),
        Container(
          width: useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
          child: Center(
              child: Text(
            measurement,
            style: TextStyle(
                color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
          )),
        ),
        Container(
          width: useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
          child: Center(
              child: Text(
            quantity,
            style: TextStyle(
                color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
          )),
        ),
        Container(
          width: useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
          child: Center(
              child: Text(
            unit,
            style: TextStyle(
                color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
          )),
        ),
        Container(
          width: useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
          child: Center(
              child: Text(
            amount,
            style: TextStyle(
                color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
          )),
        ),
      ],
    );
  }
}

class Production extends StatefulWidget {
  // final String title;
  // final String helperText;
  // final TextEditingController controller;
  // final Function validator;
  // final Function(String) onFieldSubmitted;
  // final TextInputType keyboardtype;
  // final List<TextInputFormatter> inputFormatters;

  final String title;
  final String measurement;
  final String quantity;
  final String selectedUnit;
  final List<DropdownMenuItem<dynamic>> items;
  final Function onChanged;
  final String amount;

  const Production(
      {Key? key,
      required this.title,
      required this.measurement,
      required this.quantity,
      required this.items,
      required this.onChanged,
      required this.selectedUnit,
      required this.amount})
      : super(key: key);

  @override
  _ProductionState createState() => _ProductionState();
}

class _ProductionState extends State<Production> {
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 40),
            width:
                useMobileLayout ? 250 : MediaQuery.of(context).size.width / 5,
            child: Text(
              widget.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
            ),
          ),
          Container(
            width:
                useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
            child: Center(
                child: Text(
              widget.measurement,
              style: TextStyle(
                  color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
            )),
          ),
          // Production(controller: quantityTextA),
          Container(
            width:
                useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
            child: Center(
                child: Text(
              widget.quantity,
              style: TextStyle(
                  color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
            )),
          ),
          Expanded(
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              items: widget.items,
              onChanged: widget.onChanged(),
              //     (newValue) {
              //   // do other stuff with _category

              //   setState(() {
              //     _selectedUnitIIA1 =
              //         newValue;
              //     _amountIIA1 = int.parse(
              //             _selectedUnitIIA1) *
              //         int.parse(
              //             quantityTextIIA1.text);

              //   });
              // },
              style: TextStyle(fontSize: useMobileLayout ? 16 : 18),
              value: widget.selectedUnit,
              onSaved: (value) {},
              validator: (value) {
                if (value == null) {
                  return 'Please select variety';
                }
                return null;
              },
            ),
          ),
          Container(
            width:
                useMobileLayout ? 150 : MediaQuery.of(context).size.width / 5,
            child: Center(
                child: Text(
              widget.amount,
              style: TextStyle(
                  color: Colors.black, fontSize: useMobileLayout ? 16 : 18),
            )),
          ),
        ],
      ),
    );
  }
}
