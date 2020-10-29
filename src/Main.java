import java.io.*;

public class Main {
    public static void main(String[] args) throws Exception {
        // Opens up input file and feeds into lexer
        String filename = "input.txt";
        PushbackReader source = new PushbackReader(new FileReader(filename), 3);
        Lexer lexer = new Lexer(source);

        // Scan tokens until end of file
        while (!lexer.isEOF())
            lexer.scanNextToken();

        System.out.println(("\nToken Output"));
        lexer.dumpTokens();
        System.out.println();
        System.out.println(("\nSymbol Table"));
        lexer.dumpSymbolTable();
        System.out.println();
    }
}
