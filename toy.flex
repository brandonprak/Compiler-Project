import java.util.*;

%%
%class Lexer

%{
// Class for tokens
public static class Token{
  public static final int _BOOLEAN = 0;
  public static final int _BREAK = 1;
  public static final int _CLASS = 2;
  public static final int _DOUBLE = 3;
  public static final int _ELSE = 4;
  public static final int _EXTENDS = 5;
  public static final int _FOR = 6;
  public static final int _IF = 7;
  public static final int _IMPLEMENTS = 8;
  public static final int _INT = 9;
  public static final int _INTERFACE = 10;
  public static final int _NEW = 11;
  public static final int _NEWARRAY = 12;
  public static final int _NULL = 13;
  public static final int _PRINTLN = 14;
  public static final int _READLN = 15;
  public static final int _RETURN = 16;
  public static final int _STRING = 17;
  public static final int _VOID = 18;
  public static final int _WHILE = 19;
  public static final int _PLUS = 20;
  public static final int _MINUS = 21;
  public static final int _MULTIPLICATION = 22;
  public static final int _DIVISION = 23;
  public static final int _MOD = 24;
  public static final int _LESS = 25;
  public static final int _LESSEQUAL = 26;
  public static final int _GREATER = 27;
  public static final int _GREATEREQUAL = 28;
  public static final int _EQUAL = 29;
  public static final int _NOTEQUAL = 30;
  public static final int _AND = 31;
  public static final int _OR = 32;
  public static final int _NOT = 33;
  public static final int _ASSIGNOP = 34;
  public static final int _SEMICOLON = 35;
  public static final int _COMMA = 36;
  public static final int _PERIOD = 37;
  public static final int _LEFTPAREN = 38;
  public static final int _RIGHPAREN = 39;
  public static final int _LEFTBRACKET = 40;
  public static final int _RIGHTBRACKET = 41;
  public static final int _LEFTBRACE = 42;
  public static final int _RIGHTBRACE = 43;
  public static final int _INTCONSTANT = 44;
  public static final int _DOUBLECONSTANT = 45;
  public static final int _STRINGCONSTANT = 46;
  public static final int _BOOLEANCONSTANT = 47;
  public static final int _ID = 48;

  private final int type, line;
  private final String value;

  private Token(int type, String value, int line) {
	this.type = type;
	this.value = value;
	this.line = line;
  }
  
  public static Token build(final int type, final String value, final int line) {
	final Token token = new Token(tokenid, value, line);
	return token;
  }
  
  public static Token build(final int type, final int line){
    return build(type, "", line);
  }

  public String getValue() {
	return value;
  }

  public String toString() {
	switch(type){
		case _BOOLEAN:
			return "_boolean";
		case _BREAK:
			return "_break";
		case _CLASS:
			return "_class";
		case _DOUBLE:
			return "_double";
		case _ELSE:
			return "_else";
		case _EXTENDS:
			return "_extends";
		case _FOR:
			return "_for";
		case _IF:
			return "_if";
		case _IMPLEMENTS:
			return "_implements";
		case _INT:
			return "_int";
		case _INTERFACE:
			return "_interface";
		case _NEW:
			return "_new";
		case _NEWARRAY:
			return "_newarray";
		case _NULL:
			return "_null";
		case _PRINTLN:
			return "_println";
		case _READLN:
			return "_readln";
		case _RETURN:
			return "_return";
		case _STRING:
			return "_string";
		case _VOID:
			return "_void";
		case _WHILE:
			return "_while";
		case _PLUS:
			return "_plus";
		case _MINUS:
			return "_minus";
		case _MULTIPLICATION:
			return "_multiplication";
		case _DIVISION:
			return "_division";
		case _MOD:
			return "_mod";
		case _LESS:
			return "_less";
		case _LESSEQUAL:
			return "_lessequal";
		case _GREATER:
			return "_greater";
		case _GREATEREQUAL:
			return "_greaterequal";
		case _EQUAL:
			return "_equal";
		case _NOTEQUAL:
			return "_notequal";
		case _AND:
			return "_and";
		case _OR:
			return "_or";
		case _NOT:
			return "_not";
		case _ASSIGNOP:
			return "_assignop";
		case _SEMICOLON:
			return "_semicolon";
		case _COMMA:
			return "_comma";
		case _PERIOD:
			return "_period";
		case _LEFTPAREN:
			return "_leftparen";
		case _RIGHPAREN:
			return "_righparen";
		case _LEFTBRACKET:
			return "_leftbracket";
		case _RIGHTBRACKET:
			return "_rightbracket";
		case _LEFTBRACE:
			return "_leftbrace";
		case _RIGHTBRACE:
			return "_rightbrace";
		case _INTCONSTANT:
			return "_intconstant";
		case _DOUBLECONSTANT:
			return "_doubleconstant";
		case _STRINGCONSTANT:
			return "_stringconstant";
		case _BOOLEANCONSTANT:
			return "_booleanconstant";
		case _ID:
			return "_id";
		default:
			return "__unknown";

	}
  }

}


public Trie<String> symbolTable = new Trie<>(); //String for now, can change later

private boolean done = false, error = false;

private StringBuilder sLiteral = new StringBuilder();

int currentLine = 1;

public boolean isDone(){
	return done;
}

public boolean errorOccurred(){
	return error;
}

%}

%init{
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
%init}



%eof{
  done = true;
%eof}

DIGIT=[0-9]
LETTER=[A-Za-z]
HEX=[0-9]|[A-Fa-f]
NL=\r|\n|\r\n
WS= {NL}|[" "\t\f]
SL=[^\r\n\"] //String Literal characters

DECLITERAL={DIGIT}+
HEXLITERAL=0x{HEX}+


DBLLITERAL={DIGIT}+"."({DIGIT}*|((E|e)("+"|"-")?{DIGIT}+))

IDENT=[A-Za-z_][0-9A-Za-z_]*

OCTAL=[0-7]
OCTESCAPE=\\({OCTAL}|{OCTAL}{OCTAL}|[0-3]{OCTAL}{OCTAL})

SLCOMMENT="//".*
MLCOMMENT="/*" ~"*/"

COMMENT={SLCOMMENT}|{MLCOMMENT}

%state STRINGLITERAL

%%

<YYINITIAL> {
	"boolean" {return Token.build(Token._BOOLEAN, currentLine);}
	"break"   {return Token.build(Token._BREAK, currentLine);}
	"class"   {return Token.build(Token._CLASS, currentLine);}
	"double"  {return Token.build(Token._DOUBLE, currentLine);}
	"else"   {return Token.build(Token._ELSE, currentLine);}
	"extends" {return Token.build(Token._EXTENDS, currentLine);}
	"false"   {return Token.build(Token._BOOLEANCONSTANT, "false", currentLine);}
	"for"   {return Token.build(Token._FOR, currentLine);}
	"if"   {return Token.build(Token._IF, currentLine);}
	"implements" {return Token.build(Token._IMPLEMENTS, currentLine);}
	"int"   {return Token.build(Token._INT, currentLine);}
	"interface"   {return Token.build(Token._INTERFACE, currentLine);}
	"new" {return Token.build(Token._NEW, currentLine);}
	"newarray"   {return Token.build(Token._NEWARRAY, currentLine);}
	"null"   {return Token.build(Token._NULL, currentLine);}
	"println"   {return Token.build(Token._PRINTLN, currentLine);}
	"readln"   {return Token.build(Token._READLN, currentLine);}
	"return"   {return Token.build(Token._RETURN, currentLine);}
	"string"   {return Token.build(Token._STRING, currentLine);}
	"true"   {return Token.build(Token._BOOLEANCONSTANT, "true", currentLine);}
	"void"   {return Token.build(Token._VOID, currentLine);}
	"while" {return Token.build(Token._WHILE, currentLine);}
	"+" {return Token.build(Token._PLUS, currentLine);}
	"-" {return Token.build(Token._MINUS, currentLine);}
	"*" {return Token.build(Token._MULTIPLICATION, currentLine);}
	"/" {return Token.build(Token._DIVISION, currentLine);}
	"%" {return Token.build(Token._MOD, currentLine);}
	"<" {return Token.build(Token._LESS, currentLine);}
	"<=" {return Token.build(Token._LESSEQUAL, currentLine);}
	">" {return Token.build(Token._GREATER, currentLine);}
	">=" {return Token.build(Token._GREATEREQUAL, currentLine);}
	"==" {return Token.build(Token._EQUAL, currentLine);}
	"!=" {return Token.build(Token._NOTEQUAL, currentLine);}
	"&&" {return Token.build(Token._AND, currentLine);}
	"||" {return Token.build(Token._OR, currentLine);}
	"!"  {return Token.build(Token._NOT, currentLine);}
	"=" {return Token.build(Token._EQUAL, currentLine);}
	", currentLine);" {return Token.build(Token._SEMICOLON, currentLine);}
	"," {return Token.build(Token._COMMA, currentLine);}
	"." {return Token.build(Token._PERIOD, currentLine);}
	"(" {return Token.build(Token._LEFTPAREN, currentLine);}
	")" {return Token.build(Token._RIGHTPAREN, currentLine);}
	"[" {return Token.build(Token._LEFTBRACKET, currentLine);}
	"]" {return Token.build(Token._RIGHTBRACKET, currentLine);}
	"{" {return Token.build(Token._LEFTBRACE, currentLine);}
	"}" {return Token.build(Token._RIGHTBRACE, currentLine);}


	{NL} {currentLine++;}

	{WS} {}

	{COMMENT} {}

	{IDENT} {String s = yytext(); symbolTable.reserve(s); return Token.build(Token._ID, s, currentLine);}

	{DECLITERAL} {return Token.build(Token._INTCONSTANT, yytext(), currentLine);}

	{HEXLITERAL} {String s = yytext(); s = Integer.decode(s).toString(); return Token.build(Token._INTCONSTANT, s, currentLine);}

	{DBLLITERAL} {return Token.build(Token._DOUBLECONSTANT, yytext(), currentLine);}
	
	\"	{yybegin(STRINGLITERAL);}
}

<STRINGLITERAL> {
	\"	{String s = sLiteral.toString(); sLiteral = new StringBuilder(); yybegin(YYINITIAL); return Token.build(Token._STRINGCONSTANT, s, currentLine);}
	
	([^\n\r\"\\] | !{OCTESCAPE})+	{sLiteral.append(yytext());}	/*not sure about this regex*/
	
	\\n	{sLiteral.append('\n');}
	\\r	{sLiteral.append('\r');}
	\\t	{sLiteral.append('\t');}
	\\	{sLiteral.append('\\');}
	\\\"	{sLiteral.append('\"');}
	
	{OCTESCAPE}	{char c = (char)Integer.parseInt(yytext().substring(1), 8).intValue(); sLiteral.append(c);}
}

[^]	{error = true;}