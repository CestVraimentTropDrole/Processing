PImage image;

int bulletSpeed = 20; // Vitesse des balles
boolean gameOver = false; // Si le jeu est terminé

Player player1;
Player player2;

void setup() {
  //size(800, 600); // Taille de la fenêtre
  fullScreen();
  
  player1 = new Player(width/4, height, color(0, 255, 0), 1);  // Joueur 1 (vert)
  player2 = new Player(width/4 + width/2 - 50, height, color(255, 0, 0), -1); // Joueur 2 (rouge)
  
  background(200); // Fond de la fenêtre

  image = loadImage("/assets/sprites/player.png");
  image.resize(50,150);

}

void draw() {
  background(200);

  if (!gameOver) {

    // Affichage des textes
    textSize(32);
    fill(0);
    text("Joueur 1 : " + player1.score, 50, 50);
    text("Joueur 2 : " + player2.score, width - 50, 50);
    
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
    if (player1.score > player2.score) {
      text("Joueur 1 gagne!", width / 2 - 150, height / 2);
    } else if (player1.score < player2.score) {
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

  
  //Si le joueur appuie sur la touche de saut
  if (key == 'w' && !gameOver && !player1.isJump) {
    println("Peut sauter");
    player1.velY = -15;
    player1.isJump = true;


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
    player1.score++;  // Joueur 1 gagne un point
    player2.reset();  // Réinitialiser le joueur 2
    player1.resetBullet();  // Réinitialiser la balle du joueur 1

    if (player1.score >= 2) {

      gameOver = true;
    }
  }

  // Si la balle du joueur 2 touche le joueur 1
  if (player2.bulletActive && dist(player2.bulletX, player2.bulletY, player1.x, player1.y) < 60) {
    player2.score++;  // Joueur 2 gagne un point
    player1.reset();  // Réinitialiser le joueur 1
    player2.resetBullet();  // Réinitialiser la balle du joueur 2

    if (player2.score >= 2) {

      gameOver = true;
    }
  }
}
