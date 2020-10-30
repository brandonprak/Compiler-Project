import java.util.*;

%%
%class Lexer
%standalone

%{

// Enumerator for tokens
enum token {
  _boolean(0),
  _break(1),
  _class(2),
  _double(3),
  _else(4),
  _extends(5),
  _for(6),
  _if(7),
  _implements(8),
  _int(9),
  _interface(10),
  _new(11),
  _newarray(12),
  _null(13),
  _println(14),
  _readln(15),
  _return(16),
  _string(17),
  _void(18),
  _while(19),
  _plus(20),
  _minus(21),
  _multiplication(22),
  _division(23),
  _mod(24),
  _less(25),
  _lessequal(26),
  _greater(27),
  _greaterequal(28),
  _equal(29),
  _notequal(30),
  _and(31),
  _or(32),
  _not(33),
  _assignop(34),
  _semicolon(35),
  _comma(36),
  _period(37),
  _leftparen(38),
  _rightparen(39),
  _leftbracket(40),
  _rightbracket(41),
  _leftbrace(42),
  _rightbrace(43),
  _intconstant(44),
  _doubleconstant(45),
  _stringconstant(46),
  _booleanconstant(47),
  _id(48);

  private final int tokenid;

  private token(int tokenid) {
   this.tokenid = tokenid;
  }

  public int getValue(){
    return tokenid;
  }
}

Trie<String> symbolTable = new Trie<>(); //String for now, can change later

symbolTable.reserve("boolean");
symbolTable.reserve("break");
symbolTable.reserve("class");
symbolTable.reserve("double");
symbolTable.reserve("else");
symbolTable.reserve("extends");
symbolTable.reserve("false");
symbolTable.reserve("for");
symbolTable.reserve("if");
symbolTable.reserve("implements");
symbolTable.reserve("int");
symbolTable.reserve("interface");
symbolTable.reserve("new");
symbolTable.reserve("newarray");
symbolTable.reserve("null");
symbolTable.reserve("println");
symbolTable.reserve("readln");
symbolTable.reserve("return");
symbolTable.reserve("string");
symbolTable.reserve("true");
symbolTable.reserve("void");
symbolTable.reserve("while");


%}

%eof{
  System.out.println(symbolTable);
%eof}

DIGIT=[0-9]
LETTER=[A-Za-z]
HEX=[0-9]|[A-Fa-f]
NL=\r|\n|\r\n
WS= {NL}|[" "\t\f]
SL=[^\r\n\"] //String Literal characters

%%
boolean {System.out.print("boolean "); return token._boolean.getValue();}
break   {System.out.print("break "); return token._break.getValue();}
class   {System.out.print("class "); return token._class.getValue();}
double  {System.out.print("double "); return token._double.getValue();}
else   {System.out.print("else "); return token._else.getValue();}
extends {System.out.print("extends "); return token._extends.getValue();}
false   {System.out.print("booleanconstant "); return token._booleanconstant.getValue();}
for   {System.out.print("for "); return token._for.getValue();}
if   {System.out.print("if "); return token._if.getValue();}
implements {System.out.print("implements "); return token._implements.getValue();}
int   {System.out.print("int "); return token._int.getValue();}
interface   {System.out.print("interface "); return token._interface.getValue();}
new {System.out.print("new "); return token._new.getValue();}
newarray   {System.out.print("newarrray "); return token._newarray.getValue();}
null   {System.out.print("null "); return token._null.getValue();}
println   {System.out.print("println "); return token._println.getValue();}
readln   {System.out.print("readln "); return token._readln.getValue();}
return   {System.out.print("return "); return token._return.getValue();}
string   {System.out.print("string "); return token._string.getValue();}
true   {System.out.print("booleanconstant "); return token._booleanconstant.getValue();}
void   {System.out.print("void "); return token._void.getValue();}
while {System.out.print("while "); return token._while.getValue();}
"+" {System.out.print("plus "); return token._plus.getValue();}
"-" {System.out.print("minus "); return token._minus.getValue();}
"*" {System.out.print("multiplication "); return token._multiplication.getValue();}
"/" {System.out.print("division "); return token._division.getValue();}
"%" {System.out.print("mod "); return token._mod.getValue();}
"<" {System.out.print("less "); return token._less.getValue();}
"<=" {System.out.print("lessequal "); return token._lessequal.getValue();}
">" {System.out.print("greater "); return token._greater.getValue();}
">=" {System.out.print("greaterequal "); return token._greaterequal.getValue();}
"==" {System.out.print("equal "); return token._equal.getValue();}
"!=" {System.out.print("notequal "); return token._notequal.getValue();}
"&&" {System.out.print("and "); return token._and.getValue();}
"||" {System.out.print("or "); return token._or.getValue();}
"!"  {System.out.print("not "); return token._not.getValue();}
"=" {System.out.print("equal "); return token._equal.getValue();}
";" {System.out.print("semicolon "); return token._semicolon.getValue();}
"," {System.out.print("comma "); return token._comma.getValue();}
"." {System.out.print("period "); return token._period.getValue();}
"(" {System.out.print("leftparen "); return token._leftparen.getValue();}
")" {System.out.print("rightparen "); return token._rightparen.getValue();}
"[" {System.out.print("leftbracket "); return token._leftbracket.getValue();}
"]" {System.out.print("rightbracket "); return token._rightbracket.getValue();}
"{" {System.out.print("leftbrace "); return token._leftbrace.getValue();}
"}" {System.out.print("rightbrace "); return token._rightbrace.getValue();}


{NL} {System.out.println();}

{WS} {}

"//".* {System.out.print("comment ");}
"/*" ~"*/" {System.out.print("multi-line-comment ");}

{LETTER}({LETTER}|{DIGIT}|_)* {symbolTable.insert(yytext(), '@');
  System.out.print("identifier "); return token._id.getValue();}

{DIGIT}+ {System.out.print("intconstant "); return token._intconstant.getValue();}

("0x"|"0X")({HEX})+ {System.out.print("doubleconstant "); return token._doubleconstant.getValue();}

{DIGIT}+"."({DIGIT}*|((E|e)("+"|"-")?{DIGIT}+)) {System.out.print("doubleconstant "); return token._doubleconstant.getValue();}

\"{SL}*\" {System.out.print("stringconstant "); return token._stringconstant.getValue();}
