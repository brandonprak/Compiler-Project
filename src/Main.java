import java.util.*;
import java.io.*;

import common.*;
import lexer.*;
import parser.*;

import static lexer.Lexer.Token;

public class Main{
	
	public static void main(String[] args){
		if(args.length != 1){
			System.out.println("Enter only one argument");
			System.exit(1);
		}
		
		File f = new File(args[0]);
		
		if(!f.exists()){
			System.out.println("File not found");
			System.exit(2);
		}
		
		Reader r = null;
		
		try{
			r = new FileReader(f);
		}
		catch(FileNotFoundException e){/*shouldn't happen*/}
		
		Lexer lex = new Lexer(r);
		
		List<Token> tokens = new ArrayList<>();
		
		while(!(lex.isDone() || lex.errorOccurred())){
			try{
				Token t = lex.yylex();
				if(!(t == null && lex.isDone()))
					tokens.add(t);
			}
			catch(IOException e){
				System.out.println("An IOException occurred:");
				e.printStackTrace(System.out);
				
				System.exit(3);
			}
		}
		
		Iterator<Token> itr = tokens.iterator();
		
		Token t = null;
		int line = 0;
		
		if(itr.hasNext()){
			t = itr.next();
			line = t.getLineNumber();
			
			System.out.print(t);
			
			while(itr.hasNext()){
				t = itr.next();
				int nextLine = t.getLineNumber();
				
				if(nextLine != line){
					line = nextLine;
					
					System.out.println();
					System.out.print(t);
				}
				else{
					System.out.print(" " + t.toString());
				}
			}
			
			System.out.println();
			System.out.println();
			
			System.out.println(lex.symbolTable);
		}
	}
}