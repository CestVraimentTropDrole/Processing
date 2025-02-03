class Player {
  int x, y, speed;
  color couleur;
  float bulletX, bulletY;
  boolean bulletActive;
  char moveLeft, moveRight;
  boolean movingRight; // Nouvelle variable pour savoir si on tire vers la droite ou gauche
  
  Player(int startX, int startY, color c) {
    x = startX;
    y = startY;
    couleur = c;
    speed = 5;
    bulletActive = false;
    movingRight = true; // Par défaut, on tire vers la droite
  }

  void move(int leftKey, int rightKey) {
    if (keyPressed) {
      if (keyCode == leftKey && x > 5) { 
        x -= speed;  // Déplacer à gauche
      } 
      else if (keyCode == rightKey && x + 50 < width-5) { 
        x += speed;  // Déplacer à droite
      }
    }
  }

  void shoot() {
    if (!bulletActive) {
      bulletX = x + 25; // Position initiale de la balle (au centre du joueur)
      bulletY = y-50;
      bulletActive = true;
      movingRight = (key == ' ') ? true : false; // Si joueur 1 appuie sur espace, tirer vers la droite
    }
  }

  void updateBullet() {
    if (bulletActive) {
      if (movingRight) {
        bulletX += bulletSpeed;  // Déplacement de la balle vers la droite
      } else {
        bulletX -= bulletSpeed;  // Déplacement de la balle vers la gauche
      }

      // Si la balle sort de l'écran, réinitialiser
      if (bulletX < 0 || bulletX > width) {
        resetBullet();
      }
    }
  }

  void resetBullet() {
    bulletActive = false;
  }

  void display() {
    fill(couleur);
    rect(x, y, 50, 150); // Affichage du joueur
  }

  void displayBullet() {
    if (bulletActive) {
      fill(255, 255, 0); // Couleur jaune pour les balles
      ellipse(bulletX, bulletY, 10, 10); // Affichage de la balle
    }
  }

  void reset() {
    x = (couleur == color(0, 255, 0)) ? 10 : 735; // Réinitialiser la position du joueur
    y = 440;
  }
}
