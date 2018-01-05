public abstract class Employee {
   private String name;
   
   public abstract double computePay();
}

public class Salary extends Employee {
   private double salary;
  
   public double computePay() {
      System.out.println("Computing salary pay for " + getName());
      return salary/52;
   }
}
