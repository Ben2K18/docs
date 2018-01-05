1) mkdir /tmp/progs
   cd /tmp/progs
   
2)
//a) PA.java 
package com.a.chat;
public class PA {
}

//b) PB.java 
package com.a.chat;
public class PB {
}

3)
javac -d /tmp/class PA.java PB.java
 
4) tree /tmp/class
├── com
│   └── a
│       └── chat
│           ├── PA.class
│           └── PB.class
├── PA.java
└── PB.java

5) A.java
import com.a.chat.PA;

public class A {
   public static void main(String args[]) {
      PA obj = new PA();
      
   }
}

6) 
a) 指定路径   
mv A.java ../
cd ../
javac -cp /tmp/class  A.java
java9 -cp /tmp/class A

b) 放到CLASSPATH里
export CLASSPATH=$CLASSPATH:/tmp/class
javac A.java
java A

