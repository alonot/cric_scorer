import '../exports.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final viewModel = MatchViewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool onSignInPage = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkForLogin();
  }

  void checkForLogin() async {
    setState(() {
      isLoading = true;
    });
    var result = await viewModel.getCurrentLogin();
    debugPrint("Current User : $result");
    if (result != null) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: result['email'].toString(),
            password: result['password'].toString());
        // If above line does not throw an error then login successfull
        currentUser = result['email'].toString();
        uuid = userCredential.user!.uid;
        Util.batterNames = viewModel.getPlayers().toList();
        Util.bowlerNames = viewModel.getPlayers().toList();
        playArenaIds = await viewModel
            .getAllArenaIds(
            userCredential.user!.uid);
        viewModel.haveLoggedIn();
        Navigator.pushNamed(context, Util.homePage);
      } catch (e) {
        debugPrint("Errorr : ${e}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();

  void signUp() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
          int result = await viewModel.uploadUser(
              emailController.text, userCredential.user!.uid);
        if (result == -1){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exists')));
          playArenaIds = [];
          return;
        }
        playArenaIds = await viewModel
            .getAllArenaIds(
            userCredential.user!.uid); // getting all the arenaIds
        await viewModel.setCurrentUser(
            emailController.text, passwordController.text);
        uuid = userCredential.user!.uid;
        currentUser = emailController.text;
        Util.batterNames = viewModel.getPlayers().toList();
        Util.bowlerNames = viewModel.getPlayers().toList();
        viewModel.haveLoggedIn();
        Navigator.pushNamedAndRemoveUntil(
            context, Util.homePage, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.code}")));
    }
    catch (e) {
      debugPrint("e::$e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to took you in.')));
    }
    setState(() {
      isLoading = false;
    });
  }

  void signIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      debugPrint("User: ${userCredential.user!.email}");
      if (userCredential.user != null) {
        Util.batterNames = viewModel.getPlayers().toList();
        Util.bowlerNames = viewModel.getPlayers().toList();
        playArenaIds = await viewModel
            .getAllArenaIds(
            userCredential.user!.uid); // getting all the arenaIds
        viewModel.setCurrentUser(emailController.text, passwordController.text);
        currentUser = emailController.text;
        uuid = userCredential.user!.uid;
        viewModel.haveLoggedIn();
        Navigator.pushNamedAndRemoveUntil(
            context, Util.homePage, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${e.code}")));
    }
    // catch (e) {
    //   debugPrint("e::$e");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Failed to took you in.')));
    // }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: null,
        image: DecorationImage(
            image: AssetImage('assests/background.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: const Color(0x89000000),
        key: const Key("signInOrUpScaffold"),
        body: isLoading
            ? Center(child: const CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(onSignInPage?"SignIn":"Register",style: TextStyle(color: Colors.white,fontSize: 20,height: 3),),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty||
                                    !RegExp(r"^[a-z0-9A-z_]+@([a-z0-9A-z_]+\.){1,}[a-z0-9A-z_]+$")
                                        .hasMatch(emailController.text))
                                {
                                  return "Please enter correct email";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Email")),
                              controller: emailController),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the password";
                                } else if (value.length <= 6) {
                                  return 'Password must be atleast 6 digit long';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Password")),
                              controller: passwordController),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (onSignInPage) {
                                  signIn();
                                } else {
                                  signUp();
                                }
                              }
                            },
                            child: Text(onSignInPage ? "Login" : "Register"),
                          ),
                          TextButton(
                            child: Text(
                              !onSignInPage
                                  ? "Already have an account? SignIn"
                                  : "Sign Up",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 11),
                            ),
                            onPressed: () {
                              onSignInPage = !onSignInPage;
                              setState(() {
                                emailController.text = "";
                                passwordController.text = "";
                              });
                            },
                          ),
                            TextButton(
                            child: Text(
                              "Guest Mode",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 11),
                            ),
                            onPressed: () {
                              viewModel.logout();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Util.homePage, (route) => false);
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
