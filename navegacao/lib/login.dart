import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navegacao/main.dart';

void main() {
  runApp(Preconfiguracao());
}

class Preconfiguracao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginEstado createState() => LoginEstado();
}

class LoginEstado extends State<Login> {
  final emailControle = TextEditingController();
  final senhaControle = TextEditingController();
  bool ocultado = true;
  String mensagemErro = '';

  Future<void> logar() async {
    final email = emailControle.text.trim();
    final senha = senhaControle.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() => mensagemErro = 'Preencha todos os campos!');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      final url = Uri.parse(
          "https://senac-a42c7-default-rtdb.firebaseio.com/usuario.json");
      final resposta = await http.get(url);

      Navigator.of(context).pop(); // Fecha o loading

      if (resposta.statusCode == 200) {
        final Map<String, dynamic> dados = jsonDecode(resposta.body);
        bool usuarioValido = false;
        String nomeUsuario = '';

        dados.forEach((key, valor) {
          if (valor['email'] == email && valor['senha'] == senha) {
            usuarioValido = true;
            nomeUsuario = valor['nome'];
          }
        });

        if (usuarioValido) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Aplicativo(nomeUsuario: nomeUsuario)),
          );
        } else {
          setState(() => mensagemErro = 'Email ou senha inválidos');
        }
      } else {
        setState(() => mensagemErro = 'Erro ao acessar o servidor');
      }
    } catch (e) {
      Navigator.of(context).pop();
      setState(() => mensagemErro = 'Erro de conexão: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        toolbarHeight: 50,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            const SizedBox(height: 20),
            Icon(Icons.pets, size: 200, color: Colors.pink.shade300),
            const SizedBox(height: 20),
            Text(
              'PetRescue',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade300,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 190),
            TextField(
              controller: emailControle,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Colors.pink.shade300),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: senhaControle,
              obscureText: ocultado,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Colors.pink.shade300),
                suffixIcon: IconButton(
                  icon:
                      Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => ocultado = !ocultado),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: logar, child: Text('Entrar')),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Cadastro()));
              },
              child: Text('Não tem uma conta? Cadastre-se'),
            ),
            if (mensagemErro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(mensagemErro, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}

class Cadastro extends StatefulWidget {
  @override
  CadastroEstado createState() => CadastroEstado();
}

class CadastroEstado extends State<Cadastro> {
  final nomeControle = TextEditingController();
  final emailControle = TextEditingController();
  final senhaControle = TextEditingController();
  String erro = '';
  bool ocultado = true;

  Future<void> cadastrar() async {
    final nome = nomeControle.text.trim();
    final email = emailControle.text.trim();
    final senha = senhaControle.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      setState(() => erro = 'Todos os campos são obrigatórios');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      final url = Uri.parse(
          'https://senac-a42c7-default-rtdb.firebaseio.com/usuario.json');
      final resposta = await http.post(
        url,
        body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(context).pop(); // Fecha o loading

      if (resposta.statusCode == 200) {
        Navigator.pop(context); // Volta pro login
      } else {
        setState(() => erro = 'Erro ao cadastrar usuário');
      }
    } catch (e) {
      Navigator.of(context).pop();
      setState(() => erro = 'Erro de conexão: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de novo usuário'),
        backgroundColor: Colors.pink.shade300,
        toolbarHeight: 50,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Icon(Icons.person_add, color: Colors.pink.shade300, size: 100.0),
            SizedBox(height: 20.0),
            TextField(
              controller: nomeControle,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.pink.shade300),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailControle,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Colors.pink.shade300),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: senhaControle,
              obscureText: ocultado,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Colors.pink.shade300),
                suffixIcon: IconButton(
                  icon:
                      Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => ocultado = !ocultado),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: cadastrar, child: Text('Cadastrar')),
            if (erro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(erro, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
