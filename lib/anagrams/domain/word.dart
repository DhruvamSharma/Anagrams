import 'package:equatable/equatable.dart';

class Word extends Equatable {

  const Word(this.value, {this.isAnagram = false});
  final String value;
  final bool isAnagram;

  Word markAsAnagram() {
    return Word(value, isAnagram: true);
  }

  @override
  List<Object?> get props => [value];

}