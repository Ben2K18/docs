Object 
    InputStream
        FileInputStream
        ByteArrayInputStream
        FilterInputStream
             BufferedInputStream
             DateInputStream
        ObjectInputStream
    
    OutputStream
        FileOutputStream
        ByteArrayOutputStream
        FilterOutputStream
             DataOutputStream
             BufferedOutputStream
        ObjectOutputStream

///////////////////////////////////////

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

//////////////////////////////////////////////////

import java.io.*;
import java.util.*;

public class MyIO {
    public static void main(String[] args) {
        InputStreamReader cin = null;
        try {
            cin = new InputStreamReader(System.in);
            System.out.println("Enter q to quit");

            char c;
            do {
                c = (char) cin.read();
                System.out.println(c);
            } while(c != 'q');

        } catch(IOException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if(cin != null)
                    cin.close();
            } catch(IOException e2) {
                System.out.println(e.getMessage());    
            }
        }
    }
}

//////////////////////////////

import java.io.*;
import java.util.*;

public class MyIO {
    public static void main(String[] args) {
        try {
            Scanner s = new Scanner(System.in);
            System.out.println(s.next());
        } catch(Exception e) {
            System.out.println(e.getMessage());
        } finally {
        }
    }
}
