class SuperClass {
   int age;

   SuperClass(int age) {
      this.age = age; 		 
   }

   public void getAge() {
      System.out.println("The value of the variable named age in super class is: " +age);
   }
}

class Sub extends SuperClass {
   Sub(int age) {
      super(age);
   }
}

public class A {
   public static void main(String argd[]) {
      Sub s = new Sub(24);
      s.getAge();
   }
}
