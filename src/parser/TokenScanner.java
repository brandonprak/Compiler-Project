package parser;

import java.util.*;

import common.*;

import static lexer.Lexer.Token;

public class TokenScanner implements TokenTypeID{
	private List<Token> stream;
	private Iterator<Token> iterator;
	
	public TokenScanner(List<Token> tokens){
		stream = Collections.unmodifiableList(tokens);
		iterator = stream.iterator();
	}
}