// adapted from tutorial get to know flutter

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'guest_book.dart';
import '../../widgets.dart';
import 'yes_no_selection.dart';

class QAndA extends StatelessWidget {
  const QAndA({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appState.attendees >= 2)
              Paragraph('${appState.attendees} people going')
            else if (appState.attendees == 1)
              const Paragraph('1 person going')
            else
              const Paragraph('No one going'),
            if (appState.loggedIn) ...[
              YesNoSelection(
                state: appState.attending,
                onSelection: (attending) => appState.attending = attending,
              ),
              const Header('Discussion'),
              GuestBook(
                addMessage: (message) =>
                    appState.addMessageToGuestBook(message),
                messages: appState.guestBookMessages,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
