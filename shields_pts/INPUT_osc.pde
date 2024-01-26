void oscEvent(OscMessage theOscMessage) {
    //split address into parts
    String addr[] = theOscMessage.addrPattern().split("/");
    //String messageType=addr[addr.length-1];
    //addr[addr.length-1]="";
    //String address=String.join("/", addr);
    //int argument = (int)theOscMessage.arguments()[0];
    println();
    print("received osc message to "); // TODO ADD message arguments to this ....??
    printArray(addr);
    Object obj = this;
    Field fld;
    try{
        for (int i = 1;i < addr.length - 1;i++) {
            fld = obj.getClass().getDeclaredField(addr[i]);
            obj = fld.get(obj);
        }
        fld = obj.getClass().getDeclaredField(addr[addr.length - 1]);
        fld.set(obj,theOscMessage.arguments()[0]);
        // if (keyT['q']) println("set ",fld.getName(),"to ",theOscMessage.arguments()[0]);
        println("set ",fld.getName(),"to ",theOscMessage.arguments()[0]);
        println();
   
    } catch(Exception e) {
        print("osc message ");
        printArray(addr);
        println(" failed cc change with exception ",e);
    }
     
    try {
    for (int i = 1; i < addr.length - 1; i++) {
        fld = obj.getClass().getDeclaredField(addr[i]);
        obj = fld.get(obj);
    }
        fld = obj.getClass().getDeclaredField(addr[addr.length - 1]);
       
       // boolean buttonToggle = !fld.getBoolean(obj); // Toggle the boolean value
       // fld.setBoolean(obj, buttonToggle);
        //println("set ",fld.getName(),"to ",buttonToggle);
        println("set ","to ");

    } catch (Exception e) {
        print("osc message ");
        printArray(addr);
        println(" failed button press with exception ", e);
    }

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
