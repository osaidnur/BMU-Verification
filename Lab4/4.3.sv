module mailbox_example();
  mailbox my_mailbox = new(2);

  // Task to put values into the mailbox
  task task1(input int val, input string str);
    begin 
      $display("[%0t] Task1: Before put - value: %0d, name: %s", $time, val, str); 
      
      my_mailbox.put(val);
      my_mailbox.put(str);

      $display("[%0t] Task1: After put - value: %0d, name: %s", $time, val, str); 
    end 
  endtask

  // Task to get values from the mailbox
  task task2();
    int val; 
    string str;
    begin 
      $display("[%0t] Task2: Before get", $time);
      
      my_mailbox.get(val);
      my_mailbox.get(str);

      $display("[%0t] Task2: After get - value: %0d, name: %s", $time, val, str); 
    end 
  endtask  

  initial begin 
    fork     
     task1(5, "testName");  
     #2 task2();
    join 
  end 

endmodule
