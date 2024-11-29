import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _selectedIndex = 0;
  List<String> jogosFavoritos = []; // Lista que armazena os títulos dos jogos favoritos

  final List<Widget> _telas = [
    TelaInicial(),
    TelaNoticias(),
    TelaSeguranca(),
    TelaNotificacoes(),
    TelaMenu(), // Adicionando a nova tela
  ];


  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 43, 64, 1.0),
      body: Column(
        children: [
          // Parte Superior Fixa
          Container(
            alignment: Alignment(10, -0.9),
            height: 150,
            decoration: BoxDecoration(color: Colors.black87),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(
                      width: 265,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white54,
                          labelText: "STEAM",
                          labelStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 2,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 2,
                              )),
                          suffixIcon: Icon(Icons.search, color: Colors.black45),
                        ),
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.white54),
                    Image(
                      height: 100,
                      width: 50,
                      image: NetworkImage(
                          "https://i.cultureoeuvre.com/images/055/image-164315-j.webp"),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.blue,
                      ),
                      child: DropdownButton<String>(
                        value: 'MENU',
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        onChanged: (String? newValue) {
                          print('Selected: $newValue');
                        },
                        items: <String>[
                          'MENU',
                          'Your Store',
                          'New & Noteworthy',
                          'Categories',
                          'Points Shop',
                          'News',
                          'Labs'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        iconEnabledColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          List<String> jogosFavoritos = prefs.getStringList('favoritos') ?? [];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaWishlist(favoritos: jogosFavoritos), // Passando a lista de jogos favoritados
                            ),
                          );
                        },
                        child: Text(
                          'WISHLIST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: InkWell(
                        onTap: () {
                          print('WALLET');
                        },
                        child: Text(
                          'WALLET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('DINHEIRO NA CARTEIRA');
                      },
                      child: Text(
                        '(RS 1000,82)',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Parte Central
          Expanded(
            child: _telas[_selectedIndex],
          ),

          // Parte Inferior Fixa
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
              height: 41,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildClickableIcon(Icons.sell, 0),
                  buildClickableIcon(Icons.list_alt, 1),
                  buildClickableIcon(Icons.shield, 2),
                  buildClickableIcon(Icons.notifications, 3),
                  buildClickableIcon(Icons.more_horiz, 4), // Ícone de menu
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildClickableIcon(IconData icon, int index) {
    // Impede que um índice inválido seja acessado
    if (index >= _telas.length) return SizedBox(); // Evita acesso fora dos limites

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 5, 0, 0),
      child: InkWell(
        onTap: () => _onIconTapped(index),
        child: Icon(
          icon,
          color: _selectedIndex == index ? Colors.blue : Colors.white,
        ),
      ),
    );
  }

}

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<bool> favoritos = List.generate(5, (_) => false); // Lista para armazenar favoritos

  // Função para salvar os favoritos no SharedPreferences
  void _salvarFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jogosFavoritos = [];

    List<String> todosJogos = [
      'Counter Strike 1.6',
      'Fortnite',
      'Brawhalla',
      'EA FC 24',
      'Euro Truck Simulator 2',
    ];

    for (int i = 0; i < favoritos.length; i++) {
      if (favoritos[i]) {
        jogosFavoritos.add(todosJogos[i]); // Adicionando o nome do jogo (personalize conforme necessário)
      }
    }
    await prefs.setStringList('favoritos', jogosFavoritos); // Salva a lista de jogos favoritados

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image(
              height: 270,
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://cdn.ome.lt/4lGOGilj5IxtlFZT_7A9XN6ti08=/770x0/smart/uploads/conteudo/fotos/comparacao-logo-free-fire.JPG'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Row(
                    children: [
                      Text(
                        'FEATURED & RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildFeaturedCard(
                              'Counter Strike 1.6',
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQeLpYwtPa61UpcCWygI7ZKSP2jB_9HEK5MCiQxANmWn5KIePNp5iUq1etDLvVdZKfKZQ&usqp=CAU',
                              'Up to -90%',
                              0, // Índice do jogo
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: buildFeaturedCard(
                                'Fortnite',
                                'data:image/jpeg;base64,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',
                                'RS 131,90',
                                1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: buildFeaturedCard(
                                'Brawhalla',
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx-EQCUh7yuqEViOE6nDAx0M5WK860uOQ0bA&s',
                                'RS 00,00',
                                2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: buildFeaturedCard(
                                'EA FC 24',
                                'https://c.clc2l.com/t/e/a/ea-sports-fc-24-5nFZ3X.png',
                                'RS 399,99',
                                3,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: buildFeaturedCard(
                                'Euro Truck Simulator 2',
                                'https://steamuserimages-a.akamaihd.net/ugc/106230653177024929/E57B7033ACF95AECCAAD7950E9C3EEF722107F6D/?imw=5000&imh=5000&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false',
                                'RS 46,66',
                                4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget buildFeaturedCard(String title, String imageUrl, String price, int index) {
    return Container(
      width: 310,
      height: 275,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 15.0,
            offset: Offset(0.0, 0.75),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black12,
            Color.fromRGBO(26, 43, 78, 1),
          ],
        ),
        color: Color.fromRGBO(26, 43, 78, 0.8),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              IconButton(
                icon: Icon(
                  favoritos[index] ? Icons.favorite : Icons.favorite_border,
                  color: favoritos[index] ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    favoritos[index] = !favoritos[index];
                    _salvarFavoritos(); // Salva os favoritos
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          favoritos[index]
                              ? '$title adicionado à wishlist.'
                              : '$title removido da wishlist.',
                        ),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 6, 0, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                  ),
                  child: Text(
                    price,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.lightGreenAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}

class TelaNoticias extends StatelessWidget {
  final List<Map<String, String>> noticias = [
    {
      "titulo": "Nova atualização para Counter-Strike 2!",
      "descricao": "A atualização traz novos mapas e melhorias de desempenho.",
      "imagem": "https://www.outerspace.com.br/wp-content/uploads/2023/03/counter-strike2.jpeg"
    },
    {
      "titulo": "Fortnite: evento de Halloween começa hoje!",
      "descricao": "Participe do evento e ganhe recompensas exclusivas.",
      "imagem": "https://i.ytimg.com/vi/p1_uFQUqOz0/maxresdefault.jpg"
    },
    {
      "titulo": "Brawlhalla: novos personagens disponíveis!",
      "descricao": "Conheça os novos lutadores e suas habilidades.",
      "imagem": "https://cms.brawlhalla.com/c/uploads/2024/08/812PNThumb_1920.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Novidades',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...noticias.map((noticia) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.black54,
                  child: Column(
                    children: [
                      Image.network(noticia['imagem']!),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          noticia['titulo']!,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          noticia['descricao']!,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class TelaSeguranca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Segurança do Steam',
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Ative o Steam Guard para proteger sua conta.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              'O Steam Guard adiciona uma camada extra de segurança ao seu perfil, exigindo um código enviado para o seu e-mail ou aplicativo móvel quando você tentar acessar sua conta em um novo dispositivo.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Ação para ativar/desativar o Steam Guard
              },
              child: Text('Ativar Steam Guard'),
              style: ElevatedButton.styleFrom(primary: Colors.blue),
            ),
            SizedBox(height: 16),
            Divider(color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'Como funciona:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              '1. Acesse sua conta Steam.\n2. Vá até Configurações.\n3. Selecione Segurança.\n4. Ative o Steam Guard.',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              'Dicas de segurança:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Use senhas fortes e únicas.\n• Nunca compartilhe suas informações de login.\n• Habilite a autenticação em dois fatores sempre que possível.',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// Nova tela de notificações
class TelaNotificacoes extends StatelessWidget {
  final List<Map<String, String>> notificacoes = [
    {
      "titulo": "Promoção de Halloween!",
      "descricao": "Descontos em jogos até 31 de outubro.",
      "data": "29/10/2024"
    },
    {
      "titulo": "Novo jogo disponível: EA FC 24",
      "descricao": "Compre agora e ganhe bônus exclusivos.",
      "data": "28/10/2024"
    },
    {
      "titulo": "Atualização do Brawlhalla",
      "descricao": "Novos personagens e modos de jogo!",
      "data": "27/10/2024"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notificações',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...notificacoes.map((notificacao) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notificacao['titulo']!,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          notificacao['descricao']!,
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          notificacao['data']!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class TelaMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu',
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          buildMenuItem(context, 'Loja', '', Icons.store),
          buildMenuItem(context, 'Notícias', '', Icons.article),
          buildMenuItem(context, 'Segurança', '', Icons.security),
          buildMenuItem(context, 'Notificações', '', Icons.notifications),
          buildMenuItem(context, 'Confirmações', '', Icons.check),
          buildMenuItem(context, 'Comunidade', '', Icons.group),
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, String description, IconData icon) {
    return Card(
      color: Colors.black54,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.white70),
        ),
        onTap: () {
          // Ação para a opção clicada
          print('$title clicado');
        },
      ),
    );
  }
}class TelaWishlist extends StatelessWidget {
  final List<String> favoritos;

  // Construtor para receber a lista de favoritos
  TelaWishlist({required this.favoritos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 43, 64, 1.0),
      appBar: AppBar(
        title: Text('Wishlist'),
        backgroundColor: Colors.black87,
      ),
      body: favoritos.isEmpty
          ? Center(
        child: Text(
          'Nenhum jogo favorito',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.black54,
              child: ListTile(
                leading: Icon(Icons.favorite, color: Colors.red),
                title: Text(
                  favoritos[index],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

