import java.io.File;

//定义
public class A {
    public static void main(String args[]) {
        File dir = new File("/tmp/a/b/c"); //可以递归创建，不论上级目录是否存在
        dir.mkdirs();
    }
}

////////////////////////////////////

import java.io.File;

//定义
public class A {
    public static void main(String args[]) {
        for( String f : (new File("/tmp")).list())
             System.out.println(f);
    }
}

///////////////////////////////////////

try(FileReader fr = new FileReader("E://file.txt")) {
   char [] a = new char[50];
   fr.read(a);   // reads the contentto the array
   for(char c : a)
      System.out.print(c);
} catch (IOException e) {
      e.printStackTrace();
}
