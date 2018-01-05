import java.utils.*;

class ThreadArgs implements Runnable {    
    private volatile String str;

    //传参
    public ThreadArgs(String str){
        this.str = str;
    }

    public void run(){
        System.out.println(this.str);
    }
}

//传参运行 
new Thread(new ThreadArgs("Hello World")).start();
