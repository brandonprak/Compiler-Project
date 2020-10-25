import java.util.*;
import java.util.regex.Pattern;


public class Trie<V>{
	
	private static final Pattern KEY_PATTERN = Pattern.compile("[A-Za-z][A-Za-z0-9]*");
	
	private static final char EMPTY = '.', SEPARATOR = '*', VALUE = '#';
	
	private static final int DEFAULT_INIT_SSIZE = 512, DEFAULT_INIT_VSIZE = 16;
	
	
	private int[] switchArray, next;
	private char[] symbol;
	private V[] values;
	
	private int sSize, vSize, nextIndex, currentValue, count;
	
	public Trie(int sSize, int vSize){
		if(sSize <= 0)
			throw new IllegalArgumentException("sSize must be >0");
		if(vSize <= 0)
			throw new IllegalArgumentException("vSize must be >0");
		
		this.sSize = sSize;
		this.vSize = vSize;
		
		switchArray = new int[52];
		next = new int[sSize];
		symbol = new char[sSize];
		
		@SuppressWarnings("unchecked")
		V[] temp = (V[])new Object[vSize];
		values = temp;
		
		nextIndex = 0;
		currentValue = -1;
		count = 0;
		
		Arrays.fill(switchArray, -1);
		Arrays.fill(next, -1);
		Arrays.fill(symbol, EMPTY);
	}
	
	public Trie(){
		this(DEFAULT_INIT_SSIZE, DEFAULT_INIT_VSIZE);
	}
	
	public int reserve(String s){
		if(!matches(KEY_PATTERN, s))
			throw new RuntimeException("Invalid key: " + s);
		
		return search(s + SEPARATOR, true);
	}
	
	public void put(String s, V value){
		int index = reserve(s);
		
		index = next[index];
		
		if(index >= vSize)
			growValueArray();
		
		values[index] = value;
	}
	
	public V get(String s){
		if(s == null)
			throw new IllegalArgumentException(s);
		
		int index = search(s + SEPARATOR, false);
		
		if(index != -1){
			index = next[index];
			return values[index];
		}
		else
			return null;
	}
	
	public boolean contains(String s){
		return (matches(KEY_PATTERN, s)) ? search(s + SEPARATOR, false) != -1 : false;
	}
	
	/* public void remove(String s){
		if(!matches(KEY_PATTERN, s))
			return;
		
		//s = s + SEPARATOR;
		
		int index = search(s + SEPARATOR, false);
		
		if(index != -1){
			values[next[index]] = null;
			
			next[index] = -1;
			
			for(int i = 0; i < sSize; i++){
				if(symbol[i] == VALUE)
					if(next[i] == )
			}
		}
	} */
	
	private int search(String s, boolean create){
		char c;
		int i = 0;
		
		c = s.charAt(i++);
		
		boolean notFound = false;
		
		int ptr = switchArray[switchChar(c)];
		
		boolean inSwitch = true;
		
		if(ptr == -1)
			notFound = true;
		
		while(!notFound && i < s.length()){
			inSwitch = false;
			
			c = s.charAt(i++);
			
			if(c != symbol[ptr]){
				if(next[ptr] == -1)
					notFound = true;
				else{
					ptr = next[ptr];
					i--;
				}
			}
			else{
				if(c == SEPARATOR)
					return ptr + 1;
				else
					ptr++;
			}
		}
		
		if(!create)
			return -1;
		
		count++;
		
		if(inSwitch){
			switchArray[switchChar(c)] = nextIndex;
			c = s.charAt(i++);
		}
		else
			next[ptr] = nextIndex;
		
		ptr = nextIndex;
		
		symbol[ptr++] = c;
				
		while(i < s.length()){
			c = s.charAt(i++);
			
			if(ptr >= symbol.length)
				growSymbolArray();
			
			symbol[ptr++] = c;
		}
		
		if(ptr >= symbol.length)
			growSymbolArray();
		
		symbol[ptr] = VALUE;
		next[ptr++] = ++currentValue;
		
		if(ptr >= symbol.length)
			growSymbolArray();
		
		nextIndex = ptr;
		
		return ptr - 1;
	}
	
	@Override
	public String toString(){
		StringBuilder sb = new StringBuilder();
		
		StringBuilder line1 = null, line2 = null, line3 = null;
		
		int max = 74;
		
		int l = 0;
		
		for(char c = 'A'; c <= 'z'; c = (c != 'Z') ? (char)(c + 1) : 'a'){
			if(l == 0){
				line1 = new StringBuilder("       ");
				line2 = new StringBuilder("switch:");
				
				l = 7;
			}
			
			int index = switchChar(c);
			String s = (index != -1) ? " " + Integer.toString(switchArray[index]) : " -1";
			
			line1.append(String.format("%" + s.length() + "c", c));
			line2.append(s);
			
			l += s.length();
			
			if(l >= max || c == 'z'){
				sb.append(line1.toString()).append('\n').append(line2.toString()).append('\n').append('\n');
				l = 0;
			}
		}
		
		for(int i = 0; i < nextIndex; i++){
			if(l == 0){
				line1 = new StringBuilder("       ");
				line2 = new StringBuilder("symbol:");
				line3 = new StringBuilder("next:  ");
				
				l = 7;
			}
			
			String s1 = Integer.toString(i), s2;
			
			int n = next[i];
			
			s2 = (n != -1) ? Integer.toString(n) : "";
			
			int len = Math.max(s1.length(), s2.length()) + 1;
			
			line1.append(String.format("%" + len + "s", s1));
			line2.append(String.format("%" + len + "c", symbol[i]));
			line3.append(String.format("%" + len + "s", s2));
			
			l += len;
			
			if(l >= max || i == nextIndex - 1){
				sb.append(line1.toString()).append('\n').append(line2.toString()).append('\n').append(line3.toString()).append('\n').append('\n');
				l = 0;
			}
		}
		
		return sb.deleteCharAt(sb.length() - 2).toString();
	}
	
	private void growSymbolArray(){
		int newSize = sSize << 1;
		int[] newNext = new int[newSize];
		char[] newSymbol = new char[newSize];
		
		System.arraycopy(next, 0, newNext, 0, sSize);
		System.arraycopy(symbol, 0, newSymbol, 0, sSize);
		
		next = newNext;
		symbol = newSymbol;
		
		sSize = newSize;
	}
	
	private void growValueArray(){
		int newSize = vSize << 1;
		
		@SuppressWarnings("unchecked")
		V[] newValue = (V[])new Object[newSize];

		System.arraycopy(values, 0, newValue, 0, vSize);
		
		values = newValue;
		
		vSize = newSize;
	}
	
	
	private static int switchChar(char c){
		if(c >= 'A' && c <= 'Z')
			return c - 'A';
		else if(c >= 'a' && c <= 'z')
			return (c - 'a') + 26;
		else return -1;
	}
	
	private static boolean matches(Pattern p, String s){
		return (p != null && s != null) ? p.matcher(s).matches() : false;
	}
}