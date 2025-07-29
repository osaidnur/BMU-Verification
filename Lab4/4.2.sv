module semaphore_example();
  semaphore sem = new(1);
  
  task write_mem();
    //lock the key
    sem.get();
    
    $display("[@ %0t] Before writing into memory", $time);
    #5ns 
    $display("[@ %0t] Write completed into memory", $time);
    
    //release the key
    sem.put();
  endtask
  
  task read_mem();
    // lock the key
    sem.get();
    $display("[@ %0t] Before reading from memory",$time);
    #4ns  
    $display("[@ %0t] Read completed from memory", $time);
    
    // release the key
    sem.put();
  endtask

  initial begin
    fork
      write_mem();
      read_mem();
    join_none
  end
  
endmodule


