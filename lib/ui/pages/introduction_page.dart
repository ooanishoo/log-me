import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:undraw/undraw.dart';

class IntroductionPage extends StatelessWidget {
  List<String> pageOneList = [
    "Track your workouts",
    "Create workout routines",
    "Build workout plans",
    "Smash your PR"
  ];
  final VoidCallback onSkip;
  final VoidCallback onDone;

  IntroductionPage({Key key, this.onSkip, this.onDone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      onDone: () {
        HapticFeedback.mediumImpact();
        onDone();
      },
      onSkip: () {
        HapticFeedback.mediumImpact();
        onSkip();
      }, 
      onChange: (index) {
        HapticFeedback.lightImpact();
      },
     
      showSkipButton: true,
      skip: Text('Skip'),
      showNextButton: true,
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.green,
          color: Colors.grey,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
      pages: [
        PageViewModel(
          image: UnDraw(
            color: Theme.of(context).accentColor,
            illustration: UnDrawIllustration.working_out,
          ),
          title: "Welcome to Log Me",
          bodyWidget: Column(children: [
            ...pageOneList.map((list) => CheckboxListTile(
                  title: Text(
                    list,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  value: true,
                  activeColor: Theme.of(context).accentColor,
                  checkColor: Theme.of(context).primaryColor,
                  onChanged: (newValue) {},
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ))
          ]),
          decoration: const PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              descriptionPadding: EdgeInsets.only(top: 6),
              bodyTextStyle:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
              imagePadding: EdgeInsets.fromLTRB(16, 150, 16, 16)),
        ),
        PageViewModel(
          image: UnDraw(
            color: Theme.of(context).accentColor,
            illustration: UnDrawIllustration.fitness_tracker,
          ),
          title: "Track your workouts",
          body: "Log your daily workouts to stay on track",
          decoration: _styles()),
        PageViewModel(
          image: UnDraw(
            color: Theme.of(context).accentColor,
            illustration: UnDrawIllustration.healthy_habit,
          ),
          title: "Create workout routines ",
          body:
              "Save your favourite wokout routines, \nready to go for next sessions",
          decoration: _styles()),
        PageViewModel(
          image: UnDraw(
            color: Theme.of(context).accentColor,
            illustration: UnDrawIllustration.finish_line_katerina_limpitsouni,
          ),
          title: "Build workout plans",
          body: "Plan ahead, stay organized and smash your PRs!",
          decoration: _styles(),
          footer: RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              HapticFeedback.mediumImpact();
              onDone();
            },
            child: const Text("Let's Go !"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ],
    ));
  }

  PageDecoration _styles() {
    return PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20.0),
        descriptionPadding: EdgeInsets.all(16),
        imagePadding: EdgeInsets.fromLTRB(16, 150, 16, 16));
  }
}
