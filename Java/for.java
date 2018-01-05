1)
int[] numbers = {1,2,3,4,5,6};

for(int x : numbers) {
    System.out.println(x);
}

2)
String[] names = {"a", "b", "c", "d"};
for(String name : names) {
    System.out.println(name) // a b c d
}

3)
char[] chars = {'a', 'b', 'c', 'd'};
for(char c : chars) {
    //Error(cause c is not a object): 
    //System.out.println(c.toString());
    
    //OK
    System.out.println(String.valueOf(c));
    System.out.println(Character.toString(c));
    System.out.println(""+c);

}
