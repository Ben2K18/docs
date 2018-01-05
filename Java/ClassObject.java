Encapsulation 封装
    Encapsulation is mechanism of wrapping the data (variables) and code acting on the data (methods) together as a single unit
    封装是将数据\代码作为一个整体包装起来的机制,用于隐藏内部细节和安全性。
abstraction   抽象
    
inheritance   继承
    Java的继承是单继承,子类只能拥有一个父类
    子类继承父类非私有的特征和行为
    避免代码重复劳动
    extends 类继承
    implements 接口继承
    所有的类都继承于 java.lang.Object
    
    
    
polymorphism  多态

interface A {
    public void eat();
    public void sleep();
}
 
interface B {
    public void show();
}

//OK
//声明为抽象类，因为只是实现了eat()抽象函数
//C不能实例化，只能被继承实现抽象函数
//abstract class C implements A,B {
    public void eat(){
       System.out.println("i eated");
    }
}

//OK
//实现全部抽象函数
class C implements A,B {
   public void sleep() {
   }

   public void eat() {
   }

   public void show() {
   }
}

public class D {
   public static void main(String args[]) {
   }
}
