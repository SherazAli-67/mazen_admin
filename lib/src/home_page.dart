import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazen_admin/src/hover_button.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _rows = [];
  final textController = TextEditingController();

  List<String> items = [
    'Skin Types',
    'Hair Styles',
    'Hair Types',
    'Nail Types',
  ];

  late String selectedType;
  late BuildContext dialogContext;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedType = items.first;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ic_logo.png', height: 100, fit: BoxFit.cover,),
                          const SizedBox(width: 20,),
                          const Text('Mazen Pharmacy', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),),
                        ],
                      ),
                      OutlinedButton(onPressed: ()=> generateExcel(), child:  const Text('Export Data'),),


                    ],
                  ),
                ),
                _buildColumns(size),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('CustomerData')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No Data Found'),);
                      }

                      List<Map<String, dynamic>> maps = snapshot.data!.docs.map((doc) => doc.data()).toList();
                      _rows = maps;
                      return Expanded(child: ListView.builder(
                          itemCount: maps.length,
                          itemBuilder: (ctx, index){
                            String fName = maps[index]['fName'];
                            String lName = maps[index]['lName'];
                            String country = maps[index]['country'];

                            String skinType = maps[index]['skinType'];
                            String hairType = maps[index]['hairType'];
                            String hairStyle = maps[index]['hairStyle'];

                            String nailType =  maps[index]['nailType'];
                            String ageGroup =  maps[index]['ageGroup'];
                            String sideEffects =  maps[index]['sideEffects'];

                            String favBrand =  maps[index]['brand'];
                            String isPregnant =  maps[index]['isPregnant'];
                            String isBreastFeeding =  maps[index]['isBreastFeeding'];

                            String contactNum =  maps[index]['contactNum'];
                            String budget =  maps[index]['Budget'];
                            // String gender =  maps[index]['gender'];
                            // String medicalConditions =  maps[index]['medicalConditions'];

                            return HoverButtonWidget(child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,

                              ),
                              onPressed: () {  },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                // decoration: BoxDecoration(
                                //     color: index%2 == 0 ? Colors.black12 : Colors.white
                                // ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                                        children: [
                                          _buildHeaderRowItem(fName, size ),
                                          _buildHeaderRowItem(lName, size),
                                          _buildHeaderRowItem(country, size),
                                          _buildHeaderRowItem(skinType, size),
                                          _buildHeaderRowItem(hairStyle, size),
                                          _buildHeaderRowItem(hairType, size),
                                          _buildHeaderRowItem(nailType, size),
                                          _buildHeaderRowItem(ageGroup, size),
                                          _buildHeaderRowItem(sideEffects, size),
                                          _buildHeaderRowItem(favBrand, size),
                                          _buildHeaderRowItem(isPregnant, size),
                                          _buildHeaderRowItem(isBreastFeeding, size),
                                          _buildHeaderRowItem(budget, size),
                                          _buildHeaderRowItem(contactNum, size),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ));
                          }));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
            isLoading ? const Center(child: CircularProgressIndicator(color: Colors.purple,),): const SizedBox(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: ()=> showAddItemDialog(size), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), child: const Icon(Icons.add),)
    );
  }

  Widget _buildColumns(Size size) {
    return Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5),
               color: const Color(0xff06b084),
             ),
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  children: [
                    _buildHeaderRowItem('First Name', size, isColumn: true),
                    _buildHeaderRowItem('Last Name', size, isColumn: true),
                    _buildHeaderRowItem('Country', size, isColumn: true),
                    _buildHeaderRowItem('Skin Type', size, isColumn: true),
                    _buildHeaderRowItem('Hair Style', size, isColumn: true),
                    _buildHeaderRowItem('Hair Type', size, isColumn: true),
                    _buildHeaderRowItem('Nail Type', size, isColumn: true),
                    _buildHeaderRowItem('Age Group', size, isColumn: true),
                    _buildHeaderRowItem('Side Effects/Allergies', size, isColumn: true),
                    _buildHeaderRowItem('Favorite Brand', size, isColumn: true),
                    _buildHeaderRowItem('Pregnant', size, isColumn: true),
                    _buildHeaderRowItem('Breast Feeding', size, isColumn: true),
                    _buildHeaderRowItem('Budget', size, isColumn: true),
                    _buildHeaderRowItem('Contact Number', size, isColumn: true),
                  ],
                ),
              ),
        );
  }

  Widget _buildHeaderRowItem(String title, Size size, {bool isColumn = false}){
    return SizedBox(
      child: Row(
        children: [
          SizedBox(
              width: size.width*0.1,
              child: Text(
                title,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: isColumn
                    ? const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)
                    : const TextStyle(fontSize: 16, color: Colors.black),
              )),
        ],
      ),
    );
  }

  void generateExcel(){

    final excel.Workbook workbook = excel.Workbook(0);
    final excel.Worksheet sheet = workbook.worksheets.addWithName('Table');

    sheet.getRangeByName('A1').setText('FirstName');
    sheet.getRangeByName('B1').setText('LastName');
    sheet.getRangeByName('C1').setText('Country');
    sheet.getRangeByName('D1').setText('Age Group');

    sheet.getRangeByName('E1').setText('SkinType');
    sheet.getRangeByName('F1').setText('HairType');
    sheet.getRangeByName('G1').setText('HairStyle');

    sheet.getRangeByName('H1').setText('NailType');
    sheet.getRangeByName('I1').setText('SideEffects/Allergies');
    sheet.getRangeByName('J1').setText('MedicalConditions');

    sheet.getRangeByName('K1').setText('FavouriteBrand');
    sheet.getRangeByName('L1').setText('Pregnant');
    sheet.getRangeByName('M1').setText('BreastFeeding');

    sheet.getRangeByName('N1').setText('Gender');
    sheet.getRangeByName('o1').setText('Contact');
    sheet.getRangeByName('p1').setText('Budget');


    List<String> alphaBets = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
    ];

    for(int row =0;row<_rows.length;row++){
      String fName = _rows[row]['fName'];
      String lName = _rows[row]['lName'];
      String country = _rows[row]['country'];

      String skinType = _rows[row]['skinType'];
      String hairType = _rows[row]['hairType'];
      String hairStyle = _rows[row]['hairStyle'];

      String nailType =  _rows[row]['nailType'];
      String ageGroup =  _rows[row]['ageGroup'];
      String sideEffects =  _rows[row]['sideEffects'];

      String favBrand =  _rows[row]['brand'];
      String isPregnant = _rows[row]['isPregnant'];
      String isBreastFeeding =  _rows[row]['isBreastFeeding'];

      String contactNum =  _rows[row]['contactNum'];
      String budget =  _rows[row]['Budget'];

      String gender =  _rows[row]['gender'];
      String medicalConditions =  _rows[row]['medicalConditions'];

      List<String> values = [
        fName,
        lName,
        country,
        ageGroup,
        skinType,
        hairType,
        hairStyle,
        nailType,
        sideEffects,
        medicalConditions,
        favBrand,
        isPregnant,
        isBreastFeeding,
        gender,
        contactNum,
        budget
      ];
      for(int alphabet=0;alphabet<alphaBets.length;alphabet++){
        sheet.getRangeByName('${alphaBets[alphabet]}${row+2}').setText(values[alphabet]);
      }
    }
    final excel.ExcelTable table = sheet.tableCollection.create('Table1', sheet.getRangeByName('A2:N4'));
    table.builtInTableStyle = excel.ExcelTableBuiltInStyle.tableStyleMedium9;
    sheet.getRangeByName('A2:N4').autoFitColumns();
    final List<int> bytes = workbook.saveSync();
    workbook.dispose();
    AnchorElement(
        href:
        'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'Output.xlsx')
      ..click();

  }

  void showAddItemDialog(Size size){
    showDialog(
        context: context,
        builder: (context){
          dialogContext = context;
          return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: const Text('Add Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: size.width*0.3,
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter List Item',
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  DropdownButton(
                    // Initial Value
                    value: selectedType,
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  OutlinedButton(onPressed: ()=> onAddItemClick(), style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  ), child: const Text('Add Item', style: TextStyle(fontSize: 18),))
                ],
              )
          );
        }
    );
  }

  void onAddItemClick(){
    String itemTitle = textController.text.trim();
    if(itemTitle.isNotEmpty){
      // Utility.showLoaderDialog(context);

      _updateLoading(true);
      Map<String, String> map = {DateTime.now().millisecond.toString(): itemTitle};
      try{
        FirebaseFirestore.instance.collection(selectedType).add(map).then((value){
          _updateLoading(false);
          Navigator.of(dialogContext).pop();
          textController.clear();
          selectedType = items.first;
        }).onError((error, stackTrace) {
          _updateLoading(true);
          // Navigator.of(context).pop();
          debugPrint('Error while adding: ${error.toString()}');
        });
        return;
      }catch(e){
        _updateLoading(true);
        // Navigator.of(context).pop();
        debugPrint('Exception while adding: ${e.toString()}');
      }
    }else{

    }
  }

  void _updateLoading(bool value){
    setState(() {
      isLoading = value;
    });
  }
}