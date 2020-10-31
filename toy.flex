import java.util.*;

%%
%class Lexer
%standalone

%{
// Class for tokens
static class Token{
  public static final Token BOOLEAN = build(0, "BOOLEAN");
  public static final Token BREAK = build(1, "BREAK");
  public static final Token CLASS = build(2, "CLASS");
  public static final Token DOUBLE = build(3, "DOUBLE");
  public static final Token ELSE = build(4, "ELSE");
  public static final Token EXTENDS = build(5, "EXTENDS");
  public static final Token FOR = build(6, "FOR");
  public static final Token IF = build(7, "IF");
  public static final Token IMPLEMENTS = build(8, "IMPLEMENTS");
  public static final Token INT = build(9, "INT");
  public static final Token INTERFACE = build(10, "INTERFACE");
  public static final Token NEW = build(11, "NEW");
  public static final Token NEWARRAY = build(12, "NEWARRAY");
  public static final Token NULL = build(13, "NULL");
  public static final Token PRINTLN = build(14, "PRINTLN");
  public static final Token READLN = build(15, "READLN");
  public static final Token RETURN = build(16, "RETURN");
  public static final Token STRING = build(17, "STRING");
  public static final Token VOID = build(18, "VOID");
  public static final Token WHILE = build(19, "WHILE");
  public static final Token PLUS = build(20, "PLUS");
  public static final Token MINUS = build(21, "MINUS");
  public static final Token MULTIPLICATION = build(22, "MULTIPLICATION");
  public static final Token DIVISION = build(23, "DIVISION");
  public static final Token MOD = build(24, "MOD");
  public static final Token LESS = build(25, "LESS");
  public static final Token LESSEQUAL = build(26, "LESSEQUAL");
  public static final Token GREATER = build(27, "GREATER");
  public static final Token GREATEREQUAL = build(28, "GREATEREQUAL");
  public static final Token EQUAL = build(29, "EQUAL");
  public static final Token NOTEQUAL = build(30, "NOTEQUAL");
  public static final Token AND = build(31, "AND");
  public static final Token OR = build(32, "OR");
  public static final Token NOT = build(33, "NOT");
  public static final Token ASSIGNOP = build(34, "ASSIGNOP");
  public static final Token SEMICOLON = build(35, "SEMICOLON");
  public static final Token COMMA = build(36, "COMMA");
  public static final Token PERIOD = build(37, "PERIOD");
  public static final Token LEFTPAREN = build(38, "LEFTPAREN");
  public static final Token RIGHPAREN = build(39, "RIGHPAREN");
  public static final Token LEFTBRACKET = build(40, "LEFTBRACKET");
  public static final Token RIGHTBRACKET = build(41, "RIGHTBRACKET");
  public static final Token LEFTBRACE = build(42, "LEFTBRACE");
  public static final Token RIGHTBRACE = build(43, "RIGHTBRACE");
  public static final Token INTCONSTANT = build(44, "INTCONSTANT");
  public static final Token DOUBLECONSTANT = build(45, "DOUBLECONSTANT");
  public static final Token STRINGCONSTANT = build(46, "STRINGCONSTANT");
  public static final Token BOOLEANCONSTANT = build(47, "BOOLEANCONSTANT");
  public static final Token ID = build(48, "ID");

  private final int tokenid;
  private final String name;

  private Token(int tokenid, String name) {
    this.tokenid = tokenid;
    this.name = name;
  }
  private static Token build(final int tokenid, final String name) {
    final Token token = new Token(tokenid, name);
    return token;
  }

  public int getValue() {
    return tokenid;
  }

  public String toString() {
    return name;
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
boolean {System.out.print("boolean "); return Token.BOOLEAN.getValue();}
break   {System.out.print("break "); return Token.BREAK.getValue();}
class   {System.out.print("class "); return Token.CLASS.getValue();}
double  {System.out.print("double "); return Token.DOUBLE.getValue();}
else   {System.out.print("else "); return Token.ELSE.getValue();}
extends {System.out.print("extends "); return Token.EXTENDS.getValue();}
false   {System.out.print("booleanconstant "); return Token.BOOLEANCONSTANT.getValue();}
for   {System.out.print("for "); return Token.FOR.getValue();}
if   {System.out.print("if "); return Token.IF.getValue();}
implements {System.out.print("implements "); return Token.IMPLEMENTS.getValue();}
int   {System.out.print("int "); return Token.INT.getValue();}
interface   {System.out.print("interface "); return Token.INTERFACE.getValue();}
new {System.out.print("new "); return Token.NEW.getValue();}
newarray   {System.out.print("newarrray "); return Token.NEWARRAY.getValue();}
null   {System.out.print("null "); return Token.NULL.getValue();}
println   {System.out.print("println "); return Token.PRINTLN.getValue();}
readln   {System.out.print("readln "); return Token.READLN.getValue();}
return   {System.out.print("return "); return Token.RETURN.getValue();}
string   {System.out.print("string "); return Token.STRING.getValue();}
true   {System.out.print("booleanconstant "); return Token.BOOLEANCONSTANT.getValue();}
void   {System.out.print("void "); return Token.VOID.getValue();}
while {System.out.print("while "); return Token.WHILE.getValue();}
"+" {System.out.print("plus "); return Token.PLUS.getValue();}
"-" {System.out.print("minus "); return Token.MINUS.getValue();}
"*" {System.out.print("multiplication "); return Token.MULTIPLICATION.getValue();}
"/" {System.out.print("division "); return Token.DIVISION.getValue();}
"%" {System.out.print("mod "); return Token.MOD.getValue();}
"<" {System.out.print("less "); return Token.LESS.getValue();}
"<=" {System.out.print("lessequal "); return Token.LESSEQUAL.getValue();}
">" {System.out.print("greater "); return Token.GREATER.getValue();}
">=" {System.out.print("greaterequal "); return Token.GREATEREQUAL.getValue();}
"==" {System.out.print("equal "); return Token.EQUAL.getValue();}
"!=" {System.out.print("notequal "); return Token.NOTEQUAL.getValue();}
"&&" {System.out.print("and "); return Token.AND.getValue();}
"||" {System.out.print("or "); return Token.OR.getValue();}
"!"  {System.out.print("not "); return Token.NOT.getValue();}
"=" {System.out.print("equal "); return Token.EQUAL.getValue();}
";" {System.out.print("semicolon "); return Token.SEMICOLON.getValue();}
"," {System.out.print("comma "); return Token.COMMA.getValue();}
"." {System.out.print("period "); return Token.PERIOD.getValue();}
"(" {System.out.print("leftparen "); return Token.LEFTPAREN.getValue();}
")" {System.out.print("rightparen "); return Token.RIGHTPAREN.getValue();}
"[" {System.out.print("leftbracket "); return Token.LEFTBRACKET.getValue();}
"]" {System.out.print("rightbracket "); return Token.RIGHTBRACKET.getValue();}
"{" {System.out.print("leftbrace "); return Token.LEFTBRACE.getValue();}
"}" {System.out.print("rightbrace "); return Token.RIGHTBRACE.getValue();}


{NL} {System.out.println();}

{WS} {}

"//".* {System.out.print("comment ");}
"/*" ~"*/" {System.out.print("multi-line-comment ");}

{LETTER}({LETTER}|{DIGIT}|_)* {symbolTable.insert(yytext(), '@');
  System.out.print("identifier "); return Token.ID.getValue();}

{DIGIT}+ {System.out.print("intconstant "); return Token.INTCONSTANT.getValue();}

("0x"|"0X")({HEX})+ {System.out.print("doubleconstant "); return Token.DOUBLECONSTANT.getValue();}

{DIGIT}+"."({DIGIT}*|((E|e)("+"|"-")?{DIGIT}+)) {System.out.print("doubleconstant "); return Token.DOUBLECONSTANT.getValue();}

\"{SL}*\" {System.out.print("stringconstant "); return Token.STRINGCONSTANT.getValue();}
