// Copyright 2023 Jose Berengueres. All rights reserved.

import 'package:flutter/material.dart';

class ProjectStepper extends StatefulWidget {
  const ProjectStepper({super.key});

  @override
  State<ProjectStepper> createState() => _ProjectStepperState();
}

class _ProjectStepperState extends State<ProjectStepper> {
  int _index = 0;

  final int _maxStep = 6;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme:
              // ignore: prefer_const_constructors
              ColorScheme.light(
                  primary: Colors.blueAccent, secondary: Colors.green)),
      child: Stepper(
        currentStep: _index,
        margin: const EdgeInsetsDirectional.only(
          start: 60.0,
          end: 14.0,
          bottom: 0.0,
          top: 0.0,
        ),
        onStepCancel: () {
          if (_index > 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_index < (_maxStep)) {
            setState(() {
              _index += 1;
            });
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              OutlinedButton(
                onPressed: details.onStepCancel,
                child: const Text('BACK'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: details.onStepContinue,
                child: const Text('NEXT STEP'),
              ),
            ],
          );
        },
        steps: <Step>[
          /*
          Step(
            title: const Text(
              'Welcome',
              //style: TextStyle(color: Colors.blueAccent),
            ),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    'Welcome to your project. This checklist helps you setup your project, its use is optional. Think of a project as a folder that can hold consent forms, interviews and several maps in one place. ')),
          ),
          Step(
            title: const Text(
              'Set Title',
              //style: TextStyle(color: Colors.blueAccent),
            ),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text('[ Title your project  | SET ]')),
          ),
          
          */
          Step(
            title: const Text('Ethics set up'),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    '1. Upload [Set Project Information Statement.pdf] \n2. Upload [Participant Information Statement (PIS) as a PDF file]\n3. (Pre)Obtain consents from participants ')),
          ),
          Step(
            title: const Text('Additional docs'),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    'Click here to uplaod additional project documents)')),
          ),
          Step(
            title: const Text('Invite Link'),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text('[Anyone with this link can edit]')),
          ),
          Step(
            title: const Text('Interviewing & mapping'),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    '[new map] \n[new interview] \n[new participant obs.]')),
          ),
          Step(
            title: const Text('Post project tasks'),
            content: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                    '1. [Add reflection note] \n2. [Download all data]\n\n Advanced...\n[see settings]')),
          ),
        ],
      ),
    );
  }
}
