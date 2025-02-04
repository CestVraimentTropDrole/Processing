class Player {
  int x, y, speed, velY;
  color couleur;
  float bulletX, bulletY;
  boolean bulletActive, isJump;
  char moveLeft, moveRight;

  int direction;
  int score;
  
  Weapons weapons;
  
  Player(int startX, int startY, color c, int dir, Weapons startWeapons) {

    x = startX;
    y = startY;
    velY = 0;
    couleur = c;
    speed = 5;
    bulletActive = false;

    isJump = false;
    direction = dir;
    score = 0;
    
    weapons = startWeapons;

  }

  void move(int leftKey, int rightKey) {
    if (keyPressed) {
        // Vérification pour aller à gauche
        if (keyCode == leftKey && x > 5) { 
            if (!(x - speed < player1.x + 50 && x > player1.x)) { 
                x -= speed;  // Déplacer à gauche
            }
        } 
        // Vérification pour aller à droite
        else if (keyCode == rightKey && x + 50 < width - 5) { 
            if (!(x + speed + 50 > player2.x && x < player2.x)) { 
                x += speed;  // Déplacer à droite
            }
        }
    }
    
    y += velY;
    
    if (y < height-150) {
      velY += 1;
      isJump = true;
    } else {
      y = height-150;
      velY = 0;
      isJump = false;
    }
    y += velY;
  }



  //void shoot() {
    //if (!bulletActive) {
      //bulletX = x + 25; // Position initiale de la balle (au centre du joueur)
      //bulletY = y + 50;
      //bulletActive = true;
    //}
  //}
  
  void shoot(){
    weapons.fire(this);
  }

  void updateBullet() {
    if (bulletActive) {
      bulletX += weapons.bulletSpeed * direction;  // Déplacement de la balle

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
      fill(weapons.bulletCouleur); // Couleur jaune pour les balles
      ellipse(bulletX, bulletY, weapons.bulletSize, weapons.bulletSize); // Affichage de la balle
    }
  }

  void reset() {
    x = (couleur == color(0, 255, 0)) ? width / 4 : width / 4 + width / 2 - 50;
    y = 440;
  }
}
