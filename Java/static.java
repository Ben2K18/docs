public class B {
   //静态变量
   public static String SName="SName";
   
   //实例变量
   public String Name="Name";
   
   public static void main(String args[]){
        B objB = new B();
        
        System.out.println(objB.Name); // Name
        
        System.out.println(SName); // SNBME
   }
}
