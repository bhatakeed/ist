import 'package:flutter/material.dart';
import 'package:paint/constant.dart';
import 'package:paint/youtube_player.dart';

class AboutUniversity extends StatefulWidget {
  const AboutUniversity({Key? key}) : super(key: key);

  @override
  _AboutUniversityState createState() => _AboutUniversityState();
}

class _AboutUniversityState extends State<AboutUniversity> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Constant.KFlexibleSpaceBar,
          title: const Text("About"),
        ),
        body: Container(
          color: Constant.KbodyColor,
          padding: const EdgeInsets.all(10.5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 0.5, color: Constant.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Card(
                        elevation: 2.0,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "About University",
                            style: Constant.KTitleStyle.copyWith(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          child: const Text(
                            "The Islamic University of Science and Technology (IUST), Awantipora, J&K has been established through an Act No. XVIII of 2005 dated: 7th November 2005 passed by J&K State Legislature and notified by the State Government, through Jammu & Kashmir Government Gazette dated: 11-11-2005. While the university started functioning in November, 2005 the teaching programme was started in July 2006. The Chancellor of the University is the Chief Minister of J&K State and the executive authority of the University is its Executive Council with the Vice Chancellors of University of Jammu, University of Kashmir and Baba Ghulam Shah Badshah University as members. The University is accredited by NAAC with Grade ‘B’ and is recognized by University Grants Commission (UGC) under Section 2(f) and Section 12(b) of UGC Act. The Technical and nursing programmes offered by the University are approved by All India Council for Technical Education (AICTE) and Indian Nursing Council (INC). The University has the membership of Association of Indian Universities (AIU). The University came into existence with a mandate to advance and disseminate knowledge, wisdom and understanding amongst all segments of the society within and outside the State. It is also charged with creating an environment for learning, teaching and research in the sciences, technology, humanities and social sciences and that is in keeping with the highest standards of scholarship and higher education. People belonging to all sections of society are entitled to avail the facilities and opportunities offered by the University and there is no distinction on the basis of class, caste, creed, colour or religion",
                            style: Constant.KTitleStyle,
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 0.5, color: Constant.primaryColor),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Column(
                    children: [
                      Card(
                        elevation: 2.0,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "University Tarana",
                            style: Constant.KTitleStyle.copyWith(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Card(
                        child: YoutubePlayerApp(videoPlayerId: '5RZKgHRFmDU'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
