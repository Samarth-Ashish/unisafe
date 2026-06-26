//stories.dart

import 'package:flutter/material.dart';

class StoriesPage extends StatelessWidget {
  final List<String> _storyTitles = [
    'Standing Up to Bullying',
    'Overcoming Cyberbullying',
    'Defending a Friend',
    'Finding Support in School',
    'Taking Action Against Bullying',
    'Empowering the Community',
    'Promoting Kindness and Inclusivity',
  ];

  final List<String> _storySummaries = [
    'A student witnesses a classmate being bullied and takes a stand against it, leading to an anti-bullying campaign in the school. They organize assemblies, workshops, and peer support groups to raise awareness and create a safe environment for all students.',
    'A teenager faces cyberbullying on social media platforms and struggles with feelings of isolation and anxiety. With the help of supportive friends and family members, they seek counseling and learn coping strategies to deal with online harassment. Through advocacy and education, they empower others to recognize and respond to cyberbullying.',
    'When a friend becomes the target of bullying, another student intervenes and confronts the bully, offering support and encouragement to their friend. Together, they report the incident to school authorities and implement a buddy system to ensure no student feels alone or vulnerable.',
    'In a school where bullying is prevalent, a group of students form an anti-bullying club to provide support and resources to victims. They collaborate with teachers and administrators to implement policies and programs that promote kindness, respect, and inclusivity. Through peer mentoring and awareness campaigns, they create a culture of empathy and understanding.',
    'Concerned citizens mobilize to address bullying in their community by organizing town hall meetings, workshops, and awareness campaigns. They collaborate with local schools, law enforcement agencies, and community organizations to implement anti-bullying initiatives and support services. By working together, they create a safer and more compassionate community for all.',
    'Empowered by their own experiences, survivors of bullying share their stories to raise awareness and inspire change. They advocate for anti-bullying legislation, mental health resources, and educational programs in schools and communities. Through public speaking engagements and media outreach, they challenge stereotypes and promote empathy and acceptance.',
    'Educators, parents, and students come together to promote kindness, inclusivity, and positive social behaviors in schools and neighborhoods. They organize events, workshops, and service projects to foster empathy, respect, and understanding among individuals of all ages. By modeling kindness and embracing diversity, they create environments where bullying is not tolerated and everyone feels valued and supported.',
  ];

  final List<String> _storyContents = [
    'One day, a student witnessed a classmate being bullied in the hallway. Instead of staying silent, they stepped in and confronted the bully. Together with other students, they reported the incident to a teacher and organized an anti-bullying campaign in their school. This campaign raised awareness about the harmful effects of bullying and promoted kindness and empathy among students. They organized assemblies, workshops, and peer support groups to raise awareness and create a safe environment for all students.',
    'A teenager faced cyberbullying on social media platforms, where hurtful messages and rumors were spread about them. They sought help from trusted adults, who provided guidance on how to block the bullies and report the harassment to the platform administrators. By taking action and reaching out for support, the teenager was able to overcome the cyberbullying and regain their confidence. They also used their experience to raise awareness about online safety and promote positive digital citizenship among their peers. With the help of supportive friends and family members, they seek counseling and learn coping strategies to deal with online harassment. Through advocacy and education, they empower others to recognize and respond to cyberbullying.',
    'When a friend became the target of bullying, another student stood by their side and offered support. They encouraged their friend to speak up about the bullying and accompanied them to report the incidents to school authorities. Together, they formed a strong bond and empowered each other to stand against bullying. Their friendship and solidarity sent a powerful message to the bullies and helped create a safer and more inclusive school environment.',
    'In a school where bullying was prevalent, a group of students decided to create a safe space for victims of bullying. They organized support groups and awareness campaigns to promote kindness and inclusivity. Through their efforts, they fostered a positive environment where students felt empowered to speak out against bullying. The support groups provided victims with a sense of community and validation, while the awareness campaigns helped educate their peers about the importance of empathy and respect.',
    'After witnessing repeated acts of bullying in their community, a group of concerned citizens decided to take action. They organized community meetings, reached out to local authorities, and advocated for anti-bullying policies and programs. Their collective efforts led to positive changes in the community and raised awareness about the importance of combating bullying. By speaking out against bullying and standing up for their neighbors, they helped create a safer and more inclusive environment for everyone.',
    'Empowered by their own experiences, survivors of bullying share their stories to raise awareness and inspire change. They advocate for anti-bullying legislation, mental health resources, and educational programs in schools and communities. Through public speaking engagements and media outreach, they challenge stereotypes and promote empathy and acceptance. They organize events, workshops, and service projects to foster empathy, respect, and understanding among individuals of all ages. By modeling kindness and embracing diversity, they create environments where bullying is not tolerated and everyone feels valued and supported.',
    'Educators, parents, and students come together to promote kindness, inclusivity, and positive social behaviors in schools and neighborhoods. They organize events, workshops, and service projects to foster empathy, respect, and understanding among individuals of all ages. By modeling kindness and embracing diversity, they create environments where bullying is not tolerated and everyone feels valued and supported. They organize events, workshops, and service projects to foster empathy, respect, and understanding among individuals of all ages. By modeling kindness and embracing diversity, they create environments where bullying is not tolerated and everyone feels valued and supported.',
  ];

  final List<String> _storyImages = [
    'https://www.ixionholdings.com/wp-content/uploads/2020/11/shutterstock_108383702.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_Hlqtyn4KA8TEsSHvVH1BPDPwM1uHv4vw1U4Yyi5V2A&s',
    'https://www.familyeducation.com/sites/default/files/2017-08/BULLY%20FI_0.jpg',
    'https://static3.bigstockphoto.com/4/1/1/large1500/114145952.jpg',
    'https://t3.ftcdn.net/jpg/03/86/24/58/360_F_386245844_vX3X1W35dfbFFmzyCCwfTw8ILj1TVJoG.jpg',
    'https://www.universityofcalifornia.edu/sites/default/files/styles/article_default_banner/public/fin-bullying.jpg?h=9720b116&itok=YTBFo-MI',
    'https://compote.slate.com/images/0524f5f9-2bcb-47e8-85f4-103e21cec7ca.jpg',
  ];

  StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange.withValues(alpha: 0.7),
        title: const Text('Bully Combat Stories'),
      ),
      body: ListView.builder(
        itemCount: _storyTitles.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 6, // Elevation for card shadow
            shadowColor: Colors.grey.shade700,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(_storyImages[index])),
              title: Text(_storyTitles[index]),
              subtitle: Text(_storySummaries[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StoryDetailPage(title: _storyTitles[index], content: _storyContents[index], imageUrl: _storyImages[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class StoryDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;

  const StoryDetailPage({super.key, required this.title, required this.content, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, backgroundColor: Colors.deepOrange.withValues(alpha: 0.7), title: Text(title)),
      body: Container(
        // color: Colors.grey[400], // Set your desired background color here
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(imageUrl, width: MediaQuery.of(context).size.width, height: 200, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(content, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
