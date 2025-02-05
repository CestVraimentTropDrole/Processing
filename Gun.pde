class Gun extends Weapons {
  Gun() {
    super(10, 20, color(0, 0, 255)); 
  }

  void fire(Player shooter) {
    if (!shooter.bulletActive) {
      shooter.bulletX = shooter.x + 25;
      shooter.bulletY = shooter.y + 50;
      shooter.bulletActive = true;
    }
  }
}
