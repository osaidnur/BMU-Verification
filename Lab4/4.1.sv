module semaphore_example();
  // print the time
  task write_mem();
    $display("[@ %0t] Before writing into memory", $stime);
    #5ns;  
    $display("[@ %0t] Write completed into memory", $stime);
  endtask
  
  task read_mem();
    $display("[@ %0t] Before reading from memory", $stime);
    #4ns; 
    $display("[@ %0t] Read completed from memory", $stime);
  endtask

  initial begin
    fork
      write_mem();
      read_mem();
    join
  end
endmodule