abstract class Event {
  boolean finished = false;
  abstract void update();
  abstract void display();
}
