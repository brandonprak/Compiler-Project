import java.io.*;
import java.util.*;

/**
 * Implements a lexical analyzer for the Toy language. Tokens are read in
 * and placed into a list so that they can be output whenever needed.
 * The lexer spots scanning tokens when the end of the file has been reached.
 */
public class Lexer {
    private static final char EOF_CHAR = (char) -1;
    private PushbackReader source;
    private List<ToyToken> tokens;
    private Trie<String> table;
    private boolean eof;

    /**
     * Constructor
     *
     * @param source - a PushbackReader containing a stream to the input file
     */
    public Lexer(PushbackReader source) {
        this.source = source;
        tokens = new LinkedList<ToyToken>();
        table = new Trie<String>();
        eof = false;
        insertKeywords(); // Initialize the symbol table with the keywords
    }

    /**
     * Scans the input stream and constructs the next recognized token.
     * Whitespace and comments encountered are stripped out.
     *
     * The next token scanned is added to the tokens list.
     */
    public void scanNextToken() throws IOException {
        char curr, peek;
        curr = nextUsefulChar();

        // Handle Operators
        switch (curr) {

            // EOF
            case EOF_CHAR:
                tokens.add(ToyToken._eof);
                eof = true;
                break;

            // String Constants
            case '"':
                while ((curr = readChar()) != '"') {}
                tokens.add(ToyToken._stringconstant);
                break;

            // Single Character Symbols/Operators
            case '+':
                tokens.add(ToyToken._plus);
                break;
            case '-':
                tokens.add(ToyToken._minus);
                break;
            case '*':
                tokens.add(ToyToken._multiplication);
                break;
            case '/':
                tokens.add(ToyToken._division);
                break;
            case '%':
                tokens.add(ToyToken._mod);
                break;
            case ';':
                tokens.add(ToyToken._semicolon);
                break;
            case ',':
                tokens.add(ToyToken._comma);
                break;
            case '.':
                tokens.add(ToyToken._period);
                break;
            case '(':
                tokens.add(ToyToken._leftparen);
                break;
            case ')':
                tokens.add(ToyToken._rightparen);
                break;
            case '[':
                tokens.add(ToyToken._leftbracket);
                break;
            case ']':
                tokens.add(ToyToken._rightbracket);
                break;
            case '{':
                tokens.add(ToyToken._leftbrace);
                break;
            case '}':
                tokens.add(ToyToken._rightbrace);
                break;

            // Multi-Character Operators
            case '<':
                peek = readChar();
                if (peek == '=') {
                    tokens.add(ToyToken._lessequal);
                } else {
                    pushback( peek);
                    tokens.add(ToyToken._less);
                }
                break;
            case '>':
                peek = readChar();
                if (peek == '=') {
                    tokens.add(ToyToken._greaterequal);
                } else {
                    pushback( peek);
                    tokens.add(ToyToken._greater);
                }
                break;
            case '=':
                peek = readChar();
                if (peek == '=') {
                    tokens.add(ToyToken._equal);
                } else {
                    pushback( peek);
                    tokens.add(ToyToken._assignop);
                }
                break;
            case '!':
                peek = readChar();
                if (peek == '=') {
                    tokens.add(ToyToken._notequal);
                } else {
                    pushback( peek);
                    tokens.add(ToyToken._not);
                }
                break;
            case '&':
                peek = readChar();
                if (peek == '&') {
                    tokens.add(ToyToken._and);
                } else {
                    pushback( peek);
                    tokens.add(ToyToken._ERROR);
                }
                break;
            case '|':
                peek = readChar();
                if (peek == '|') {
                    tokens.add(ToyToken._or);
                } else {
                    pushback( peek);
                    tokens.add(ToyToken._ERROR);
                }
                break;
        }

        // Identifiers/Keywords/Boolean Constants
        if (Character.isLetter(curr)) {
            StringBuilder sb = new StringBuilder();
            sb.append(curr);
            peek = readChar();

            while (Character.isLetterOrDigit(peek) || peek == '_') {
                sb.append(peek);
                peek = readChar();
            }
            pushback(peek);
            String s = sb.toString();

            // Determine if token should be id, keyword, or boolean
            switch (s) {
                case "true":
                case "false":
                    tokens.add(ToyToken._booleanconstant);
                    break;
                case "boolean":
                    tokens.add(ToyToken._boolean);
                    break;
                case "break":
                    tokens.add(ToyToken._break);
                    break;
                case "class":
                    tokens.add(ToyToken._class);
                    break;
                case "double":
                    tokens.add(ToyToken._double);
                    break;
                case "else":
                    tokens.add(ToyToken._else);
                    break;
                case "extends":
                    tokens.add(ToyToken._extends);
                    break;
                case "for":
                    tokens.add(ToyToken._for);
                    break;
                case "if":
                    tokens.add(ToyToken._if);
                    break;
                case "implements":
                    tokens.add(ToyToken._implements);
                    break;
                case "int":
                    tokens.add(ToyToken._int);
                    break;
                case "interface":
                    tokens.add(ToyToken._interface);
                    break;
                case "newarray":
                    tokens.add(ToyToken._newarray);
                    break;
                case "println":
                    tokens.add(ToyToken._println);
                    break;
                case "readln":
                    tokens.add(ToyToken._readln);
                    break;
                case "return":
                    tokens.add(ToyToken._return);
                    break;
                case "string":
                    tokens.add(ToyToken._string);
                    break;
                case "void":
                    tokens.add(ToyToken._void);
                    break;
                case "while":
                    tokens.add(ToyToken._while);
                    break;
                default:
                    tokens.add(ToyToken._id);
                    table.reserve(s);
            }
        }
        // Digits
        else if (Character.isDigit(curr)) {
            peek = readChar();

            // Hex Int
            if (curr == '0' && Character.toUpperCase(peek) == 'X') {
                curr = readChar();
                if (isHexDigit(curr)) {
                    tokens.add(ToyToken._intconstant);
                    while (isHexDigit(curr = readChar())) {}
                    pushback(curr);
                } else {
                    tokens.add(ToyToken._intconstant);
                    pushback(curr);
                    pushback(peek);
                }
            // Doubles and Decimal Ints
            } else {
                pushback(peek);
                while (Character.isDigit(curr))
                    curr = readChar();

                if (curr == '.') {
                    handleDouble();
                } else {
                    pushback(curr);
                    tokens.add(ToyToken._intconstant);
                }
            }
        }
    }

    /**
     * Handles double constants. Method is called ONLY after a '.' has been
     * read in from the input stream.
     */
    private void handleDouble() throws IOException {
        char curr;

        while (Character.isDigit(curr = readChar())) {}

        // Checks for exponents
        if (Character.toUpperCase(curr) == 'E') {
            handleExponent(curr);
        } else {
            tokens.add(ToyToken._doubleconstant);
            pushback(curr);
        }
    }

    /**
     * Method consumes valid characters for exponent.
     *
     * @param curr - character with value of 'E' or 'e'
     * @throws IOException
     */
    private void handleExponent(char curr) throws IOException {
        char peek1, peek2;
        peek1 = readChar();

        // E#...#
        if (Character.isDigit(peek1)) {
            while (Character.isDigit(peek1 = readChar())) {}
            pushback(peek1);
            // E+ or E-
        } else if (peek1 == '-' || peek1 == '+') {
            peek2 = readChar();
            // At least 1 character after +/- to be valid
            if (Character.isDigit(peek2)) {
                while (Character.isDigit(peek2 = readChar())) {}
                pushback(peek2);
            // Invalid exponential form, push back characters that will be used for other tokens
            } else {
                pushback(peek2); 	// Pushback character after +/-
                pushback(peek1); 	// Pushback + or -
                pushback(curr); 	// Pushback e or E
            }
            // E followed by invalid character, push characters back
        } else {
            pushback(peek1);
            pushback(curr);
        }
        tokens.add(ToyToken._doubleconstant);
    }

    /**
     * Checks if character is a valid hex digit
     *
     * @param c - char to be checked
     * @return - true if c is a hex digit, false otherwise
     */
    private boolean isHexDigit(char c) {
        c = Character.toUpperCase(c);
        return Character.isDigit(c) || (c == 'A') || (c == 'B') || (c == 'C') ||
                (c == 'D') || (c == 'E') || (c == 'F');
    }

    /**
     * Checks if end of file was reached
     *
     * @return true is end of file reached, false otherise
     */
    public boolean isEOF() {
        return eof;
    }


    /**
     * Prints out the tokens to System.out
     */
    public void dumpTokens() {
        Iterator<ToyToken> iter = tokens.iterator();	//You can use an enhanced for loop for this. -R
        while (iter.hasNext()) {
            ToyToken t = iter.next();
            if (t.toString().equals("carriage")) {
                System.out.println();
            } else if (!t.toString().equals("EOF")) {
                System.out.print(t.toString() + " ");
            }
        }
    }


    /**
     * Checks if parameter c is a whitespace character
     *
     * @param c - char to be checked
     * @return true if c is whitespace, false otherwise
     */
    private boolean isWhiteSpace(char c) {
        if (c == '\r')
            tokens.add(ToyToken._carriageReturn);
        return (c == ' ') || (c == '\t') || (c == '\n') || (c == '\r');
    }


    /**
     * Gets the first non-whitespace character for the lexer to begin token
     * determination.
     *
     * @return non-whitespace character
     * @throws IOException
     */
    private char nextUsefulChar() throws IOException {
        char curr = readChar();
        char peek;
        boolean usefulChar = false;

        do {
            while (isWhiteSpace(curr)) {
                curr = readChar();
            }

            // Determine if Single Line/Multi-Line comment or Division Operator
            if (curr == '/') {
                peek = readChar();
                switch (peek) {
                    case '/':
                        tokens.add(ToyToken._carriageReturn);
                        while ((curr = readChar()) != '\r') {}
                        curr = readChar();
                        break;
                    case '*':
                        curr = readChar();
                        peek = readChar();
                        while (curr != '*' || peek != '/') {
                            if (curr == '\r')
                                tokens.add(ToyToken._carriageReturn);
                            curr = peek;
                            peek = readChar();
                        }
                        curr = readChar();
                        break;
                    default:
                        pushback(peek);
                        usefulChar = true;
                }
            } else {
                usefulChar = true;
            }
        } while (usefulChar == false);
        return curr;
    }

    /**
     * Read next character from input stream
     *
     * @return
     * @throws IOException
     */
    private char readChar() throws IOException {
        return (char)source.read();
    }

    /**
     * Push back a character into the input stream
     *
     * @param c
     * @throws IOException
     */
    private void pushback(char c) throws IOException {
        source.unread(c);
    }

    /**
     * Insert the keywords of the Toy language into the symbol table
     */
    private void insertKeywords() {
        table.reserve("boolean");
        table.reserve("break");
        table.reserve("class");
        table.reserve("double");
        table.reserve("else");
        table.reserve("extends");
        table.reserve("false");
        table.reserve("for");
        table.reserve("if");
        table.reserve("implements");
        table.reserve("int");
        table.reserve("interface");
        table.reserve("newarray");
        table.reserve("println");
        table.reserve("readln");
        table.reserve("return");
        table.reserve("string");
        table.reserve("true");
        table.reserve("void");
        table.reserve("while");
    }

    public void dumpSymbolTable() {
        System.out.println(table);
    }
	
    /**
     *
     * Tokens are implemented using an enum. Each token is assigned a unique
     * number to be used in the future with the syntax analyzer.
     *
     */
    private enum ToyToken {
        _boolean(1, "boolean"),
        _break(2, "break"),
        _class(3, "class"),
        _double(4, "double"),
        _else(5, "else"),
        _extends(6, "extends"),
        _for(7, "for"),
        _if(8, "if"),
        _implements(9, "implements"),
        _int(10, "int"),
        _interface(11, "interface"),
        _newarray(12, "newarray"),
        _println(13, "println"),
        _readln(14, "readln"),
        _return(15, "return"),
        _string(16, "string"),
        _void(17, "void"),
        _while(18, "while"),
        _plus(19, "plus"),
        _minus(20, "minus"),
        _multiplication(21, "multiplication"),
        _division(22, "division"),
        _mod(23, "mod"),
        _less(24, "less"),
        _lessequal(25, "lessequal"),
        _greater(26, "greater"),
        _greaterequal(27, "greaterequal"),
        _equal(28, "equal"),
        _notequal(29, "notequal"),
        _and(30, "and"),
        _or(31, "or"),
        _not(32, "not"),
        _assignop(33, "assignop"),
        _semicolon(34, "semicolon"),
        _comma(35, "comma"),
        _period(36, "period"),
        _leftparen(37, "leftparen"),
        _rightparen(38, "rightparen"),
        _leftbracket(39, "leftbracket"),
        _rightbracket(40, "rightbracket"),
        _leftbrace(41, "leftbrace"),
        _rightbrace(42, "rightbrace"),
        _intconstant(43, "intconstant"),
        _doubleconstant(44, "doubleconstant"),
        _stringconstant(45, "stringconstant"),
        _booleanconstant(46, "booleanconstant"),
        _id(47, "id"),
        _carriageReturn(48, "carriage"),
        _eof(49, "EOF"),
        _ERROR(50, "ERROR_TOKEN");

        private final int tokenNum;
        private final String tokenString;

        ToyToken(int num, String keyword) {
            tokenNum = num; tokenString = keyword;
        }

        public int getTokenNumber() {
            return tokenNum;
        }

        public String toString() {
            return tokenString;
        }
    }
}