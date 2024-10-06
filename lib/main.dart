import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentDisplay = '0';
  List<String> _currentInput = []; // Creates a stack that stores the current input
  List<String> _operatorsStack = []; // Creates a stack for the operators
  List<int> _operandsStack = []; // Creates a stack for the operands

  int _operations(String oper, int a, int b) { // The operations occurs here
    switch (oper) {
      case '+': 
        return b + a;
      case '-':
        return b - a;
      case '*':
        return b * a;
      case '/':
        if (a == 0) {
          _currentDisplay = "Error";
          return 0; // This occurs due to dividing by 0
        } else {
          return b ~/ a;
        }
      default:
        return 0;
    }
  }

  int _precedence(String operator) { // Checks to verify precedence between operators to see which is handled first
    if (operator == '+' || operator == '-') {
      return 0;
    } else {
      return 1;
    }
  }

  void _calculate() {
    if (_currentInput.isEmpty) return; // If there is nothing in the stack, ntohing occurs

    if (_currentInput.isNotEmpty && _currentInput.last.isNotEmpty) {
      _operandsStack.add(int.parse(_currentInput.last));
      _currentInput.clear();
    }

    while (_operatorsStack.isNotEmpty) {
      String operator = _operatorsStack.removeLast();
      int operandB = _operandsStack.removeLast();
      int operandA = _operandsStack.removeLast();
      int res = _operations(operator, operandA, operandB);
      _operandsStack.add(res);
    }

    setState(() {
      _currentDisplay = _operandsStack.isNotEmpty ? _operandsStack.last.toString() : '0';
    });

  }

  void _Buttons(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _currentDisplay = '0';
        _currentInput.clear();
        _operatorsStack.clear();
        _operandsStack.clear();
      } else if (buttonText == '=') {
        _calculate();
      } else if (['+', '-', '*', '/'].contains(buttonText)) {
        if (_currentInput.isNotEmpty && _currentInput.last.isNotEmpty) {
          _operandsStack.add(int.parse(_currentInput.last));
          _currentInput.clear();
        }
        while (_operatorsStack.isNotEmpty &&
            _precedence(_operatorsStack.last) >= _precedence(buttonText)) {
          String operator = _operatorsStack.removeLast();
          int operandB = _operandsStack.removeLast();
          int operandA = _operandsStack.removeLast();
          int result = _operations(operator, operandA, operandB);
          _operandsStack.add(result);
        }
        _operatorsStack.add(buttonText);
      } else {
        if (_currentInput.isEmpty || _currentInput.last.isEmpty) {
          _currentInput.add(buttonText);
        } else {
          _currentInput.last += buttonText;
        }
        _currentDisplay = _currentInput.join();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the column's content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Align(
            alignment: Alignment.center,
            child: Text(
              _currentDisplay,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
            itemCount: 16,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _Button('7');
                  case 1:
                    return _Button('8');
                  case 2:
                    return _Button('9');
                  case 3:
                    return _Button('/');
                  case 4:
                    return _Button('4');
                  case 5:
                    return _Button('5');
                  case 6:
                    return _Button('6');
                  case 7:
                    return _Button('*');
                  case 8:
                    return _Button('1');
                  case 9:
                    return _Button('2');
                  case 10:
                    return _Button('3');
                  case 11:
                    return _Button('-');
                  case 12:
                    return _Button('0');
                  case 13:
                    return _Button('.');
                  case 14:
                    return _Button('C');
                  case 15:
                    return _Button('+');
                  default:
                    return Container();
                }
              },
            ),
            ElevatedButton(
              onPressed: () => _Buttons('='),
              child: const Text('='),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        )
        
        )
    );
  }
  Widget _Button(String label) {
    return ElevatedButton(
      onPressed: () => _Buttons(label),
      child: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Make the buttons square by setting borderRadius to zero
        ),
      ),
    );
  }
}

// The idea for the calculator using stacks was from an assignment I had to do when I took Data Structures
// Below is the code I translated over as I could 
/*
# Jonathan Morales
# 03/08/2024
# CRN 13930

# Test Cases
# If input equals None
# if input == None:
#     print("The input given is None, please give a proper input")
#     return

# If input has only a length of 1
# Items = input.split()
# if len(Items) == 1:
#     print("There is only one item in the input, not much can be done with that")
#     return

# If the input is only operands(interchangeable with operators)
# located after the for loop is finished before the while loop which handles leftover
# if len(OperatorsStack) == 0:
#     print("There is only operands in the input, please add some operators...")

def Operations(Oper, A, B): # This function contains all simple arithmetic operations, such as addition, subtraction, multiplication, and divison
    if Oper == "+": # If the function is called, the element in the OperatorsStack is checked with 4 if statements
        res = B + A # If the Operators fulfills one of the 4 ifs, its respective operation is done and the result is returned to be appened back on the OperandsStack
        return res
    if Oper == "-":
        res = B - A
        return res
    if Oper == "*":
        res = B * A
        return res
    if Oper == "/":
        res = B / A
        return res
    

def Precedence(Operator): # This function checks the precedence of element taken from the OperatorsStack or from the input itself
    if Operator in ["+", "-"]:
        return 0
    else: # The else represents multiplication and divison which returns a 1 since in order of operations, these 2 take priority over addition and subtraction
        return 1 
    
def Calculator(input): # This is the main function while creates the 2 stacks used, and contains the loops and conditional statements needed

    OperatorsStack = [] # This stack holds the operators taken out of the input
    OperandsStack = [] # This stack holds the operands(integers) taken out of the input

    Items = input.split() # .split() alleivates the issue of spaces in the input by creating a list with each operand and operator in the input as elements in said list

    Operators = ["+", "-", "*", "/"] # A variable to created to ease the process of identifying operators in the Items list

    for i in Items: # This for loop go through Items checking whether the current element is a operator or operands every iteration
        if i in Operators: # This If statements checks if the current element is within the Operators variable

            while (OperatorsStack and Precedence(OperatorsStack[-1]) > Precedence(i)): # If the i is in Operators, this while loop is trigger
                # The loops works by checking if OperatorsStack has atleast 1 element and if said element has greater precedence that then current
                # If pasted, the 3 variables are made containing the OperatorsStack element and 2 OperandsStack elements which are used as parameters placed in Operations()
                Op = OperatorsStack.pop()
                A = OperandsStack.pop()
                B = OperandsStack.pop()
                res = Operations(Op, A, B)
                OperandsStack.append(res) # The result after the 3 variables were used a parameters is appended back onto the stack
            OperatorsStack.append(i) # Even if the loop isn't trigger the current i as long as its a operator will be appened to the stack
            
        else:
            OperandsStack.append(int(i)) # If the i isn't in Operators then it is a operand which is appended to OperandsStack
    
    while (OperatorsStack): # The loop occurs after the for loop is finished it handles all leftover operands and operators, its similar to other while loop, but precedence isn't included
        Op = OperatorsStack.pop() 
        A = OperandsStack.pop()
        B = OperandsStack.pop()
        res = Operations(Op, A, B)
        OperandsStack.append(res)

    return OperandsStack.pop() # Once all loops and functions have ran, the function returns the remaining operand in OperandsStack

input = "10 * 2 - 15"
print(Calculator(input))

# Deque
# I believe that using a deque interface instead of the stacks I used for my solution will do not much difference
# Even though a deque is more flexible allowing me to append left and right in addition to popping due it not having a restriction of LIFO or FIFO
# A deque would help out if I wanted to add more flexible or complex features, but for simple operations such as the ones used in the code a stack works fine
# I don't think the time or space complexity will change much as well since, deque also have a space complexity of O(n) same as stacks and queues and doesn't affect time as much

# The time and space complexity for the entirety of the code is O(n)
*/