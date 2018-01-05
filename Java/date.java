//Date dNow = new Date();
//SimpleDateFormat ft = new SimpleDateFormat ("E yyyy.MM.dd 'at' hh:mm:ss a zzz");
//ft.format(new Date())

System.out.println("Current Date: " + (new SimpleDateFormat ("E yyyy.MM.dd 'at' hh:mm:ss a zzz")).format(new Date()));

String str = String.format("Current Date/Time : %tc", (new Date()) );

System.out.printf("%1$s %2$tB %2$td, %2$tY", "Due date:", (new Date()));
