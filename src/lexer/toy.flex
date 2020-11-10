package lexer;

import java.util.*;

import common.*;

%%
%class Lexer
%type Token
%eofclose
%public
%implements TokenTypeID

%{
// Class for tokens
public static class Token{
	private final int type, line;
	private final String value;

	private Token(int type, String value, int line) {
		this.type = type;
		this.value = value;
		this.line = line;
	}
	
	public static Token build(final int type, final String value, final int line) {
		final Token token = new Token(type, value, line);
		return token;
	}
	
	public static Token build(final int type, final int line){
		return build(type, null, line);
	}

	public String getValue() {
		return value;
	}
	
	public int getLineNumber(){
		return line;
	}

	public String toString() {
		switch(type){
			case _BOOLEAN:
				return "boolean";
			case _BREAK:
				return "break";
			case _CLASS:
				return "class";
			case _DOUBLE:
				return "double";
			case _ELSE:
				return "else";
			case _EXTENDS:
				return "extends";
			case _FOR:
				return "for";
			case _IF:
				return "if";
			case _IMPLEMENTS:
				return "implements";
			case _INT:
				return "int";
			case _INTERFACE:
				return "interface";
			case _NEW:
				return "new";
			case _NEWARRAY:
				return "newarray";
			case _NULL:
				return "null";
			case _PRINTLN:
				return "println";
			case _READLN:
				return "readln";
			case _RETURN:
				return "return";
			case _STRING:
				return "string";
			case _VOID:
				return "void";
			case _WHILE:
				return "while";
			case _PLUS:
				return "plus";
			case _MINUS:
				return "minus";
			case _MULTIPLICATION:
				return "multiplication";
			case _DIVISION:
				return "division";
			case _MOD:
				return "mod";
			case _LESS:
				return "less";
			case _LESSEQUAL:
				return "lessequal";
			case _GREATER:
				return "greater";
			case _GREATEREQUAL:
				return "greaterequal";
			case _EQUAL:
				return "equal";
			case _NOTEQUAL:
				return "notequal";
			case _AND:
				return "and";
			case _OR:
				return "or";
			case _NOT:
				return "not";
			case _ASSIGNOP:
				return "assignop";
			case _SEMICOLON:
				return "semicolon";
			case _COMMA:
				return "comma";
			case _PERIOD:
				return "period";
			case _LEFTPAREN:
				return "leftparen";
			case _RIGHTPAREN:
				return "rightparen";
			case _LEFTBRACKET:
				return "leftbracket";
			case _RIGHTBRACKET:
				return "rightbracket";
			case _LEFTBRACE:
				return "leftbrace";
			case _RIGHTBRACE:
				return "rightbrace";
			case _INTCONSTANT:
				return "intconstant";
			case _DOUBLECONSTANT:
				return "doubleconstant";
			case _STRINGCONSTANT:
				return "stringconstant";
			case _BOOLEANCONSTANT:
				return "booleanconstant";
			case _ID:
				return "id";
			case _ERROR:
				return "error";
			default:
				return "unknown";
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
HEX=[0-9]|[A-Fa-f]
NL=\r|\n|\r\n
WS= {NL}|[" "\t\f]

DECLITERAL={DIGIT}+
HEXLITERAL=0[xX]{HEX}+

DBLLITERAL={DIGIT}+"."({DIGIT}*((E|e)("+"|"-")?{DIGIT}+)?)

IDENT=[A-Za-z][0-9A-Za-z_]*

OCTAL=[0-7]
OCTESCAPE=\\[0-3]?{OCTAL}?{OCTAL}

SLCOMMENT="//".*
MLCOMMENT="/*" ~"*/"

COMMENT={SLCOMMENT}|{MLCOMMENT}

%state STRINGLITERAL

%%

<YYINITIAL> {
	"boolean"						{return Token.build(_BOOLEAN, currentLine);}
	"break"							{return Token.build(_BREAK, currentLine);}
	"class"							{return Token.build(_CLASS, currentLine);}
	"double"						{return Token.build(_DOUBLE, currentLine);}
	"else"							{return Token.build(_ELSE, currentLine);}
	"extends"						{return Token.build(_EXTENDS, currentLine);}
	"false"							{return Token.build(_BOOLEANCONSTANT, "false", currentLine);}
	"for"							{return Token.build(_FOR, currentLine);}
	"if"							{return Token.build(_IF, currentLine);}
	"implements"					{return Token.build(_IMPLEMENTS, currentLine);}
	"int"							{return Token.build(_INT, currentLine);}
	"interface"						{return Token.build(_INTERFACE, currentLine);}
	"new"							{return Token.build(_NEW, currentLine);}
	"newarray"						{return Token.build(_NEWARRAY, currentLine);}
	"null"							{return Token.build(_NULL, currentLine);}
	"println"						{return Token.build(_PRINTLN, currentLine);}
	"readln"						{return Token.build(_READLN, currentLine);}
	"return"						{return Token.build(_RETURN, currentLine);}
	"string"						{return Token.build(_STRING, currentLine);}
	"true"							{return Token.build(_BOOLEANCONSTANT, "true", currentLine);}
	"void"							{return Token.build(_VOID, currentLine);}
	"while"							{return Token.build(_WHILE, currentLine);}
	"+"								{return Token.build(_PLUS, currentLine);}
	"-"								{return Token.build(_MINUS, currentLine);}
	"*"								{return Token.build(_MULTIPLICATION, currentLine);}
	"/"								{return Token.build(_DIVISION, currentLine);}
	"%"								{return Token.build(_MOD, currentLine);}
	"<"								{return Token.build(_LESS, currentLine);}
	"<="							{return Token.build(_LESSEQUAL, currentLine);}
	">"								{return Token.build(_GREATER, currentLine);}
	">="							{return Token.build(_GREATEREQUAL, currentLine);}
	"=="							{return Token.build(_EQUAL, currentLine);}
	"!="							{return Token.build(_NOTEQUAL, currentLine);}
	"&&"							{return Token.build(_AND, currentLine);}
	"||"							{return Token.build(_OR, currentLine);}
	"!"								{return Token.build(_NOT, currentLine);}
	"="								{return Token.build(_EQUAL, currentLine);}
	";"								{return Token.build(_SEMICOLON, currentLine);}
	","								{return Token.build(_COMMA, currentLine);}
	"."								{return Token.build(_PERIOD, currentLine);}
	"("								{return Token.build(_LEFTPAREN, currentLine);}
	")"								{return Token.build(_RIGHTPAREN, currentLine);}
	"["								{return Token.build(_LEFTBRACKET, currentLine);}
	"]"								{return Token.build(_RIGHTBRACKET, currentLine);}
	"{"								{return Token.build(_LEFTBRACE, currentLine);}
	"}"								{return Token.build(_RIGHTBRACE, currentLine);}

	{NL}							{currentLine++;}

	{IDENT}							{String s = yytext();
									 symbolTable.reserve(s);
									 return Token.build(_ID, s, currentLine);}

	{DECLITERAL}					{return Token.build(_INTCONSTANT, yytext(), currentLine);}

	{HEXLITERAL}					{String s = yytext();
									 s = Integer.decode(s).toString();
									 return Token.build(_INTCONSTANT, s, currentLine);}

	{DBLLITERAL}					{return Token.build(_DOUBLECONSTANT, yytext(), currentLine);}
	
	\"								{yybegin(STRINGLITERAL);}
	
	{COMMENT}						{}
	{WS}							{}
}

<STRINGLITERAL> {
	\"								{String s = sLiteral.toString();
									 sLiteral = new StringBuilder();
									 yybegin(YYINITIAL);
									 return Token.build(_STRINGCONSTANT, s, currentLine);}
	
	[^\n\r\"\\]+					{sLiteral.append(yytext());}	/*not sure about this regex*/
	
	\\n								{sLiteral.append('\n');}
	\\r								{sLiteral.append('\r');}
	\\t								{sLiteral.append('\t');}
	\\								{sLiteral.append('\\');}
	\\\"							{sLiteral.append('\"');}
	
	{OCTESCAPE}						{char c = (char)Integer.parseInt(yytext().substring(1), 8);
									 sLiteral.append(c);}
}

[^]									{error = true;
									 return Token.build(_ERROR, yytext(), currentLine);}