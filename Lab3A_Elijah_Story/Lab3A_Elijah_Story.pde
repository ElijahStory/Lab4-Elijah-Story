//NMD211 Lab4A
//Elijah Story
//10-2-2020

float userX = 400, userY = 750, speed = 2, coolDown = 0;
int health = 3, spawn = 50, score = 0;
boolean button = true;
ArrayList<Bad> badList = new ArrayList<Bad>();
ArrayList<dart> dartList = new ArrayList<dart>();

void setup(){
    size(800,800);
    rectMode(CENTER);
    textAlign(CENTER);
    ellipseMode(CENTER);
}

class dart{
    float x, y, speed;
    dart(float x, float y){
        this.x = x;
        this.y = y;
        speed = 3;
    }

    void display(){
        fill(255,255,0);
        rect(x,y,5,15);
    }

    void move(){
        y -= speed;
    }

    boolean dead(){
        if(y < 0){
            return true;
        }else{
            return false;
        }
    }
}

class Bad{
    float x, y, speed;
    Bad(float x, float y){
        this.x = x;
        this.y = y;
        speed = 1;
    }

    void display(){
        fill(170,0,0);
        triangle(x-25,y-15,x,y+50,x+25,y-15);
    }

    void move(){
        y += speed;
    }

    boolean dead(){
        if(y > height){
            return true;
        }else{
            return false;
        }
    }
}

void draw(){
    background(0);

    if(frameCount % 100 == 0 && spawn > 0){
        spawn--;
    }

    if(random(spawn) < 0.5 && badList.size() < 150){
        badList.add(new Bad(random(20,width-20), 0));
    }

    for(int i = 0; i < badList.size(); i++){
        Bad temp = badList.get(i);
        temp.move();
        temp.display();
        if(temp.dead()){
            badList.remove(i);
        }

        if(dist(temp.x,temp.y,userX,userY) < 40){
                badList.remove(i);
                health--;
        }        
    }

    for(int i = 0; i < dartList.size(); i++){
        dart temp = dartList.get(i);
        temp.move();
        temp.display();
        if(temp.dead()){
            dartList.remove(i);
        }

        for(int j = 0; j < badList.size(); j++){
            Bad badTemp = badList.get(j);
            if(dist(badTemp.x,badTemp.y,temp.x,temp.y) < 30){
                badList.remove(j);
                dartList.remove(i);
                score++;
            }
        }
    }

    if(keyPressed){
        if(key == 'a' && userX > 10){
            userX -= speed;
        }

        if(key == 'd' && userX < width-10){
            userX += speed;
        }

        if(key == ' ' && coolDown == 0){
            coolDown = 20;
            dartList.add(new dart(userX, userY));
        }
    }

    if(coolDown > 0){
        coolDown--;
    }

    if(health <= 0){
        noLoop();
        fill(255);
        strokeWeight(50);
        text("Game Over",width/2,height/2);
    }

    if(button){
        fill(0,200,0);
        ellipse(50, 700, 70, 50);
        fill(0);
        text("One Time\nWipe Out",50, 700);
        
    }

    if(mousePressed){
        color c = get(mouseX, mouseY);
        if(c == color(0,200,0)){
            badList.clear();
            button = false;
        }
    }

    fill(255);
    triangle(userX-25,userY+25,userX,userY-50,userX+25,userY+25);
    text("Health: " + health, 40,height-20);
    text("Score: " + score, 40,height-35);
}
