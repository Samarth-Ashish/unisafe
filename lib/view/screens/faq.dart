//faq.dart
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<String> _questions = [
    'What should I do if I witness bullying?',
    'How can I protect myself from cyberbullying?',
    'What should I do if I\'m being bullied?',
    'Who can I talk to if I need help?',
    'How can I support a friend who is being bullied?',
    'What are some signs that someone might be experiencing bullying?',
    'How can I raise awareness about bullying in my school?',
    'What should I do if I\'m accused of bullying?',
    'Where can I find resources for dealing with bullying?',
    'How can I contribute to creating a bully-free environment?',
  ];

  final List<String> _answers = [
    'If you witness bullying, it\'s important to speak up and report it to a trusted adult, such as a teacher, counselor, or parent. You can also support the person being bullied by offering them assistance and kindness.',
    'To protect yourself from cyberbullying, be cautious about what you share online and who you interact with. Avoid responding to hurtful messages and block or report any cyberbullies to the platform administrators.',
    'If you\'re being bullied, it\'s essential to reach out for help. Talk to a trusted adult, such as a teacher, counselor, or family member, and let them know what\'s happening. Remember that you\'re not alone, and there are people who can support you.',
    'You can talk to a teacher, school counselor, parent, or another trusted adult if you need help. They can provide guidance and support to address the bullying situation and ensure your safety and well-being.',
    'You can support a friend who is being bullied by listening to them, offering encouragement, and standing up for them when necessary. Encourage them to seek help from a trusted adult and let them know that they\'re not alone.',
    'Some signs that someone might be experiencing bullying include changes in behavior, withdrawal from social activities, unexplained injuries, and a decline in academic performance. It\'s essential to reach out and offer support if you notice any of these signs.',
    'You can raise awareness about bullying in your school by organizing events, such as assemblies, workshops, or awareness campaigns. You can also start or join a student-led anti-bullying club and collaborate with teachers and administrators to implement bullying prevention programs.',
    'If you\'re accused of bullying, it\'s important to take the accusation seriously and listen to the concerns raised. Reflect on your behavior and consider how it may have affected others. Apologize if necessary and commit to changing your actions to prevent further harm.',
    'There are many resources available for dealing with bullying, including hotlines, websites, and support groups. You can find information and support from organizations such as StopBullying.gov, the National Suicide Prevention Lifeline, and the Trevor Project.',
    'You can contribute to creating a bully-free environment by promoting kindness, respect, and empathy in your school and community. Stand up against bullying when you see it, support others who are being targeted, and be a positive role model for those around you.',
  ];

  FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withOpacity(0.7),
        title: const Text('FAQ'),
      ),
      body: Container(
        // color: Colors.grey[200], // Background color
        child: ListView.builder(
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 6, // Elevation for card shadow
              shadowColor: Colors.grey.shade700,
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16), // Margin around each card
              child: ExpansionTile(
                title: Text(
                  _questions[index],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _answers[index],
                      // style: TextStyle(color: Colors.black87), // Text color
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
