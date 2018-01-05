import java.io.*;

public class MyIO {
    public static void main(String[] args) {
        FileInputStream in = null;
        FileOutputStream out = null;

        try {
            in = new FileInputStream("input.txt");
            out = new FileOutputStream("output.txt");
            int c;
            while (( c= in.read()) != -1) {
                out.write(c);
            }    
        } catch(IOException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if(in != null) {
                    in.close();
                }
            }catch(IOException e) {
                System.out.println(e.getMessage());
            }
            try {
                if(out != null) {
                    out.close();
                }
            } catch(IOException e) {
                System.out.println(e.getMessage());
            }
        }
    }
}
