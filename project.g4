grammar project;
//******************************** Parser Rules *********************************************************************
start: require* myClass+;

require: req1 | req2 | req3 ;
req1: ValidName '=' 'require' ValidName Semicolon;
req2: ValidName '=' 'from' ValidName 'require' ValidName Semicolon;
req3: ValidName (',' ValidName)* '=' 'from' ValidName ('=>'|'require') ValidName (',' 'from'  ValidName ('=>'|'require') ValidName )* Semicolon;

defineVariable: AccessVariable? CONST? dataType? ValidName (variable | defineArray | obj_define) Semicolon;
variable:  ('=' (value))? (',' ValidName ('=' (value))?)*;
defineArray: defArr1 | defArr2 | defArr3;
defArr1:  '[]' ('=' 'new' dataType '[' Int ']')?;
defArr2: '[]' ('=' '[' (value) (',' (value))* ']')?;
defArr3: '[]' '=' '[]' ;
obj_define : ValidName '='? ValidName '('? (((value))(','(value))* )? ')'? ;

myClass: AccessVariable? 'class' ValidName ('(' ValidName? ')') (('Implements' | 'implements') ValidName (',' ValidName)*)? 'begin' classBody 'end';
classBody: (function | constructor | defineVariable)*;
constructor: AccessVariable? ValidName '('(dataType ValidName)(','dataType  ValidName)*')' 'begin' (('this.'? ValidName '=' ValidName Semicolon) ('this.'? ValidName '=' ValidName Semicolon)*)?'end';

function: AccessVariable? dataType? ValidName ('('dataType? ValidName?(',' dataType ValidName)*')')? 'begin' code* (('return' (value|ValidName|ternary|phrase) Semicolon)*)? 'end';

condition: if | elif | else | ternary;
if: 'if' '('phrase')' 'begin' code* 'end';
elif: 'else' 'if' '('phrase')' 'begin' code* 'end';
else: 'else' 'begin' code* 'end';
ternary: ValidName? '='? (phrase | value) '?' (phrase | value) ':' (phrase | value) Semicolon?;

switchCase: 'switch' ValidName 'begin' ('case' (value) ':' (code | Print)* ('break' Semicolon )? )* ('default' ':' (Print)* ('break' Semicolon)? )? 'end';

phrase: '(' phrase ')'
        |phrase '**' phrase
        |'~' phrase
        |('-' | '+') phrase
        |(preSign | postSign)
        |phrase ('*' | '/' | '//' | '%') phrase
        |phrase ('-' | '+') phrase
        |phrase ('<<' | '>>') phrase
        |phrase ('&' | '^' | '|') phrase
        |phrase ('==' | '!=' | '<>') phrase
        |phrase ('<' | '>' | '<=' | '>=') phrase
        |phrase ('not' | 'and' | 'or' | '||' | '&&') phrase
        |phrase ('=' | '*=' | '//=' | '+=' | '-=' | '/=') phrase
        |micro
        |ValidName
        |value;
preSign: ('++' | '--') ValidName;
postSign: ValidName ('++' | '--');
micro: (('+' | '-')? Int) | ValidName;

loop: for | while | doWhile | infor;
for: 'for' forIn 'begin' code* 'end';
forIn: '('dataType? ValidName '=' (value|ValidName) Semicolon phrase (('or'|'and') phrase)? Semicolon (preSign | postSign) ')';
infor:'for' ValidName 'in' ValidName 'begin' code* 'end';
while: 'while' '('phrase')' 'begin' code* 'end';
doWhile: 'do' 'begin' code* 'end' 'while' '('phrase')';

exeption: 'try' 'begin' code* 'end' 'catch' '(' ValidName  (',' ValidName)* ')' 'begin' code* 'end';

code: defineVariable | loop | condition | switchCase | function | exeption | constructor | Print |(phrase Semicolon) ;
value: (Char | Int | Double | String | Bool | Float | ScientificNotation | Null);
dataType: ('char' | 'int' | 'Int' | 'double' | 'string' | 'bool' | 'float');
//*********************************** Lexer Rules *******************************************************************
fragment Letter: [A-Za-z];
fragment Digit: [0-9];
fragment LetterDigit: [A-Za-z0-9];

Print: 'print' '('('"'.*?'"')')' Semicolon;
Semicolon: ';';
DoubleQuotation: '"';
AccessVariable: 'public' | 'private';
CONST: 'const';
Char: '\'' Letter '\'';
Int: ('+' | '-')? ([1-9]Digit* | Digit);
Double: ('+' | '-')? (Digit* '.' Digit+);
String: '"'.*?'"';
Bool: 'true' | 'false';
Float: ('+' | '-')? (Digit* '.' Digit+);
ScientificNotation: ('+' | '-')? (Digit* '.' Digit+) ('e' | 'E') '-' ([1-9]Digit* | Digit);
Null: 'null' | 'Null';
ValidName: (Letter | '$')(Digit | Letter | '$' | '_')+;
WS: ('\t' | '\r' | '\n' | ' ' )+ -> skip;
SINGLE_LINE_COMMENT: '//' (~('\r' | '\n'))*-> skip;
MULTI_LINE_COMMENT: '/*' .*? '*/' -> skip;