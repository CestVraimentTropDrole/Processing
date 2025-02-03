int speed = 5; // Vitesse de déplacement
int bulletSpeed = 10; // Vitesse des balles
boolean gameOver = false; // Si le jeu est terminé
int score1 = 0; // Score du joueur 1
int score2 = 0; // Score du joueur 2

Player player1;
Player player2;

void setup() {
  size(800, 600); // Taille de la fenêtre
  background(200); // Fond de la fenêtre
  player1 = new Player(10, 440, color(0, 255, 0));  // Joueur 1 (vert)
  player2 = new Player(735, 440, color(255, 0, 0)); // Joueur 2 (rouge)
}

void draw() {
  background(200);

  if (!gameOver) {
    // Affichage des scores
    textSize(32);
    fill(0);
    text("Joueur 1 : " + score1, 50, 50);
    text("Joueur 2 : " + score2, width - 200, 50);

    // Déplacer et afficher les joueurs
    player1.move(LEFT, RIGHT);  
    player1.display();  
    player2.move(UP, DOWN);  
    player2.display();  

    // Gérer les balles des joueurs
    player1.updateBullet();
    player2.updateBullet();
    player1.displayBullet();
    player2.displayBullet();

    // Vérification de la collision entre les balles et les joueurs
    checkCollisions();

  } else {
    // Affichage du message de victoire
    textSize(32);
    fill(0);
    if (score1 > score2) {
      text("Joueur 1 gagne!", width / 2 - 150, height / 2);
    } else if (score2 > score1) {
      text("Joueur 2 gagne!", width / 2 - 150, height / 2);
    } else {
      text("Match nul!", width / 2 - 100, height / 2);
    }
    textSize(16);
    text("Appuyez sur 'R' pour relancer", width / 2 - 75, height / 2 + 50);
  }
}

void keyPressed() {
  // Touche de tir
  if (key == ' ' && !gameOver) {
    player1.shoot();
  }
  if (key == 'a' && !gameOver) {
    player2.shoot();
  }

  // Relancer le jeu si gameOver est vrai
  if (key == 'r' && gameOver) {
    gameOver = false; // Réinitialiser l'état du jeu
    player1.reset();  // Réinitialiser le joueur 1
    player2.reset();  // Réinitialiser le joueur 2
    player1.resetBullet();  // Réinitialiser la balle du joueur 1
    player2.resetBullet();  // Réinitialiser la balle du joueur 2
    score1 = 0; // Réinitialiser les scores
    score2 = 0; // Réinitialiser les scores
  }
}

// Vérification des collisions
void checkCollisions() {
  // Si la balle du joueur 1 touche le joueur 2
  if (player1.bulletActive && dist(player1.bulletX, player1.bulletY, player2.x, player2.y) < 10) {
    score1++;  // Joueur 1 gagne un point
    player2.reset();  // Réinitialiser le joueur 2
    player1.resetBullet();  // Réinitialiser la balle du joueur 1
    if (score1 >= 2) { // Si joueur 1 a 2 points, game over
      gameOver = true;
    }
  }

  // Si la balle du joueur 2 touche le joueur 1
  if (player2.bulletActive && dist(player2.bulletX, player2.bulletY, player1.x, player1.y) < 60) {
    score2++;  // Joueur 2 gagne un point
    player1.reset();  // Réinitialiser le joueur 1
    player2.resetBullet();  // Réinitialiser la balle du joueur 2
    if (score2 >= 2) { // Si joueur 2 a 2 points, game over
      gameOver = true;
    }
  }
}
