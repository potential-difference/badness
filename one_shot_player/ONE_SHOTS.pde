
void oneShot(int index) {
  boolean somethingplaying=false;
  for (int i=1; i<player.length; i++) {
    if (player[i].isPlaying() && i != index) {
      somethingplaying=true;
      println("number "+i+"already playing, staying quiet");
    }
  }
  if (!somethingplaying) {
    if ( player[index].isPlaying() )
    {
      player[index].rewind();
    }
    // if the player is at the end of the file,
    // we have to rewind it before telling it to play again
    else if ( player[index].position() == player[index].length() )
    {
      player[index].rewind();
      player[index].play();
    } else
    {
      player[index].play();
    }
  }
}



/*
    println("about to play number "+index);
 boolean somethingplaying=false;
 for (int i=0; i<player.length; i++) {
 }
 if (player[i].isPlaying()) {
 somethingplaying=true;
 println("number "+i+"already playing, staying quiet");
 }
 }
 //if (!somethingplaying) {
 if ( player[index].isPlaying() )
 {
 player[index].pause();
 }
 // if the player is at the end of the file,
 // we have to rewind it before telling it to play again
 else if ( player[index].position() == player[index].length() )
 {
 player[index].rewind();
 player[index].play();
 } else
 {
 player[index].play();
 //}
 }
 println("playing");
 }
 */
