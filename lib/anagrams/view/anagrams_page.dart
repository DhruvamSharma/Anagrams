import 'package:anagrams/anagrams/bloc/anagram_bloc.dart';
import 'package:anagrams/anagrams/domain/word.dart';
import 'package:anagrams/l10n/l10n.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnagramsPage extends StatelessWidget {
  const AnagramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnagramBloc()
        ..add(
          SetupAnagrams(
            DefaultAssetBundle.of(context),
          ),
        ),
      child: const AnagramsView(),
    );
  }
}

class AnagramsView extends StatelessWidget {
  const AnagramsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.anagramAppBarTitle)),
      body: BlocBuilder<AnagramBloc, AnagramState>(
        builder: (context, state) {
          switch (state.status) {
            case AnagramGameStatus.gameError:
              return const Center(
                child: Text('An error occurred'),
              );
            case AnagramGameStatus.loaded:
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: const [
                    _SelectedWord(),
                    SizedBox(height: 20),
                    _AnagramsTextField(),
                    SizedBox(height: 10),
                    _GuessListView(),
                  ],
                ),
              );
            case AnagramGameStatus.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
      floatingActionButton: const _NextWordButton(),
    );
  }
}

class _SelectedWord extends StatelessWidget {
  const _SelectedWord();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AnagramBloc, AnagramState, String>(
      selector: (state) => state.currentWord,
      builder: (context, currentWord) {
        return Text.rich(
          TextSpan(
            text: 'Find as many words as possible that can be '
                'formed by adding one letter to ',
            children: [
              TextSpan(
                text: currentWord.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' (but that do not contain the substring'
                    ' ${currentWord.toUpperCase()}).',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnagramsTextField extends StatelessWidget {
  const _AnagramsTextField();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Enter an anagram',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: (value) {
        controller.clear();
        context.read<AnagramBloc>().add(ProcessWord(value));
      },
    );
  }
}

class _GuessListView extends StatelessWidget {
  const _GuessListView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AnagramBloc, AnagramState, List<Word>>(
      selector: (state) => state.guesses,
      builder: (context, guesses) {
        return Column(
          children: guesses.map((word) {
            return ListTile(
              minTileHeight: 0,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: Text(word.value),
              leading: Icon(
                word.isAnagram ? Icons.check : Icons.close,
                color: word.isAnagram ? Colors.green : Colors.red,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _GameResult extends StatelessWidget {
  const _GameResult(this.currentWord, this.result);

  final List<Word> result;
  final String currentWord;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Text(
            'Game Result for $currentWord',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              columns: const [
                DataColumn(label: Text('Possible Anagrams')),
                DataColumn(label: Text('Your Guesses')),
              ],
              rows: result.map((word) {
                return DataRow(
                  cells: [
                    DataCell(Text(word.value)),
                    DataCell(
                      Center(
                        child: Icon(
                          word.isAnagram ? Icons.check : Icons.close,
                          color: word.isAnagram ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _NextWordButton extends StatelessWidget {
  const _NextWordButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocPresentationListener<AnagramBloc, AnagramPresenterEvent>(
      listener: (context, event) {
        if (event is FinishGuess) {
          // show a bottom sheet with the anagrams that were not guessed
          showModalBottomSheet<void>(
            context: context,
            useSafeArea: true,
            builder: (context) {
              return _GameResult(event.currentWord, event.result);
            },
          );
        }
      },
      child: FloatingActionButton.extended(
        onPressed: () async {
          context.read<AnagramBloc>().add(ResetGame());
        },
        label: Text(l10n.nextWordButton),
      ),
    );
  }
}
