import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      home: TicTacToeGame(),
    );
  }
}

// Widget que gerencia o estado do jogo
class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  // Lista que representa o tabuleiro 3x3 (inicialmente vazio)
  List<String> board = List.filled(9, '');

  // Variável para controlar de quem é a vez (X ou O)
  String currentPlayer = 'X';

  // Função para verificar se houve um vencedor
  String checkWinner() {
    // Posições vencedoras possíveis no tabuleiro
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Linhas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Colunas
      [0, 4, 8], [2, 4, 6]             // Diagonais
    ];

    // Verifica todas as combinações vencedoras
    for (var combo in winningCombinations) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        return board[combo[0]]; // Retorna o jogador vencedor
      }
    }
    return ''; // Se não houver vencedor
  }

  // Função para verificar se o tabuleiro está cheio (empate)
  bool isBoardFull() {
    return !board.contains(''); // Se não houver espaços vazios
  }

  // Função chamada ao clicar em um botão do tabuleiro
  void _handleTap(int index) {
    setState(() {
      if (board[index] == '' && checkWinner() == '') {
        // Marca o espaço com o jogador atual
        board[index] = currentPlayer;

        // Verifica se há um vencedor após a jogada
        String winner = checkWinner();
        if (winner != '') {
          _showDialog('$winner venceu!');
        } else if (isBoardFull()) {
          _showDialog('Empate!');
        } else {
          // Alterna o jogador
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      }
    });
  }

  // Função para exibir o diálogo de vencedor ou empate
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Reiniciar"),
              onPressed: () {
                // Reinicia o jogo
                setState(() {
                  board = List.filled(9, '');
                  currentPlayer = 'X';
                });
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo da Velha')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exibe o tabuleiro 3x3
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 colunas
              ),
              itemCount: 9, // Total de 9 células no tabuleiro
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleTap(index), // Ao clicar em uma célula
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[index], // Exibe X, O ou nada
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}