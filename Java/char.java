char[] chars = {'a', 'b', 'c', 'd'};

for(char c : chars) {
    //Error(cause c is not a object): 
    //System.out.println(c.toString());
    
    //OK
    System.out.println(String.valueOf(c));
    System.out.println(Character.toString(c));
    System.out.println(""+c);
}


char[] helloArray = { 'h', 'e', 'l', 'l', 'o', '.' };
String helloString = new String(helloArray);  
System.out.println( helloString );
