import 'package:flutter/material.dart';

import '../../_core/constants/listin_colors.dart';
import '../../_core/components/listin_snackbars.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isLoginScreen = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isLoginScreen)
                            ? "Bem vindo ao Listin!"
                            : "Vamos começar?",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      (isLoginScreen)
                          ? "Faça login para criar sua lista de compras."
                          : "Faça seu cadastro para começar a criar sua lista de compras com Listin.",
                      textAlign: TextAlign.center,
                    ),
                    Visibility(
                      visible: !isLoginScreen,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          label: Text("Nome"),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return "Insira um nome maior.";
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(label: Text("E-mail")),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "O valor de e-mail deve ser preenchido";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "O valor do e-mail deve ser válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(label: Text("Senha")),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) => onSendButtonClicked(),
                    ),
                    Visibility(
                      visible: isLoginScreen,
                      child: TextButton(
                        onPressed: () {
                          onForgotPasswordClicked();
                        },
                        child: const Text("Esqueci minha senha."),
                      ),
                    ),
                    Visibility(
                        visible: !isLoginScreen,
                        child: TextFormField(
                          controller: _passwordConfirmationController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text("Confirme a senha"),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 4) {
                              return "Insira uma confirmação de senha válida.";
                            }
                            if (value != _passwordController.text) {
                              return "As senhas devem ser iguais.";
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) => onSendButtonClicked(),
                        )),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        onSendButtonClicked();
                      },
                      child: Text(
                        (isLoginScreen) ? "Entrar" : "Cadastrar",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginScreen = !isLoginScreen;
                        });
                      },
                      child: Text(
                        (isLoginScreen)
                            ? "Ainda não tem conta?\nClique aqui para cadastrar."
                            : "Já tem uma conta?\nClique aqui para entrar",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: ListinColors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSendButtonClicked() {
    String email = _emailController.text;
    String senha = _passwordController.text;
    String nome = _nameController.text;

    if (_formKey.currentState!.validate()) {
      if (isLoginScreen) {
        _loginUser(email: email, senha: senha);
      } else {
        _signupUser(email: email, senha: senha, nome: nome);
      }
    }
  }

  _loginUser({required String email, required String senha}) {
    authService.login(email: email, senha: senha).then((String? erro) {
      if (erro != null) {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }

  _signupUser({
    required String email,
    required String senha,
    required String nome,
  }) {
    authService.signup(email: email, senha: senha, nome: nome).then(
      (String? erro) {
        if (erro != null) {
          showSnackBar(context: context, mensagem: erro);
        }
      },
    );
  }

  onForgotPasswordClicked() {
    String email = _emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController redefincaoSenhaController =
            TextEditingController(text: email);
        return AlertDialog(
          title: const Text("Confirme o e-mail para redefinição de senha"),
          content: TextFormField(
            controller: redefincaoSenhaController,
            decoration: const InputDecoration(label: Text("Confirme o e-mail")),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          actions: [
            TextButton(
              onPressed: () {
                authService
                    .createNewPassword(email: redefincaoSenhaController.text)
                    .then((String? erro) {
                  if (erro == null) {
                    showSnackBar(
                      context: context,
                      mensagem: "E-mail de redefinição enviado!",
                      isErro: false,
                    );
                  } else {
                    showSnackBar(context: context, mensagem: erro);
                  }

                  Navigator.pop(context);
                });
              },
              child: const Text("Redefinir senha"),
            ),
          ],
        );
      },
    );
  }
}
