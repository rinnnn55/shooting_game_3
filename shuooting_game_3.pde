int BULLET_SIZE = 200;


ArrayList<Bullet> playBul;
ArrayList<Bullet> norEneBul;
Player player;
NormalEnemy norEne;

void setup() {
  size(600, 800);
  frameRate(120);
  noCursor();
  norEne = new NormalEnemy();
  player = new Player();
  playBul = new ArrayList<Bullet>();
  norEneBul = new ArrayList<Bullet>();
}





void draw() {
  background(128);
  norEne.gameLoop();
  player.gameLoop();
  bulletGameLoop(playBul);
  bulletGameLoop(norEneBul);

  collistion(playBul, norEne.x, norEne.y, norEne.size, true);//To enemy
  collistion(norEneBul, player.x, player.y, player.size, false);//To player
}

void keyPressed() {
  if (BULLET_SIZE > playBul.size() && keyCode == ' ') {
    playBul.add(new PlayerBullet());
  }
}

void collistion(ArrayList<Bullet> XBul, float objeX, float objeY, float size2, boolean isToEnemy) {
  for (int i = 0; i < XBul.size(); i++) {
    float size1 = XBul.get(i).size;

    if (isToEnemy && isHitToEnemy(XBul.get(i).x, XBul.get(i).y, objeX, objeY, size1, size2)) XBul.remove(i);
    else if (isHitToPlayer(XBul.get(i).x, XBul.get(i).y, objeX, objeY, size1, size2)) XBul.remove(i);
  }
}

void bulletGameLoop(ArrayList<Bullet> XBul) {
  for (int i = 0; i < XBul.size(); i++) {
    XBul.get(i).gameLoop();

    if (XBul.get(i).y < 0) XBul.remove(i);
  }
}

boolean isHitToPlayer(float x1, float y1, float x2, float y2, float size1, float size2) {
  float distance = dist(x1, y1, x2, y2);

  if (distance < size1 + size2) return true;
  return false;
}

boolean isHitToEnemy(float x1, float y1, float x2, float y2, float size1, float size2) {
  boolean isWithinRangeX = x1 + size1 / 2 > x2 && x1 - size1 / 2 < x2 + size2;
  boolean isWithinRangeY = y1 + size1 / 2 > y2 && y1 - size1 / 2 < y2 + size2;

  if (isWithinRangeX && isWithinRangeY) return true;
  return false;
}















abstract class Bullet {
  float x, y, size, yStep;
  int damages;




  abstract void move();
  void display() {
    ellipse(x, y, size, size);
  }

  void gameLoop() {
    move();
    display();
  }
}



abstract class Enemy {
  float x, y, size;
  float xStep, yStep;
  float bulX, bulY;
  int HP;

  void display() {
    rect(x, y, size, size);
  }

  abstract void move();
  abstract void eneBullet();

  void gameLoop() {
    move();
    display();
    eneBullet();
  }
}




class Player {
  float size = 20;
  float x, y;
  float step = 10;
  int HP = 100;

  Player() {
    x = width/2;
    y = height - 40;
  }
  void display() {
    rect(x, y, size, size);
  }
  void move() {
    x = mouseX;
    y = mouseY;
  }

  /*
  void move(){
   if(keyCode == LEFT) x -= step;
   else if(keyCode == RIGHT) x += step;
   
   if(keyCode == LEFT && keyCode == UP) x -= step; y -= step;
   if(keyCode == LEFT && keyCode == DOWN) x -= step; y += step;
   if(keyCode == RIGHT && keyCode == UP) x += step; y -= step;
   if(keyCode == RIGHT && keyCode == DOWN) x += step; y += step;
   
   if(keyCode == UP) y -= step;
   else if(keyCode == DOWN) y += step;
   }
   */
  void gameLoop() {
    move();
    display();
  }
}




class NormalEnemy extends Enemy {  //横に移動するだけ
  NormalEnemy() {
    yStep = 0;
    xStep = 2;
    HP = 300;
    bulX = 0;
    bulY = 6;
    size = 200;
  }

  void move() {
    x += xStep;

    if (x < 0 || x > width - size) {
      xStep *= -1;
    }
  }


  void eneBullet() {
    if (frameCount % 40 == 0) {
      norEneBul.add(new NormalEnemyBullet());
    }
  }
}







class PlayerBullet extends Bullet {
  PlayerBullet() {
    yStep = 4;
    size = 10;
    x = player.x;
    y = player.y;
    damages = 20;
  }

  void display() {
    fill(255, 0, 0);
    ellipse(x, y, size, size);
    fill(255);
  }

  void move() {
    y -= yStep;
  }
}

class NormalEnemyBullet extends Bullet {

  NormalEnemyBullet() {
    x = norEne.x + norEne.size/2;
    y = norEne.y + norEne.size;
    size = 16;
    yStep = 3.5;
    damages = 10;
  }

  void move() {
    y += yStep;
  }
}

