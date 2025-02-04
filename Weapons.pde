abstract class Weapons {
  int bulletSpeed;
  int bulletSize;
  color bulletCouleur;
  
  Weapons(int _bulletSpeed, int _bulletSize, int _bulletCouleur) {
    bulletSpeed = _bulletSpeed;
    bulletSize = _bulletSize;
    bulletCouleur = _bulletCouleur;
  }
  
  abstract void fire(Player Shooter);

}
