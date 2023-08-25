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
        if(!chan.getBoolean("enabled",true)){println("channel ",chan.getString("name"),"disabled");return null;}
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
        //we get 'WLED' we want shieldsFM$WLED
        String pappletname = this.getClass().getName();
        Class<?> clazz = Class.forName(pappletname + "$" + obj.getString("type"));
        Constructor<?> constructor;
        try{
            constructor = clazz.getDeclaredConstructor(this.getClass(),PApplet.class,String.class,int.class);
        }catch(NoSuchMethodException e){
            println("failed to find constructor " + e);
            println("constructors are:");
            Constructor[] allConstructors = clazz.getDeclaredConstructors();
            for(Constructor c : allConstructors){
                println(c.getName(), c.getParameterCount(), " arguments:");
                for(Class cl : c.getParameterTypes()){
                    print(" ",cl.getName());
                }
                println();
            }
            throw e;
        }
        OPC instance = (OPC)constructor.newInstance(this,this,ip,port);
        //have to have at least an opc
        //shield opcs dont have channels
        JSONArray channelsj = obj.getJSONArray("channels");      
        ArrayList<Channel> channels = new ArrayList<Channel>();
        if(channelsj!=null){
            println("parseDevice ",name," has ",channelsj.size()," channels");
        }else{println("parseDevice ", name," has NO channels defined");}
        if (channelsj!=null){            
            for(int i=0;i<channelsj.size();i++){
                println("adding",channelsj.getJSONObject(i).getString("name"));
                Channel c = parseChannel(channelsj.getJSONObject(i),instance);
                if(c!=null){
                    channels.add(parseChannel(channelsj.getJSONObject(i),instance));
                }
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
        println("parsed ",dev.channels.size()," channels for dev ",dev.name);
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

Map<String,PixelMapping> legacyChannels(ArrayList<Device> devices) throws Exception{
    Map<String,PixelMapping> channels = new HashMap<String,PixelMapping>();
    if(devices.size() == 0){ throw new Exception("empty devices list!");}
    for(Device dev : devices){
        println(dev.channels.size()," channels for device ",dev.name);
        if (dev.name==null){throw new Exception("device name null");}
        for (Channel chan : dev.channels){
            if (chan==null){ throw new Exception("channel is null on device"+dev.name);}
            if (chan.unitname==null){ throw new Exception("channel unitname null");}
            if (chan.pixelcounts==null){throw new Exception("channel " + chan.unitname + ", device " + dev.name + "pixelcounts are null");}
            println("adding pixelmapping " + dev.name + "/" + chan.unitname);
            channels.put(dev.name + "/" + chan.unitname,new PixelMapping(dev.name + "/" + chan.unitname,dev.name,chan.start_pixel,chan.pixelcounts));
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