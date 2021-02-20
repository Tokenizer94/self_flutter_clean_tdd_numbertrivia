import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:self_tdd_clean_fresh/core/error/failures.dart';
import 'package:self_tdd_clean_fresh/core/usecases/usecase.dart';
import 'package:self_tdd_clean_fresh/core/util/input_converter.dart';
import 'package:self_tdd_clean_fresh/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:self_tdd_clean_fresh/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:self_tdd_clean_fresh/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:self_tdd_clean_fresh/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc numberTriviaBloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    numberTriviaBloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  tearDown(() {
    numberTriviaBloc.close();
  });

  test('initialState should be empty', () {
    //assert
    expect(numberTriviaBloc.state, Empty());
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));

    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async* {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
      //assert later
      expectLater(
        numberTriviaBloc.state,
        emitsInOrder(
          [
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ],
        ),
      );
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with a proper message for the error when getting data fails', () async* {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      //assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async* {
      //arrange
      when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] with a proper message for the error when getting data fails', () async* {
      //arrange
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(numberTriviaBloc.state, emitsInOrder(expected));
      //act
      numberTriviaBloc.add(GetTriviaForRandomNumber());
    });
  });
}
