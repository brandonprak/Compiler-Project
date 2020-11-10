package common;

public interface TokenTypeID{
	public static final int _BOOLEAN = 49;	/*Don't think 0 can be used as it may be used by parser for EOF. Replacing w/ next value (49)
                                              because I DO NOT want to change each of the other constants. If anyone else wants to do so
                                              (make _BOOLEAN=1 and the remaining constants counting up) feel free. -R*/
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
	public static final int _RIGHTPAREN = 39;
	public static final int _LEFTBRACKET = 40;
	public static final int _RIGHTBRACKET = 41;
	public static final int _LEFTBRACE = 42;
	public static final int _RIGHTBRACE = 43;
	public static final int _INTCONSTANT = 44;
	public static final int _DOUBLECONSTANT = 45;
	public static final int _STRINGCONSTANT = 46;
	public static final int _BOOLEANCONSTANT = 47;
	public static final int _ID = 48;
	public static final int _ERROR = -1;
}