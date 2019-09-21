
void oneShot(int index) {
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
  }
}
