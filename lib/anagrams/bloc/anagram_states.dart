part of 'anagram_bloc.dart';

enum AnagramGameStatus { initial, loaded, gameError }

const minNumAnagrams = 5;
const defaultWordLength = 3;
const maxDefaultWordLength = 7;

@immutable
final class AnagramState extends Equatable {
  factory AnagramState({
    AnagramGameStatus status = AnagramGameStatus.initial,
    List<String> words = const [],
    String currentWord = '',
    List<String> anagrams = const [],
    List<Word> guesses = const [],
    HashSet<String>? wordSet,
    HashMap<String, List<String>>? anagramMap,
    HashMap<int, List<String>>? sizeToWords,
    int wordLength = defaultWordLength,
  }) {
    return AnagramState._(
      status: status,
      words: words,
      currentWord: currentWord,
      anagrams: anagrams,
      guesses: guesses,
      wordSet: wordSet ?? HashSet<String>(),
      anagramMap: anagramMap ?? HashMap<String, List<String>>(),
      sizeToWords: sizeToWords ?? HashMap<int, List<String>>(),
      wordLength: wordLength,
    );
  }
  const AnagramState._({
    required this.status,
    required this.words,
    required this.currentWord,
    required this.anagrams,
    required this.guesses,
    required this.wordSet,
    required this.anagramMap,
    required this.sizeToWords,
    this.wordLength = defaultWordLength,
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

  // A set of all the words in the game
  final HashSet<String> wordSet;

  // A map of anagrams for each word
  final HashMap<String, List<String>> anagramMap;

  // Stores the words in increasing order of their length
  final HashMap<int, List<String>> sizeToWords;

  final int wordLength;

  AnagramState copyWith({
    AnagramGameStatus? status,
    List<String>? words,
    String? currentWord,
    List<String>? anagrams,
    List<Word>? guesses,
    HashSet<String>? wordSet,
    HashMap<String, List<String>>? anagramMap,
    HashMap<int, List<String>>? sizeToWords,
    int? wordLength,
  }) {
    return AnagramState(
      status: status ?? this.status,
      words: words ?? this.words,
      currentWord: currentWord ?? this.currentWord,
      anagrams: anagrams ?? this.anagrams,
      guesses: guesses ?? this.guesses,
      wordSet: wordSet ?? this.wordSet,
      anagramMap: anagramMap ?? this.anagramMap,
      sizeToWords: sizeToWords ?? this.sizeToWords,
      wordLength: wordLength ?? this.wordLength,
    );
  }

  @override
  List<Object?> get props => [
    status,
    words,
    currentWord,
    anagrams,
    guesses,
    wordSet,
    anagramMap,
    sizeToWords,
    wordLength,
  ];
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
