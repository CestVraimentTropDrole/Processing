PImage image;
int bulletSpeed = 20;
boolean gameOver = false;

Player player1;
Player player2;

Weapons[]weapons = {new Pistol(), new Gun()};
int currentWeaponsIndex = 0; 

void setup() {
  fullScreen();
  player1 = new Player(width/4, height, color(0, 255, 0), 1, weapons[currentWeaponsIndex]);
  player2 = new Player(width/4 + width/2 - 50, height, color(255, 0, 0), -1, weapons[currentWeaponsIndex]);
  background(200);
  image = loadImage("assets/sprites/player.png");
  image.resize(50,150);
}

void draw() {
  background(200);

  if (!gameOver) {
    textSize(32);
    fill(0);
    text("Joueur 1 : " + player1.score, width/4, 50);
    text("Joueur 2 : " + player2.score, width/4 + width/2 - 50, 50);
    
    player1.move(LEFT, RIGHT);  
    player1.display();  
    player2.move(UP, DOWN);  
    player2.display();  

    player1.updateBullet();
    player2.updateBullet();
    player1.displayBullet();
    player2.displayBullet();

    checkCollisions();
  } else {
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
  if (key == ' ' && !gameOver) {
    player1.shoot();
  }
  if (key == 'a' && !gameOver) {
    player2.shoot();
  }

  if (key == 'w' && !gameOver && !player1.isJump) {
    println("Peut sauter");
    player1.velY = -15;
    player1.isJump = true;
  }
  
  if (key == 'x' && !gameOver && !player2.isJump) {
    println("Peut sauter");
    player2.velY = -15;
    player2.isJump = true;
  }

  if (key == 'r' && gameOver) {
    gameOver = false;
    player1.reset();
    player2.reset();
    player1.resetBullet();
    player2.resetBullet();
    player1.score = 0;
    player2.score = 0;
  }
}

void checkCollisions() {
  if (player1.bulletActive && dist(player1.bulletX, player1.bulletY, player2.x + 25, player2.y + 75) < 50) {
    player1.score++;
    newRound();
  }

  if (player2.bulletActive && dist(player2.bulletX, player2.bulletY, player1.x, player1.y) < 60) {
    player2.score++;
    newRound();
  }
}

void newRound() {
  player1.reset();
  player2.reset();
  player1.resetBullet();
  player2.resetBullet();
  
  if (player2.score >= 2 || player1.score >= 2) {
      gameOver = true;
  } else {
    currentWeaponsIndex = (currentWeaponsIndex + 1) % weapons.length;
    player1.weapons = weapons[currentWeaponsIndex];
    player2.weapons = weapons[currentWeaponsIndex];
  } 
}
