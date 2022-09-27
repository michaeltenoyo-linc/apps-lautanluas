import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltl_bulk/Models/truck.dart';
import 'package:ltl_bulk/Screens/Global/widgets/input-number.dart';
import 'package:ltl_bulk/Screens/Global/widgets/input-time.dart';
import 'package:ltl_bulk/Screens/Global/widgets/input-warehouse-typeahead.dart';
import 'package:ltl_bulk/Screens/Global/widgets/widgets.dart';
import 'package:ltl_bulk/Screens/Auth/widgets/welcome-background.dart';
import 'package:ltl_bulk/Shared/colors.dart';
import 'package:ltl_bulk/Shared/fonts.dart';
import 'package:intl/intl.dart';

class CreateLoad extends StatefulWidget {
  const CreateLoad({super.key});

  @override
  State<CreateLoad> createState() => _CreateLoadState();
}

class _CreateLoadState extends State<CreateLoad> {
  int currentStep = 0;
  bool isCompleted = false;

  //Form Editing Controller
  final carrier = TextEditingController();
  final date = TextEditingController();
  final entryTime = TextEditingController();
  final exitTime = TextEditingController();
  final nopol = TextEditingController();
  final warehouse = TextEditingController();
  final weight_empty = TextEditingController();
  final weight_full = TextEditingController();
  final net_weight = TextEditingController();

  late DropdownKeyValue? shiftValue;
  late DropdownKeyValue? palkaValue;
  late DropdownKeyValue? grabberValue;
  late DropdownKeyValue? craneValue;

  final List<DropdownKeyValue> itemsShift = <DropdownKeyValue>[
    DropdownKeyValue('1', 'Shift 1 (08:00 - 16:00)'),
    DropdownKeyValue('2', 'Shift 2 (16:00 - 24:00)'),
    DropdownKeyValue('3', 'Shift 3 (00:00 - 08:00)'),
  ];

  final List<DropdownKeyValue> itemsPalka = <DropdownKeyValue>[
    DropdownKeyValue('1', 'Palka 1'),
    DropdownKeyValue('2', 'Palka 2'),
    DropdownKeyValue('3', 'Palka 3'),
    DropdownKeyValue('4', 'Palka 4'),
    DropdownKeyValue('5', 'Palka 5'),
  ];

  final List<DropdownKeyValue> itemsGrabber = <DropdownKeyValue>[
    DropdownKeyValue('ltl-ves 01', 'Grabber LTL (VES 01)'),
    DropdownKeyValue('ltl-ves 02', 'Grabber LTL (VES 02)'),
    DropdownKeyValue('ltl-ves 03', 'Grabber LTL (VES 03)'),
    DropdownKeyValue('ltl-tobu 1', 'Grabber LTL (TOBU 1)'),
    DropdownKeyValue('ltl-tobu 2', 'Grabber LTL (TOBU 2)'),
    DropdownKeyValue('ltl-tobu 3', 'Grabber LTL (TOBU 3)'),
    DropdownKeyValue('ltl-verstegen', 'Grabber LTL (VERSTEGEN)'),
    DropdownKeyValue('pbm', 'Grabber PBM'),
    DropdownKeyValue('other', 'Grabber Lainnya'),
  ];

  final List<DropdownKeyValue> itemsCrane = <DropdownKeyValue>[
    DropdownKeyValue('kapal', 'Crane Kapal'),
    DropdownKeyValue('glc', 'Crane GLC'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValue();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        WelcomeBackground(
          assetUrl: 'assets/images/backgrounds/load-create.png',
        ),
        SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                color: kLightColor,
                width: size.width * 0.6,
                height: size.height * 0.95,
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: kPrimaryColor,
                    title: Text(
                      'New Load',
                      style: kTextLight2Xl,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  body: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: kPrimaryColor,
                      ),
                    ),
                    child: Stepper(
                      steps: getSteps(),
                      type: StepperType.horizontal,
                      currentStep: currentStep,
                      onStepContinue: () {
                        final isLastStep = currentStep == getSteps().length - 1;
                        final isLastPage = currentStep == getSteps().length - 2;
                        if (isLastStep) {
                          setState(() {
                            //Set Status Done
                            isCompleted = true;

                            //Save Data

                            //Reset
                            resetState();
                          });
                        } else {
                          setState(() {
                            if (isLastPage)
                              exitTime.text =
                                  DateFormat('HH:mm:ss').format(DateTime.now());
                            currentStep += 1;
                          });
                        }
                      },
                      onStepTapped: (step) => setState(() {
                        currentStep = step;
                      }),
                      onStepCancel: currentStep == 0
                          ? null
                          : () => setState(() => currentStep -= 1),
                      controlsBuilder: (context, details) {
                        final isLastStep = currentStep == getSteps().length - 1;

                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: Text(isLastStep ? 'Confirm' : 'Next'),
                                  onPressed: details.onStepContinue,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              if (currentStep != 0)
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kColorsGrey200,
                                    ),
                                    child: Text(
                                      'Back',
                                      style: kTextDarkBase.copyWith(
                                          color: kColorsGrey600),
                                    ),
                                    onPressed: details.onStepCancel,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Entry'),
          content: Container(
            child: Column(children: [
              TextFormField(
                controller: carrier,
                decoration: InputDecoration(
                  labelText: 'Carrier Ship',
                  hintText: "Please input carrier's name",
                  icon: Icon(FontAwesomeIcons.ship),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InputDate(
                label: 'Entry Date',
                date: date,
                context: context,
                onChanged: (String value) {
                  setState(() {
                    date.text = value; //set output date to TextField value.
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              InputTime(
                  time: entryTime,
                  label: 'Entry Time',
                  context: context,
                  onChanged: (String value) {
                    setState(() {
                      entryTime.text =
                          value; //set output date to TextField value.
                    });
                  }),
              SizedBox(
                height: 20,
              ),
              InputDropdown(
                items: itemsShift,
                value: this.shiftValue,
                onChanged: (value) => setState(() {
                  this.shiftValue = value;
                }),
              ),
            ]),
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Truck'),
          content: Column(children: [
            InputTruckTypeAhead(nopol: nopol),
            SizedBox(
              height: 20,
            ),
            Focus(
              onFocusChange: (value) {
                onUpdateNetWeight();
              },
              child: InputNumber(
                controller: weight_empty,
                icon: Icon(FontAwesomeIcons.scaleBalanced),
                hintText: 'Please fill in when truck is empty',
                label: 'Empty Weight (KG)',
                inputAction: TextInputAction.next,
              ),
            ),
            Focus(
              onFocusChange: (value) {
                onUpdateNetWeight();
              },
              child: InputNumber(
                controller: weight_full,
                icon: Icon(FontAwesomeIcons.scaleBalanced),
                hintText: 'Please fill in when truck is full',
                label: 'Filled Weight (KG)',
                inputAction: TextInputAction.done,
              ),
            ),
            InputNumber(
              controller: net_weight,
              icon: Icon(FontAwesomeIcons.weightScale),
              inputAction: TextInputAction.next,
              label: 'Net Weight (KG)',
              readOnly: true,
            )
          ]),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('Tonnage'),
          content: Container(
            child: Column(
              children: [
                InputWarehouseTypeAhead(
                  name: warehouse,
                ),
                SizedBox(
                  height: 30,
                ),
                InputDropdown(
                  value: palkaValue,
                  items: itemsPalka,
                  onChanged: (value) => setState(() {
                    this.palkaValue = value;
                  }),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    childAspectRatio: 6,
                    mainAxisSpacing: 20,
                    shrinkWrap: true,
                    children: [
                      InputDropdown(
                        value: grabberValue,
                        items: itemsGrabber,
                        onChanged: (value) => setState(() {
                          this.grabberValue = value;
                        }),
                      ),
                      InputDropdown(
                        value: craneValue,
                        items: itemsCrane,
                        onChanged: (value) => setState(() {
                          this.craneValue = value;
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 3,
          title: Text('Out'),
          content: Container(
            child: Column(
              children: [
                InputTime(
                    time: exitTime,
                    label: 'Exit Time',
                    context: context,
                    onChanged: (String value) {
                      setState(() {
                        entryTime.text =
                            value; //set output date to TextField value.
                      });
                    }),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Data Overview',
                    style: kTextDarkBold2Xl,
                  ),
                ),
                Center(
                  child: DataTable(
                    columnSpacing: 250,
                    columns: [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text('Carrier', style: kTextDarkBoldBase)),
                          DataCell(
                            carrier.text != ''
                                ? Text(carrier.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Text('Entry Date', style: kTextDarkBoldBase)),
                          DataCell(
                            date.text != ''
                                ? Text(date.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Text('Entry Time', style: kTextDarkBoldBase)),
                          DataCell(
                            entryTime.text != ''
                                ? Text(entryTime.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Shift', style: kTextDarkBoldBase)),
                          DataCell(
                            Text(shiftValue!.key),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Truck', style: kTextDarkBoldBase)),
                          DataCell(
                            nopol.text != ''
                                ? Text(nopol.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Text('Empty Weight', style: kTextDarkBoldBase)),
                          DataCell(
                            weight_empty.text != '0'
                                ? Text(weight_empty.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Fulfilled Weight',
                              style: kTextDarkBoldBase)),
                          DataCell(
                            weight_full.text != '0'
                                ? Text(weight_full.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Text('Net Weight', style: kTextDarkBoldBase)),
                          DataCell(
                            net_weight.text != 'Undefined'
                                ? Text(net_weight.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Warehouse', style: kTextDarkBoldBase)),
                          DataCell(
                            warehouse.text != ''
                                ? Text(warehouse.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Palka', style: kTextDarkBoldBase)),
                          DataCell(Text(palkaValue!.key)),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Grabber', style: kTextDarkBoldBase)),
                          DataCell(Text(grabberValue!.key)),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text('Crane', style: kTextDarkBoldBase)),
                          DataCell(Text(craneValue!.key)),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(
                              Text('Entry Date', style: kTextDarkBoldBase)),
                          DataCell(
                            date.text != ''
                                ? Text(date.text)
                                : Text('UNDEFINED',
                                    style: TextStyle(color: kColorsRed500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ];

  void onUpdateNetWeight() {
    setState(() {
      net_weight.text =
          (int.parse(weight_full.text == '' ? '0' : weight_full.text) -
                  int.parse(weight_empty.text == '' ? '0' : weight_empty.text))
              .toString();
    });
  }

  void initValue() {
    //Form Init
    date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    entryTime.text = DateFormat('HH:mm:ss').format(DateTime.now());
    exitTime.text = DateFormat('HH:mm:ss').format(DateTime.now());
    //Init Shift and Time
    if (isCurrentTimeBetween(
        [TimeOfDay(hour: 8, minute: 0), TimeOfDay(hour: 15, minute: 59)])) {
      this.shiftValue = itemsShift[0];
    } else if (isCurrentTimeBetween(
        [TimeOfDay(hour: 16, minute: 0), TimeOfDay(hour: 23, minute: 59)])) {
      this.shiftValue = itemsShift[1];
    } else {
      this.shiftValue = itemsShift[2];
    }

    this.palkaValue = itemsPalka[0];
    this.grabberValue = itemsGrabber[0];
    this.craneValue = itemsCrane[0];

    this.net_weight.text = 'Undefined';
    this.weight_empty.text = '0';
    this.weight_full.text = '0';
  }

  void resetState() {
    setState(() {
      isCompleted = false;
      currentStep = 0;

      date.clear();
      entryTime.clear();
      nopol.clear();
      weight_empty.clear();
      weight_full.clear();
      net_weight.clear();
      initValue();
    });
  }
}
