import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:chat/widgets/input_area.dart';
import 'package:chat/widgets/message_list.dart';
import 'package:chat/models/message.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Storybook(
    initialStory: 'Screens/Scaffold',
    stories: [
      Story(
        name: 'Widgets/Input',
        description: 'Input area widget.',
        builder: (context) => Center(child: InputArea(
          onPressed: () {},
          controller: TextEditingController(
            text: context.knobs.text(
              label: 'Message',
              initial: 'Placeholder',
              description: 'Message example.',
            ),
          ),
        )),
      ),
      Story(
        name: 'Widgets/Messages',
        description: 'Message list widget.',
        builder: (context) {
          return Center(
            child: MessageList(
            messageList: List.generate(
                context.knobs.sliderInt(
                  label: 'Items count',
                  initial: 2,
                  min: 1,
                  max: 5,
                  description: 'Number of items in the body container.',
                ),
                (_) => Message(
                    userId: "111122223333",
                    timestamp: DateTime.now().microsecondsSinceEpoch.toString(),
                    text: context.knobs.text(
                      label: 'Message',
                      initial: 'Hello',
                      description: 'Message example.',
                    )
                )
            ))
          );
        },
      ),
    ],
  );
}