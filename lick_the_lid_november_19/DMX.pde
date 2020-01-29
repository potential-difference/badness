class DMXGrid {
  PVector[] pars = new PVector[3];
  PVector smokePumpPos, smokeFanPos;
  
  void FMSmoke(OPC opc, int xpos, int ypos) {
    smokePumpPos = new PVector(xpos, ypos);
    smokeFanPos = new PVector(xpos, ypos+10);

    opc.led(7001, int(smokePumpPos.x), int(smokePumpPos.y));
    opc.led(7000, int(smokeFanPos.x), int(smokeFanPos.y));
  }

  void FMPars(OPC opc, int xpos, int ypos) {
    pars[0] = new PVector(xpos, ypos);
    pars[1] = new PVector(xpos, ypos+20);
    pars[2] = new PVector(xpos, ypos+40);

    opc.led(6048, int(pars[0].x), int(pars[0].y));
    opc.led(6050, int(pars[1].x), int(pars[1].y));

    opc.led(6052, int(pars[0].x+20), int(pars[0].y));
    opc.led(6054, int(pars[1].x+20), int(pars[1].y));

    opc.led(6056, int(pars[2].x), int(pars[2].y));
    opc.led(6058, int(pars[2].x+20), int(pars[2].y));

    pars[0] = new PVector(xpos+10, ypos);
    pars[1] = new PVector(xpos+10, ypos+20);
    pars[2] = new PVector(xpos+10, ypos+40);
  }
}
