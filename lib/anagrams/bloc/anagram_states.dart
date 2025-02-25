part of 'anagram_bloc.dart';

enum AnagramGameStatus {
  initial,
  loaded,
  gameError
}

final class AnagramState extends Equatable {
  const AnagramState({
    this.status = AnagramGameStatus.initial,
    this.words = const [],
    this.currentWord = '',
    this.anagrams = const [],
    this.guesses = const [],
  });

  // The current status of the game
  final AnagramGameStatus status;

  // All the words in the game
  final List<String> words;

  // Currently chosen word of the game to form anagrams
  final String currentWord;

  // All the anagrams for the current word
  final List<String> anagrams;

  // All the guesses user has made
  final List<Word> guesses;

  AnagramState copyWith({
    AnagramGameStatus? status,
    List<String>? words,
    String? currentWord,
    List<String>? anagrams,
    List<Word>? guesses,
  }) {
    return AnagramState(
      status: status ?? this.status,
      words: words ?? this.words,
      currentWord: currentWord ?? this.currentWord,
      anagrams: anagrams ?? this.anagrams,
      guesses: guesses ?? this.guesses,
    );
  }

  @override
  List<Object?> get props => [status, words, currentWord, anagrams, guesses];
}

sealed class AnagramPresenterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class FinishGuess extends AnagramPresenterEvent {
  FinishGuess(this.result, this.currentWord);
  final List<Word> result;
  final String currentWord;

  @override
  List<Object?> get props => [result, currentWord];
}
