import 'package:flutter/material.dart';
import 'package:navegacao/Postagem.dart';
import 'package:navegacao/Tela1.dart';
import 'package:navegacao/Tela2.dart';
import 'package:navegacao/Tela3.dart';
import 'package:navegacao/Tela4.dart';

class Aplicativo extends StatelessWidget {
  final List<Pessoa> pessoas;
  final String nomeUsuario;

  const Aplicativo({
    super.key,
    required this.nomeUsuario,
  }) : pessoas = const [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Integrador',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.light(
          primary: Colors.pink.shade300,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Menu(nomeUsuario: nomeUsuario, pessoas: pessoas),
      routes: {
        '/tela1': (context) => Cadastro(pessoas: pessoas),
        '/tela2': (context) => TabelaPai(),
        '/tela3': (context) => CadastrarPostagem(username: nomeUsuario),
        '/tela4': (context) => VerPostagens(),
        '/tela5': (context) => MinhasPostagens(username: nomeUsuario),
      },
    );
  }
}

class Menu extends StatelessWidget {
  final String nomeUsuario;
  final List<Pessoa> pessoas;

  const Menu({super.key, required this.nomeUsuario, required this.pessoas});

  @override
  Widget build(BuildContext context) {
    final botoes = [
      MenuButton(texto: "Cadastrar", rota: '/tela1', icone: Icons.person_add_alt_1),
      MenuButton(texto: "Listar", rota: '/tela2', icone: Icons.list),
      MenuButton(texto: "Criar postagem", rota: '/tela3', icone: Icons.note_add),
      MenuButton(texto: "Ver postagens", rota: '/tela4', icone: Icons.visibility),
      MenuButton(texto: "Minhas postagens", rota: '/tela5', icone: Icons.assignment_ind),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo(a), $nomeUsuario', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.pets, size: 80, color: Colors.pink.shade300),
          const SizedBox(height: 10),
          Text(
            "Olá, $nomeUsuario 👋",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: botoes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) => botoes[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String texto;
  final String rota;
  final IconData icone;

  const MenuButton({
    super.key,
    required this.texto,
    required this.rota,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(16),
        elevation: 6,
        shadowColor: Colors.pink.shade100,
      ),
      onPressed: () {
        Navigator.pushNamed(context, rota);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            texto,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
