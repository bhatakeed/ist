import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paint/StudentLogin/student_dashboard_weview.dart';
import 'package:local_auth_android/local_auth_android.dart';
import '../constant.dart';
import '../shared_prefference_app.dart';
import 'lock.dart';

class StudentDashboard extends StatefulWidget {
  dynamic name;
  final dynamic regLink;
  StudentDashboard(this.name,this.regLink, {Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final Lock lock = Lock();
  final SharedPrefData sp = SharedPrefData();
  late bool isLocked = false;
  bool openBottomSheet = false;
  bool popUpLock = false;
  bool validLogin = true;
  String exceptionMessage = "Invalid Login";
  final LocalAuthentication auth = LocalAuthentication();

  late List acd = [
    {'image': 'reg.png', 'text': 'Registration','url': 'https://studentservice.iust.ac.in/Services/${widget.regLink}'},
    {'image': 'registered.png', 'text': 'Registered Courses','url':'https://studentservice.iust.ac.in/Services/RegistrationDetails.aspx'},
    {'image': 're-registration.png', 'text': 'Re-Registered','url':'https://studentservice.iust.ac.in/Services/ReRegistration.aspx'}
  ];

  List dept = [
    {'image': 'attendance.png', 'text': 'Attendance','url':'https://studentservice.iust.ac.in/Services/Atnd_ViewMonthlyAttendance.aspx'},
  ];

  List lp = [
    {'image': 'video-camera.png', 'text': 'E-Content','url':'https://iust.ac.in/Index/E-Contents.aspx'},
    {'image': 'tick.png', 'text': 'Acknowledge Lectures','url':'https://studentservice.iust.ac.in/Services/ls-acknowledge-lecture-plan.aspx'},
    {'image': 'report.png', 'text': '  View','url':'https://studentservice.iust.ac.in/Services/ls-view-lecture-plan.aspx'},
  ];

  List transport = [
    {'image': 'bus.png', 'text': 'Apply','url':'https://studentservice.iust.ac.in/Services/TransportApplication.aspx'},
    {'image': 'cancelled.png', 'text': 'Cancel','url':'https://studentservice.iust.ac.in/Services/TransportCancelForm.aspx'},
    {'image': 'shuffle.png', 'text': 'Route Change','url':'https://studentservice.iust.ac.in/Services/TransportRouteChangeForm.aspx'},
    {'image': 'handshake.png', 'text': 'Consent','url':'https://studentservice.iust.ac.in/Services/TransportConsentForm.aspx'},
  ];

  List hostel = [
    {'image': 'hostel.png', 'text': 'Apply','url':'https://studentservice.iust.ac.in/Services/HostelApplicationForm.aspx'},
    {'image': 'cancelled.png', 'text': 'Cancel','url':'https://studentservice.iust.ac.in/Services/HostelCancelForm.aspx'},
    {'image': 'handshake.png', 'text': 'Consent','url':'https://studentservice.iust.ac.in/Services/HostelConsentform.aspx'},
  ];

  List payments = [
    {'image': 'payment.png', 'text': 'Pending','url':'https://studentservice.iust.ac.in/Services/AccountDetails.aspx'},
    {'image': 'receipt.png', 'text': 'Receipts','url':'https://studentservice.iust.ac.in/Services/Receipt.aspx'},
    {'image': 'pay.png', 'text': 'Pay','url':'https://studentservice.iust.ac.in/Services/Receipt.aspx'},
  ];


  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getLock();
    isDeviceSupportLock();
    showLockPopUp();
  }

  void getLock() async {
    isLocked = await sp.getLock();
    isLocked == true ? showLockInterface():null;
    setState((){});
  }

  Future<void> showLockInterface() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to login your account',
          options: const AuthenticationOptions(useErrorDialogs: false),
          authMessages: const [
            AndroidAuthMessages(
              signInTitle: 'IUST Student Login authentication',
              cancelButton: 'No thanks',
            ),
          ]
      );
      validLogin = didAuthenticate;
      setState(() {});
    }on PlatformException catch(e){
      exceptionMessage=e.message!;
      validLogin = false;
      setState((){});
    }
  }

  void isDeviceSupportLock() async {
    openBottomSheet = (await lock.checkBiometrics() && await sp.getPopUpLockMsg());
    setState(() {});
  }


  void showLockPopUp() async {
    popUpLock = await sp.getPopUpLockMsg();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.dashboard),
        title: const Text("Student Dashboard"),
        automaticallyImplyLeading: false,
        flexibleSpace: Constant.KFlexibleSpaceBar,
        actions: [
          Container(
            margin:const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              onPressed: () {
                (validLogin == true && popUpLock == false && openBottomSheet == false) ? openBottomSheet = true : openBottomSheet = false;
                setState((){});
              },
              icon: const Icon(Icons.lock,color:Colors.black,size: 17.0,),
            ),
          )
        ],
      ),
      bottomSheet: openBottomSheet == true?buildBottomSheetLock():null,
      body: validLogin == true ? SingleChildScrollView(
        child: Column(
          children: [
            cardWithContents('Academic', acd),
            cardWithContents('Payments', payments),
            cardWithContents('Lecture Plan', lp),
            cardWithContents('Hostel', hostel),
            cardWithContents('Transport', transport),
            cardWithContents('Department', dept),
          ],
        ),
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(exceptionMessage,textAlign: TextAlign.justify,),),
          ),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("Try Again!")),
        ],
      ),
    );
  }
  Widget buildBottomSheetLock(){
    sp.setPopUpLockMsg(false);
    return SizedBox(
      height: 200,
      child: Card(
        elevation: 1.0,
        color: Colors.lightBlueAccent.withOpacity(0.1),
        shadowColor: Colors.lightBlueAccent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    openBottomSheet == true ? openBottomSheet = false : openBottomSheet = true;
                    setState((){});
                  },
                  child: const Text("Close"),
                ),
              ),
              const SizedBox(height: 20,),
              Text("Your Device support biometric lock. Enable the biometric lock on your student login",textAlign: TextAlign.center,style: GoogleFonts.kanit(),),
              const SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Disable",style: Constant.KTitleStyle,),
                  Switch(
                    value: isLocked,
                    onChanged: (value) async {
                      setState((){
                        isLocked = value;
                      });
                      await sp.setLock(value);
                    },
                    activeTrackColor:  Constant.KSwitchColor,
                    activeColor: Constant.KSwitchColor,
                  ),
                  const Text("Enable",style: Constant.KTitleStyle,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class cardWithContents extends StatelessWidget {
  dynamic title;
  List list = [];
  cardWithContents(this.title, this.list, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: SizedBox(
        height: 150,
        child: Card(
          elevation: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset('assets/images/iust_reibonn.png', width: 90,),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      title,
                      style: GoogleFonts.adventPro(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: list.map((e) => Column(
                  children: [
                Container(
                padding: const EdgeInsets.all(5),
                child:  GestureDetector(child: Image.asset('assets/images/'+e['image'], width: 30,),onTap: (){
                  Navigator.push(context, PageTransition(child: StudentLoginWebview(e['url']), type: PageTransitionType.bottomToTop));
                },),
                ),
                    FittedBox(
                      child: Text(
                        e['text'].toString(),
                        style: GoogleFonts.kanit(),
                      ),
                    )
                  ],
                )).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

}



