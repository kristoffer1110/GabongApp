import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final List<bool> _isExpanded = List<bool>.filled(7,false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(

      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Rules Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExpansionTile(
            title: 'Basic Rules',
            index: 0,
            children: const [
              Text('A player can place cards of the same type* on top of each other', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('A player can place cards of the same value** on top of each other.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('An eight can be used to change to other types of cards', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('The goal of the game is to get the least amount of points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* Card of the same suit (Diamonds, Hearts, Clubs, Spades)', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('** Card of the same number (A(1), 2, 3, 4, 5, 6, 7, 8, 9, 10, J(11), Q(12), K(13))', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Special Cards',
            index: 1,
            children: const [
                Text('Card #2', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('If a player places down a 2 card, the next players must also put down a 2 card. If not draw the sum of 2 cards put down', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('This can only be broken if:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('1. If a player "smacks", that players draws the sum of 2 cards put down and the round continues normally from the next player', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('2. If a player "gabongs" then the round is over and no one needs to draw', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('King', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('Changes playing direction', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Card #3', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('Jumps over one* person', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Ace, Spade-2 and Diamonds-10', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('Has different values. Comes back to this part in Gabong', style: TextStyle(fontSize: 18)),

              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* Official rules say it justs jumps over 1 person, even though you "smack" 2 or more 3s at one', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Special Rules',
            index: 2,
            children: const [
              Text('Gabong', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('If the sum of all the cards in a players hand* is the same as the top card in play**, the player may lay down all the cards and say gabong.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('Exceptions:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('1. It is not allowed to gabonge on or with an eight.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('2. The player cannot say anything that deviates from the word gabong', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 16),
              Text('Smacking', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('Gabong is a game played with a minimum of 2 decks of cards. This means that at any given time there are at least 2 identical cards*** in play. Identical cards can always be placed on top of each other and is the most fundamental rule in Gabong. There are no exceptions here.', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* All cards a player has (a player does not have to hold all cards).', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('** Spades2 = 2 and 15 on the board. diamonds10 = 10 and 16 on the board.', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('*** Identical cards are two cards that are of the same suit and have the same value.', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Gameplay',
            index: 3,
            children: const [
              Text('Start and End of a game', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('A round starts when the Gabon Master has dealt his cards. The two players sitting on either side of the Gabon Master then "battle"* to be the first to fold. The one who folds first determines the direction of the game.', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('The game ends when one or more players get rid of all their cards without showing any emotions (see the section on emotions).', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('When a player puts down their penultimate card, the player must say “one more card”****', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('It is not allowed to end with an 8', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 16),
              Text('Speed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('Gabong is a fast-paced game, and each player has between about 2 seconds to make their move**. The Gabong master is responsible for enforcing this rule and gives cards to players who are too slow. This then counts as a move, and it is the next players turn.', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 16),
              Text('Emotions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('It is not allowed to show emotions when finishing a game. This rule may seem strange, but it is there for a reason. If one or more players continue to play after one or more players have finished, they will be given a penalty card. It is therefore a point that one should not show strong emotions when finishing.', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* If the first card in play is a 3, you skip both players who usually battle, and it is the players next to them who bat again.', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('** With experienced players the time can vary with what feels "fast"', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('*** or gentleman', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('**** Or something that shows the others that they have one card left', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Gabong Master',
            index: 4,
            children: const [
              Text('How to become a Gabong Master', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('A person can become Gabong Master in 3 different ways:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('1. At the beginning of each game, the player with most experience is the Gabong Master', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('2. A player that Gabongs becomes the Gabong Master next round', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('3. If a Gabong Master must leave the game, the master can delegate their role to another player*', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 16),
              Text('Distribute Cards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('The Gabong Master must choose a deck of cards before he starts dealing. If this deck is the exact amount of cards to be dealt, the Gabong Master receives -50 points. If he chooses too few cards, he is dealt the difference as penalty cards.', style: TextStyle(fontSize: 18)),
              
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text('* Rules vary from tournament games. Their the most experienced should take over as Gabong Master', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ),
            ],
          ),
          _buildExpansionTile(
            title: 'Penalty Cards',
            index: 5,
            children: const [
              Text('Gabong Master can give out penalty cards for:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
              SizedBox(height: 16),
              Text('1. Players that touch their cards before the Gabong Master (1 Card Penalty)', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('2. Players that wrongly Gabong (5 Card Penalty)', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('3. Players that ends incorrectly (3 Card Penalty). Applies also for players that forget to say "one card left"', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('4. Players that show emotion at the end (3 Card Penalty when ending, 5 Card Penalty when Gabong)', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('5. Players that play to slow (1 Card Penalty)', style: TextStyle(fontSize: 18)),
            ],
          ),
          _buildExpansionTile(
            title: 'Counting Points',
            index: 6,
            children: const [
              Text('4,5,6,7,9,10 = 5 Points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('J,Q = 10 Points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('A = 15 Points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('3,K = 20 Points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('8 = 50 Points', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text('2 = This is worth 5 points + when all the points are counted, the total sum should be multiplied by 2. If you have more wos, the total sum should be multiplied by two once per two.', style: TextStyle(fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required int index, required List<Widget> children}) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      initiallyExpanded: _isExpanded[index],
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded[index] = expanded;
        });
      },
      children: children,
    );
  }
}
