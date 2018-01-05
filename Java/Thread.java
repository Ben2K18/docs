      //1)
      (new Thread() {
          public void run() {
              System.out.println("thread here...");
          }
      }).start();

     //2) Runnable
     (new Thread(new Runnable() {
            public void run() {
                System.out.println("thread here...");
            }
      })).start();
