import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_tdd_clean_fresh/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_){
            controller.clear();
            BlocProvider.of<NumberTriviaBloc>(context).add(
              GetTriviaForConcreteNumber(inputString),
            );
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text('Search'),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green[600]),
                ),
                onPressed: () {
                  controller.clear();
                  BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetTriviaForConcreteNumber(inputString),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: Text('Random Trivia'),
                onPressed: () {
                  controller.clear();
                  BlocProvider.of<NumberTriviaBloc>(context).add(
                    GetTriviaForRandomNumber(),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}