//login_page.dart
import 'package:flutter/material.dart';
import 'google_login_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  final ValueNotifier<UserCredential?> userCredential;
  const SignupPage({super.key, required this.userCredential});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: const Color.fromARGB(255, 255, 157, 104),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //       colors: [
          //         const Color.fromARGB(255, 255, 157, 104),
          //         const Color.fromARGB(255, 255, 140, 79),
          //       ],
          //       begin: const FractionalOffset(0.0, 0.0),
          //       end: const FractionalOffset(1.0, 0.0),
          //       stops: [0.0, 1.0],
          //       tileMode: TileMode.clamp),
          // ),
          //
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    // "Sign up",
                    "Welcome to UniSafe",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  //
                  //
                  //
                  ShaderMask(
                    shaderCallback: (rect) {
                      // Create a radial gradient for a more natural fading effect
                      return RadialGradient(
                        center: Alignment.center,
                        radius: 0.55, // Adjust radius for desired fade distance
                        colors: [
                          Colors.black.withValues(alpha: 0.8), // Adjust opacity for blur strength
                          Colors.transparent,
                        ],
                        stops: const [0.5, 1.0], // Evenly distribute color transitions
                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset('assets/images/unisafeLogo.jpg', height: 400, fit: BoxFit.contain),
                  ),
                  //
                  //
                  //
                ],
              ),
              const Column(
                children: <Widget>[
                  // TextField(
                  //   decoration: InputDecoration(
                  //       hintText: "Username",
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(18),
                  //           borderSide: BorderSide.none),
                  //       fillColor: Colors.purple.withOpacity(0.1),
                  //       filled: true,
                  //       prefixIcon: const Icon(Icons.person)),
                  // ),

                  // const SizedBox(height: 20),

                  // TextField(
                  //   decoration: InputDecoration(
                  //       hintText: "Email",
                  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  //       fillColor: Colors.purple.withOpacity(0.1),
                  //       filled: true,
                  //       prefixIcon: const Icon(Icons.email)),
                  // ),

                  // const SizedBox(height: 20),

                  // TextField(
                  //   decoration: InputDecoration(
                  //     hintText: "Password",
                  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  //     fillColor: Colors.purple.withOpacity(0.1),
                  //     filled: true,
                  //     prefixIcon: const Icon(Icons.password),
                  //   ),
                  //   obscureText: true,
                  // ),

                  // const SizedBox(height: 20),

                  // TextField(
                  //   decoration: InputDecoration(
                  //     hintText: "Confirm Password",
                  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  //     fillColor: Colors.purple.withOpacity(0.1),
                  //     filled: true,
                  //     prefixIcon: const Icon(Icons.password),
                  //   ),
                  //   obscureText: true,
                  // ),
                ],
              ),
              // Container(
              //   padding: const EdgeInsets.only(top: 3, left: 3),
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       shape: const StadiumBorder(),
              //       padding: const EdgeInsets.symmetric(vertical: 16),
              //       backgroundColor: Colors.purple,
              //     ),
              //     child: const Text(
              //       "Sign up",
              //       style: TextStyle(fontSize: 20, color: Colors.black),
              //     ),
              //   ),
              // ),
              // const Center(child: Text("Or")),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.purple),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () async {
                    // widget.userCredential.value = {'userCredential': await signInWithGoogle(), 'isAdmin': null};
                    // widget.userCredential.value['isAdmin'] =
                    //     await checkIfAdmin(widget.userCredential.value['userCredential'].user!.email);
                    // if (widget.userCredential.value != null) {
                    //   debugPrint(widget.userCredential.value['userCredential'].user!.email);
                    // }
                    final result = await signInWithGoogle();
                    if (result != null)
                      widget.userCredential.value =
                          result; // widget.isAdmin.value = await checkIfAdmin(widget.userCredential.value.user!.email);
                    if (widget.userCredential.value != null || widget.userCredential == ValueNotifier(null)) {
                      debugPrint("\n Logged In using \n\n ======= ${widget.userCredential.value?.user?.email ?? ''} \n============");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: const BoxDecoration(
                          // image: DecorationImage(image: AssetImage('assets/images/download.png'), fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                        // child: Image.network(
                        //   'http://pngimg.com/uploads/google/google_PNG19635.png',
                        //   fit: BoxFit.cover,
                        // ), //changed
                        child: Image.asset(
                          'assets/images/google.png',
                          // height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        "Sign In with Google",
                        style: TextStyle(fontSize: 16, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     const Text("Already have an account?"),
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pushNamed(context, '/signin');
              //         },
              //         child: const Text(
              //           "Login",
              //           style: TextStyle(color: Colors.purple),
              //         ))
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
