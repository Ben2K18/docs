1) mkdir abc
   cd abc
   
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
javac -d . PA.java PB.java
 
4) tree .
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
