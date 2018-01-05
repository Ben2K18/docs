//定义 (必须在类外面，否则编译报错)
enum MySize { Small, Medium, Large }
enum WeekDay { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

public class A {
    public static void main(String args[]) {
        //定义变量
        WeekDay today=WeekDay.Mon; 

        //输出
        System.out.println("WeekDay: "+(today)+" "+today.toString()); // Mon Mon

        //if
        if(today == WeekDay.Mon)
            System.out.println("Mon2");

        //switch
        switch (today) {
            //Error: case "Mon":
            //Error: case WeekDay.Mon
            //OK: Mon
            case Mon:
                System.out.println("Mon");
                break;

            case Tue:
                System.out.println("Tue");
                break;

            case Wed:
                System.out.println("Wed");
                break;

            case Thu:
                System.out.println("Thu");
                break;

            case Fri:
                System.out.println("Fri");
                break;

            case Sat:
                System.out.println("Sat");
                break;

            case Sun:
                System.out.println("Sun");
                break;
        }
    }
}
