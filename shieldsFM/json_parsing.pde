class Device{
    String name;
    OPC opc;
    ArrayList<Channel> channels;
    Device(String name_, OPC opc_, ArrayList<Channel> channels_){
        name = name_;
        opc = opc_;
        channels = channels_;
    }
}
class Channel{//supercedes PixelMapping
    OPC opc;
    String unitname;
    int start_pixel;
    int pixelcounts[];
    Channel(String name,OPC opc_, int stpix, int[] pixcounts){
        opc = opc_;
        unitname = name;
        start_pixel = stpix;
        pixelcounts = pixcounts;
    }
}
Channel parseChannel(JSONObject chan,OPC opc){
    try{
        String name = chan.getString("name");
        int start = chan.getInt("start");
        int[] pixels = chan.getJSONArray("pixels").toIntArray();
        return new Channel(name,opc,start,pixels);
    }catch(Exception e){
        throw e;
    }
}
Device parseDevice(JSONObject obj) throws Exception{
    try{
        // if the object is null, throw
        if (! obj.getBoolean("enabled",true) ){
            return null;
        }
        String name = obj.getString("name");
        String ip = obj.getString("ip");
        int port = obj.getInt("port");
        Class<?> clazz = Class.forName(obj.getString("type"));
        Constructor<?> constructor = clazz.getConstructor(PApplet.class,String.class,int.class);
        OPC instance = (OPC)constructor.newInstance(this,ip,port);
        //have to have at least an opc
        //shield opcs dont have channels
        JSONArray channelsj = obj.getJSONArray("channels");      
        ArrayList<Channel> channels = new ArrayList<Channel>();
        if (channelsj!=null){            
            for(int i=0;i<channels.size();i++){
                channels.add(parseChannel(channelsj.getJSONObject(i),instance));
            }
        }
        return new Device(name,instance,channels);
    }catch(Exception e){
        println("json parsing error:",e);
        throw e;
    }
}
ArrayList<Device> parseDevices(JSONArray arr) throws Exception{
    try{
    ArrayList<Device> res = new ArrayList<Device>();
    for(int i = 0;i<arr.size();i++){
        Device dev = parseDevice(arr.getJSONObject(i));
        if(dev!=null){//device is null if disabled
            res.add(dev);
        }
    }
    return res;
    }catch(Exception e){
        throw e;
    }
}

//backwards compatibility
Device getByName(ArrayList<Device> devices,String name) throws NoSuchElementException{
    for(Device dev : devices){
        if (dev.name == name){ return dev;}
    }
    throw new NoSuchElementException("no opc/wled device with name " + name);
}
//waiting on refactor of e.g. CircularRoofGrid
Map<String,OPC> legacyOPCs(ArrayList<Device> devices){
    Map<String,OPC> OPCs = new HashMap<String,OPC>();
    for(Device dev:devices){
        OPCs.put(dev.name,dev.opc);
    }
    return OPCs;
}

Map<String,PixelMapping> legacyChannels(ArrayList<Device> devices){
    Map<String,PixelMapping> channels = new HashMap<String,PixelMapping>();
    for(Device dev : devices){
        for (Channel chan : dev.channels){
            channels.put(chan.unitname,new PixelMapping(chan.unitname,dev.name,chan.start_pixel,chan.pixelcounts));
        }
    }
    return channels;
}

IntCoord getCoord(String name) throws NoSuchFieldException,IllegalAccessException{
    //these are stored inside the SizeSettings singleton
    try{
        Class<?> clazz = size.getClass();
        Field coordfield = clazz.getDeclaredField(name);
        return (IntCoord) coordfield.get(size);
    }catch(Exception e){
        throw e;
    }
}

/*
Rig parseRig(JSONObject obj,ArrayList<Device> devices){
    try{
        String name = obj.getString("name");
        RigType type = RigType.valueOf(obj.getString("type"));
        IntCoord coord = getCoord(obj.getString("size"));
        JSONArray channels = obj.getJSONArray("channels");
        Class<?> clazz = Class.forName(obj.getString("opcgrid"));
        //Map<String,OPC> opcs = legacyOPCs(devices);
        Constructor<?> opcgrid_constructor = clazz.getConstructor(Rig.class,RigType.class);

        if(!channels.isNull()){
            for(int i = 0; i< channels.size();i++){
                channels.getString(i);
            }
        }
    }catch(Exception e){
        throw e;
    }
}
*/