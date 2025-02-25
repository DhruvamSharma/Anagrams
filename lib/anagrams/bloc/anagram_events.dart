part of 'anagram_bloc.dart';

sealed class AnagramEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SetupAnagrams extends AnagramEvent {
  SetupAnagrams(this.defaultAssetBundle);

  final AssetBundle defaultAssetBundle;

  @override
  List<Object?> get props => [defaultAssetBundle];
}

final class ProcessWord extends AnagramEvent {
  ProcessWord(this.word);

  final String word;

  @override
  List<Object?> get props => [word];
}

final class ResetGame extends AnagramEvent {}
