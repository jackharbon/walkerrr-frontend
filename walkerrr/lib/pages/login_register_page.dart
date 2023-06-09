import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walkerrr/auth.dart';
import 'package:walkerrr/services/user_data_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:walkerrr/common/styling_variables.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool isLogin = true; // Login/Register button text change
  bool isObscure = true; // Show/Hide password
  bool dontStore = false; // Secure Storage will not be updated

// ======== Secure Storage =========>

  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm =
      TextEditingController();

  final SecureStorage _secureStorage = SecureStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchSecureStorageData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchSecureStorageData() async {
    _controllerDisplayName.text = await _secureStorage.getDisplayName() ?? '';
    _controllerEmail.text = await _secureStorage.getEmail() ?? '';
    _controllerPassword.text = await _secureStorage.getPassword() ?? '';
  }
// <========

// ======== Login / Register auth =========>

  Future<void> signInWithEmailAndPassword() async {
    if (!dontStore) {
      await _secureStorage.setDisplayName(_controllerDisplayName.text);
      await _secureStorage.setEmail(_controllerEmail.text);
      await _secureStorage.setPassword(_controllerPassword.text);
    }
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      // print('--- login email\n $_controllerEmail.text ');
      // print(' --- login password\n $_controllerPassword.text');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      // print('--- signIn error message\n$errorMessage ---- ');
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (!dontStore) {
      await _secureStorage.setDisplayName(_controllerDisplayName.text);
      await _secureStorage.setEmail(_controllerEmail.text);
      await _secureStorage.setPassword(_controllerPassword.text);
    }
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          displayname: _controllerDisplayName.text);
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(_controllerDisplayName.text);
      // postUser(_controllerEmail.text, _controllerPassword.text,
      // _controllerDisplayName.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      // print('--- createUser error message\n$errorMessage');
    }
  }
// <========

// Page App bar login/register title

  Widget _title() {
    return (isLogin) ? const Text("Login") : const Text("Register");
  }

// ======== Form widgets =========>

// ---- Flutter validation package methods ----

  final AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;

  final _displayNameValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(2, errorText: 'Min. 2 letters'),
  ]);
  final _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(5, errorText: 'Min. 5 letters'),
    EmailValidator(errorText: "Invalid email address"),
  ]);
  final _currentPasswordValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
    MinLengthValidator(4, errorText: 'Min. 4 letters'),
    MaxLengthValidator(20,
        errorText: "Password cannot be longer than 20 characters"),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must contain at least one special character')
  ]);
  final _currentPasswordConfirmValidator = MultiValidator([
    RequiredValidator(errorText: 'Required'),
  ]);

  // ---- Form field widgets ----

  Widget _entryFieldDisplayName(
    String displayName,
    TextEditingController _controllerDisplayName,
  ) {
    return TextFormField(
      validator: _displayNameValidator,
      controller: _controllerDisplayName,
      cursorColor: GlobalStyleVariables.primaryAccentColor,
      decoration: const InputDecoration(
        errorStyle:
            TextStyle(color: GlobalStyleVariables.primaryTextErrorColour),
        hintText: 'Enter your name',
        hintStyle: TextStyle(
          color: GlobalStyleVariables.primaryTextDarkColour,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.buttonGreenActive),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: GlobalStyleVariables.primaryTextDarkColour,
          ),
        ),
        prefixIcon: Icon(Icons.person_outline_outlined),
        label: Text(
          'Name',
          style: TextStyle(
            color: GlobalStyleVariables.primaryTextDarkColour,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _entryFieldEmail(
    String email,
    TextEditingController _controllerEmail,
  ) {
    return TextFormField(
      validator: _emailValidator,
      controller: _controllerEmail,
      cursorColor: GlobalStyleVariables.primaryAccentColor,
      decoration: const InputDecoration(
        errorStyle:
            TextStyle(color: GlobalStyleVariables.primaryTextErrorColour),
        hintText: 'Enter your email',
        hintStyle: TextStyle(
          color: GlobalStyleVariables.primaryTextDarkColour,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.buttonGreenActive),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: GlobalStyleVariables.primaryTextDarkColour,
          ),
        ),
        prefixIcon: Icon(Icons.alternate_email_outlined),
        label: Text(
          'Email',
          style: TextStyle(
            color: GlobalStyleVariables.primaryTextDarkColour,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _currentPassword = '';
  String _currentPasswordConfirm = '';
  bool isPasswordFocused = false;
  bool isPasswordChanged = false;

  Widget _entryFieldPassword(
    String password,
    TextEditingController _controllerPassword,
  ) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          setState(() {
            isPasswordFocused = true;
            _currentPassword = _controllerPassword.text;
            _controllerPassword.text = '';
          });
        } else {
          setState(() {
            isPasswordFocused = false;
            _controllerPassword.text = _currentPassword;
            isObscure = true;
          });
        }
      },
      child: TextFormField(
        obscureText: isObscure,
        validator: _currentPasswordValidator,
        onChanged: ((value) => {
              if (value.isNotEmpty)
                {
                  setState(
                    () {
                      isPasswordChanged = true;
                      _currentPassword = value;
                    },
                  ),
                }
            }),
        controller: _controllerPassword,
        cursorColor: GlobalStyleVariables.primaryAccentColor,
        decoration: InputDecoration(
          errorStyle:
              TextStyle(color: GlobalStyleVariables.primaryTextErrorColour),
          hintText: 'Enter your password',
          hintStyle: const TextStyle(
            color: GlobalStyleVariables.primaryTextDarkColour,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: GlobalStyleVariables.buttonGreenActive),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: GlobalStyleVariables.primaryTextDarkColour,
            ),
          ),
          prefixIcon: const Icon(Icons.password_outlined),
          label: const Text(
            'Password',
            style: TextStyle(
              color: GlobalStyleVariables.primaryTextDarkColour,
              letterSpacing: 0.5,
              fontSize: 14,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(!isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            onPressed: () {
              !isPasswordChanged && isObscure
                  ? setState(() {
                      _currentPassword = _controllerPassword.text;
                      _controllerPassword.text = '';
                      isObscure = false;
                    })
                  : !isPasswordChanged && !isObscure
                      ? setState(() {
                          isObscure = true;
                          _controllerPassword.text = _currentPassword;
                        })
                      : isPasswordChanged && isObscure
                          ? setState(() {
                              _controllerPassword.text = _currentPassword;
                              isObscure = false;
                            })
                          : isPasswordChanged && !isObscure
                              ? setState(() {
                                  _controllerPassword.text = _currentPassword;
                                  isObscure = true;
                                })
                              : isObscure = true;
            },
          ),
        ),
      ),
    );
  }

  Widget _entryFieldPasswordConfirm(
    String passwordConfirm,
    TextEditingController _controllerPasswordConfirm,
  ) {
    return TextFormField(
      obscureText: isObscure,
      validator: _currentPasswordConfirmValidator,
      onChanged: ((value) => _currentPasswordConfirm = value),
      controller: _controllerPasswordConfirm,
      cursorColor: GlobalStyleVariables.primaryAccentColor,
      decoration: const InputDecoration(
        errorStyle:
            TextStyle(color: GlobalStyleVariables.primaryTextErrorColour),
        hintText: 'Re-type password',
        hintStyle: TextStyle(
          color: GlobalStyleVariables.primaryTextDarkColour,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: GlobalStyleVariables.buttonGreenActive),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: GlobalStyleVariables.primaryTextDarkColour,
          ),
        ),
        prefixIcon: Icon(
          Icons.password_outlined,
        ),
        label: Text(
          'Confirm password',
          style: TextStyle(
            color: GlobalStyleVariables.primaryTextDarkColour,
            letterSpacing: 0.5,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Widget _errorMessage() {
  //   return Text(errorMessage == "" ? "" : "$errorMessage");
  // }

  Widget _submitButton() {
    return ElevatedButton(
        style: isLogin
            ? ElevatedButton.styleFrom(
                backgroundColor: GlobalStyleVariables.buttonGreenActive,
                foregroundColor: GlobalStyleVariables.primaryTextLightColour)
            : ElevatedButton.styleFrom(
                backgroundColor: GlobalStyleVariables.buttonBlueActive,
                foregroundColor: GlobalStyleVariables.primaryTextLightColour),
        onPressed: () {
          if (isLogin) {
            _submitValidation();
          } else {
            if (_formKey.currentState!.validate()) {
              if (_currentPasswordConfirm == _currentPassword ||
                  _currentPasswordConfirm == _controllerPassword.text) {
                _submitValidation();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: GlobalStyleVariables.primaryAccentColor,
                      content: Text("Re-type both passwords!")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    duration: const Duration(seconds: 2),
                    backgroundColor: GlobalStyleVariables.primaryAccentColor,
                    content: Text(errorMessage == ""
                        ? "Check form fields!"
                        : "Error: $errorMessage!")),
              );
            }
          }
        },
        child: Text(isLogin ? "Login" : "Register"));
  }

  void _submitValidation() {
    isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
    _formKey.currentState?.save();
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: isLogin
            ? const Text("Register Instead",
                style: TextStyle(
                  color: GlobalStyleVariables.buttonBlueActive,
                  letterSpacing: 0.5,
                  fontSize: 14,
                ))
            : const Text("Login Instead",
                style: TextStyle(
                  color: GlobalStyleVariables.buttonGreenActive,
                  letterSpacing: 0.5,
                  fontSize: 14,
                )));
  }

  Widget dontStoreMyData() {
    return CheckboxListTile(
      title: const Text(
        "Forget Me",
        style: TextStyle(
            color: GlobalStyleVariables.primaryTextDarkColour, fontSize: 12),
      ),
      value: dontStore,
      onChanged: (bool? value) {
        _secureStorage.deleteDisplayName();
        _secureStorage.deleteEmail();
        _secureStorage.deletePassword();
        setState(() {
          dontStore = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _clearForm() {
    return TextButton(
        onPressed: () {
          setState(() {
            errorMessage = '';
            _formKey.currentState?.reset();
          });
          _controllerDisplayName.clear();
          _controllerEmail.clear();
          _controllerPassword.clear();
          _controllerPasswordConfirm.clear();
        },
        child: const Text(
          "Clear Form",
          style: TextStyle(
              color: GlobalStyleVariables.primaryTextDarkColour, fontSize: 12),
        ));
  }

// <========

// ======== Login page structure =========>

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title(),
          backgroundColor: GlobalStyleVariables.primaryAppBarColour,
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                GlobalStyleVariables.primaryBackgroundColour,
                GlobalStyleVariables.primaryBackgroundGradientColour,
              ])),
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: (!isLogin)
                            ? _entryFieldDisplayName(
                                "Your name", _controllerDisplayName)
                            : const SizedBox(
                                width: double.infinity,
                              ),
                      ),
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: _entryFieldEmail("Your email", _controllerEmail),
                      ),
                      SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: _entryFieldPassword(
                            "Enter password", _controllerPassword),
                      ),
                      if (!isLogin)
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: _entryFieldPasswordConfirm(
                              "Re-type password", _controllerPasswordConfirm),
                        ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: _submitButton(),
                      ),
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: _loginOrRegisterButton(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: dontStoreMyData(),
                      ),
                      Expanded(
                        child: _clearForm(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
// <========
