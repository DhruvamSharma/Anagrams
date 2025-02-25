import 'dart:async';
import 'dart:convert';

import 'package:anagrams/anagrams/domain/word.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'anagram_events.dart';

part 'anagram_states.dart';

class AnagramBloc extends Bloc<AnagramEvent, AnagramState>
    with BlocPresentationMixin<AnagramState, AnagramPresenterEvent> {
  AnagramBloc() : super(const AnagramState()) {
    on<SetupAnagrams>(_onSetupAnagrams);
    on<ProcessWord>(_onProcessWord);
    on<ResetGame>(_onResetGame);
  }

  Future<void> _onSetupAnagrams(
    SetupAnagrams event,
    Emitter<AnagramState> emit,
  ) async {
    try {
      // this should not be done here,
      // but for the sake of simplicity, we will do it here
      final wordsFile =
          await event.defaultAssetBundle.loadString('assets/words.txt');
      // read each line in the file
      final words = const LineSplitter().convert(wordsFile);
      final starterWord = _pickGoodStarterWord();
      // change the state of the game
      emit(
        state.copyWith(
          status: AnagramGameStatus.loaded,
          words: words,
          currentWord: starterWord,
          anagrams: _getAnagrams(starterWord),
          guesses: [],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AnagramGameStatus.gameError,
        ),
      );
    }
  }

  Future<void> _onProcessWord(
    ProcessWord event,
    Emitter<AnagramState> emit,
  ) async {
    try {
      final word = event.word.trim().toLowerCase();
      if (word.isEmpty) {
        return;
      }
      if (_isGoodWord(word) && state.anagrams.contains(word)) {
        // remove the word from the list of anagrams
        // add the word to the list of guesses
        emit(
          state.copyWith(
            anagrams: state.anagrams..remove(word),
            guesses: [...state.guesses, Word(word, isAnagram: true)],
          ),
        );
      } else {
        emit(
          state.copyWith(
            guesses: [...state.guesses, Word(word)],
          ),
        );
      }
    } catch (e) {
      // show an error message
    }
  }

  FutureOr<void> _onResetGame(ResetGame event, Emitter<AnagramState> emit) {
    final starterWord = _pickGoodStarterWord();
    emitPresentation(FinishGuess(_result, state.currentWord));
    emit(
      state.copyWith(
        status: AnagramGameStatus.loaded,
        currentWord: starterWord,
        anagrams: _getAnagrams(starterWord),
        guesses: [],
      ),
    );
  }

  List<Word> get _result {
    // All the anagrams that were not guessed
    final notGuessedAnagrams =
        state.anagrams.map(Word.new).toList();
    // All the guesses that were made
    final guesses = state.guesses.where((word) => word.isAnagram).toList();
    // return the list of anagrams that were not guessed
    return [...guesses, ...notGuessedAnagrams];
  }

  /// create a function to find all the anagrams of the target word
  List<String> _getAnagrams(String targetWord) {
    // find all the anagrams of the target word
    final anagrams = <String>[];

    // return the list of anagrams
    return anagrams;
  }

  /// Picks a good starter word for the game.
  String _pickGoodStarterWord() {
    // ignore: omit_local_variable_types
    String word = 'skate';

    return word;
  }

  /// Checks if the word is a good word.
  bool _isGoodWord(String word) {
    return true;
  }
}
