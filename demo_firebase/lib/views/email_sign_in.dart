import 'package:demo_firebase/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FormStatus {
  signIn,
  register,
  reset,
}

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  FormStatus _formStatus = FormStatus.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _formStatus == FormStatus.signIn
              ? buildSignInForm()
              : _formStatus == FormStatus.register
                  ? buildRegisterInForm()
                  : buildResetInForm(),
        ),
      ),
    );
  }

  Form buildSignInForm() {
    final _signInFormKey = GlobalKey<FormState>();
    final TextEditingController _pass = TextEditingController();
    final TextEditingController _email = TextEditingController();
    return Form(
      key: _signInFormKey,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Lütfen Giriş Yapınız",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _email,
                validator: (val) {
                  if (!EmailValidator.validate(val)) {
                    return "Lütfen Geçerli bir mail giriniz";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "E-mail",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pass,
                obscureText: true,
                validator: (value) {
                  if (value.length >= 6)
                    return null;
                  else
                    return "6 haneden düşük bir şifre girdin.";
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Şifre",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_signInFormKey.currentState.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .signInWithEmailAndPassword(_email.text, _pass.text);
                    if (!user.emailVerified) {
                      await _showMyDialog();
                      await Provider.of<Auth>(context, listen: false).signOut();
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text("Giriş"),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.register;
                  });
                },
                child: Text("Yeni Kayıt İçin Tıklayınız"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _formStatus = FormStatus.reset;
                  });
                },
                child: Text("Şifremi Unuttum"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form buildRegisterInForm() {
    final _registerInForm = GlobalKey<FormState>();
    final TextEditingController _pass = TextEditingController();
    final TextEditingController _confirmPass = TextEditingController();
    final TextEditingController _email = TextEditingController();

    return Form(
      key: _registerInForm,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lütfen Kayıt Olunuz",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _email,
              validator: (val) {
                if (!EmailValidator.validate(val)) {
                  return "Lütfen Geçerli bir mail giriniz";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "E-mail",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _pass,
              validator: (val) {
                if (val.length >= 6)
                  return null;
                else
                  return "6 haneden düşük bir şifre girdin.";
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Şifre",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPass,
              validator: (val) {
                if (val.length >= 6)
                  return null;
                else if (_confirmPass != _pass)
                  return "Şifreler Uyuşmuyor";
                else
                  return "6 haneden düşük bir şifre girdin.";
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Onay",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try{
                  if (_registerInForm.currentState.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                      _email.text,
                      _pass.text,
                    );

                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog();
                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                    await Provider.of<Auth>(context, listen: false).signOut();
                  }
                }
                on FirebaseAuthException catch(e) {
                  print("Kayıt formu içerisinde hata yakalandı");
                }
              },
              child: Text("Register"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.signIn;
                });
              },
              child: Text("Zaten üye misiniz? Geri Dön!"),
            )
          ],
        ),
      ),
    );
  }

  Form buildResetInForm() {
    final _resetFormKey = GlobalKey<FormState>();
    final TextEditingController _email = TextEditingController();

    return Form(
      key: _resetFormKey,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Email Giriniz",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _email,
                validator: (val) {
                  if (!EmailValidator.validate(val)) {
                    return "Lütfen Geçerli bir mail giriniz";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "E-mail",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_resetFormKey.currentState.validate()) {
                    await Provider.of<Auth>(context, listen: false)
                        .sendPasswordResetEmail(_email.text);
                    await _showMyDialogToReset();

                    Navigator.pop(context);
                  }
                },
                child: Text("Gönder"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, lütfen mailinizi kontrol ediniz.'),
                Text('Onay linkini tıklayıp tekrar giriş yapmalısınız..'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogToReset() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ONAY GEREKİYOR'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, lütfen mailinizi kontrol ediniz.'),
                Text('Linki tıklayarak şifrenizi yenileyiniz...'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
