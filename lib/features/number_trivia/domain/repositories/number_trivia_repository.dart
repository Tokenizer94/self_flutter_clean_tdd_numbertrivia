import 'package:dartz/dartz.dart';
import 'package:self_tdd_clean_fresh/core/error/failures.dart';

import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}