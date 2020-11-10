package common;

import java.util.*;
import java.util.regex.Pattern;

/**
 *Basic trie implementation of a table.
 *
 *<p>Keys are {@code String}s matching the regular expression [A-Za-z][A-Za-z0-9_]*
 *
 *@param <V> Type of mapped values
 */
public class Trie<V>{
	
	private static final Pattern KEY_PATTERN = Pattern.compile("[A-Za-z][A-Za-z0-9_]*");
	private static final char    EMPTY = '.', SEPARATOR = '*', VALUE = '#';
	private static final int     DEFAULT_INIT_SSIZE = 512, DEFAULT_INIT_VSIZE = 16;
	
	private int[] switchArray, next;
	private char[] symbol;
	private V[] values;
	
	private int sSize, vSize, nextIndex, currentValue, count;
	
	/**
	 *Constructs a trie table with the given sizes of the symbol and value arrays.
	 *
	 *@param sSize Size of the symbol and next arrays. Must be greater than 0.
	 *@param vSize Size of the value array. Must be greater than 0.
	 *
	 *@throws IllegalArgumentException If either sSize or vSize are less than or equal to 0.
	 */
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
	
	/**
	 *Constructs a trie table with the default sizes of the symbol and value arrays.
	 */
	public Trie(){
		this(DEFAULT_INIT_SSIZE, DEFAULT_INIT_VSIZE);
	}
	
	/**
	 *Reserves a key-value mapping for future use. This should be the primary method of adding a key to the table in order to map a value to it later.
	 *
	 *<p>Reserving a previously existing key has no effect.
	 *
	 *@param s The key to reserve.
	 *
	 *@throws IllegalArgumentException If the key being reserved does not match the regular expression given above.
	 */
	public void reserve(String s){
		reserveInternal(s);
	}
	
	private int reserveInternal(String s){
		if(!matches(KEY_PATTERN, s))
			throw new IllegalArgumentException("Invalid key: " + s);
		
		return search(s + SEPARATOR, true);
	}
	
	/**
	 *Mapps a value to a given key, reserving it if necessary. 
	 *
	 *<p>Mapping a previously mapped value overwrites the existing value.
	 *
	 *@param s The key to map to.
	 *@param value The value to map. May be {@code null}.
	 *
	 *@throws IllegalArgumentException If the key being mapped to does not match the regular expression given above.
	 */
	public void put(String s, V value){
		int index = reserveInternal(s);
		
		index = next[index];
		
		if(index >= vSize)
			growValueArray();
		
		values[index] = value;
	}
	
	/**
	 *Retrieves the value for a given key, or {@code null} if it does not exist. 
	 *
	 *@param s The key to search for.
	 *@return The value of the key, or {@code null} if it does not exist. 
	 *
	 *@throws IllegalArgumentException If the key is {@code null}.
	 */
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
	
	/**
	 *Checks if the table contains a mapping for a given key.
	 *
	 *@param s The key to search for.
	 *@return {@code true} if the key is present in the table, {@code false} if not. Also {@code false} if s is an invalid key or {@code null}.
	 */
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
	
	//Searches the arrays for the index of the value pointer for the key s. If create is true, the key is created and the index of its value pointer is returned;
	//if create is false, -1 is returned.
	private int search(String s, boolean create){
		char c;
		int i = 0;
		
		c = s.charAt(i++);
		
		boolean notFound = false;
		boolean inSwitch = true;
		
		int ptr = switchArray[switchChar(c)];
		
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
	
	/**
	 *Prints the contents of the arrays representing the trie.
	 *
	 *@return A string representation of the trie.
	 */
	@Override
	public String toString(){
		StringBuilder sb = new StringBuilder();
		StringBuilder line1 = null, line2 = null, line3 = null;
		
		final int max = 74;
		
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
	
	//Grows (doubles) the symbol and next arrays.
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
	
	//Grows (doubles) the value array.
	private void growValueArray(){
		int newSize = vSize << 1;
		
		@SuppressWarnings("unchecked")
		V[] newValue = (V[])new Object[newSize];
		
		System.arraycopy(values, 0, newValue, 0, vSize);
		
		values = newValue;
		
		vSize = newSize;
	}
	
	//Returns the index in the switch array of a given char.
	private static int switchChar(char c){
		if(c >= 'A' && c <= 'Z')
			return c - 'A';
		else if(c >= 'a' && c <= 'z')
			return (c - 'a') + 26;
		else return -1;
	}
	
	//Convenience method to compare a string against a regular expression.
	private static boolean matches(Pattern p, String s){
		return (p != null && s != null) ? p.matcher(s).matches() : false;
	}
}