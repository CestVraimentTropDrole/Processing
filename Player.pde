class Player {
  int x, y, speed, velY;
  color couleur;
  float bulletX, bulletY;
  boolean bulletActive, isJump;
  char moveLeft, moveRight;
  int direction;
  int score;
  
  Player(int startX, int startY, color c, int dir) {
    x = startX;
    y = startY;
    velY = 0;
    couleur = c;
    speed = 5;
    bulletActive = false;
    isJump = false;
    direction = dir;
    score = 0;
  }

  void move(int leftKey, int rightKey) {
    if (keyPressed) {
      if (keyCode == leftKey && x > 5) { 
        x -= speed * direction;  // Déplacer à gauche
      } 
      else if (keyCode == rightKey && x + 50 < width-5) { 
        x += speed * direction;  // Déplacer à droite
      }
    }
    
    if (y < 440) {
      velY += 1;
      isJump = true;
    } else {
      y = 440;
      isJump = false;
    }
    y += velY;
  }

  void shoot() {
    if (!bulletActive) {
      bulletX = x + 25; // Position initiale de la balle (au centre du joueur)
      bulletY = y-50;
      bulletActive = true;
    }
  }

  void updateBullet() {
    if (bulletActive) {
      bulletX += bulletSpeed * direction;  // Déplacement de la balle

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
    //fill(couleur);
    //rect(x, y, 50, 150); // Affichage du joueur
    image(image,x,y);
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
