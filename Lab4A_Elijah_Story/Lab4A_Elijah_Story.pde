//NMD211 Lab4A
//Elijah Story
//10-2-2020

//This code gets the users input 3 ways.
//1: key input from 'a' and 'd'
//2: key input from spacebar
//3: user click on certain color

//user the 'a' and 'd' keys to move left and right. Use spacebar to shoot.
//stay alive as long as possible with out getting hit.
//your score is based on how many bad guys you shoot.
//you have a one time use button that wipes all the bad guys in emergency.
//the gun also has a cooldown.

//known issue: the player sticks or continues to move if multipal keys are pressed

//setup for variables used by the player and classes
float userX = 400, userY = 750, speed = 2, coolDown = 0;
int health = 3, spawn = 50, score = 0;
boolean button = true;
ArrayList<Bad> badList = new ArrayList<Bad>();      //list to hold the bad guys
ArrayList<dart> dartList = new ArrayList<dart>();   //list to hold the darts

void setup(){
    size(800,800);

    //seting up all the draw modes
    rectMode(CENTER);
    textAlign(CENTER);
    ellipseMode(CENTER);
}

//the dart class user by the user to shoot
class dart{
    float x, y, speed;
    dart(float x, float y){ //spawns at the players x and y
        this.x = x;
        this.y = y;
        speed = 3;  //has a set speed
    }

    //draws the dart based on current x and y
    void display(){
        fill(255,255,0);
        rect(x,y,5,15);
    }

    //moves the dart up the screen based on speed
    void move(){
        y -= speed;
    }

    //checks if the dart is past the top of the screen
    boolean dead(){
        if(y < 0){  //at the top
            return true;
        }else{      //not at top
            return false;
        }
    }
}

//makes the class for the bad guy
class Bad{
    float x, y, speed;
    Bad(float x, float y){ //spawns based on random x and y passed in
        this.x = x;
        this.y = y;
        speed = 1;      //has a set speed
    }

    //draws the bad guy based on current x and y
    void display(){
        fill(170,0,0);
        triangle(x-25,y-15,x,y+50,x+25,y-15);
    }

    //moves the bad guy down based on speed
    void move(){
        y += speed;
    }

    //checks if the bad guy hit the bottom of the screen
    boolean dead(){
        if(y > height){ //at bottom
            return true;
        }else{          //not at bottom
            return false;
        }
    }
}

void draw(){
    background(0); //black background (like space)

    //increases the spawn frequence every 100 frames
    if(frameCount % 100 == 0 && spawn > 0){
        spawn--;
    }

    //randomly decides if and where wo spawn a bad guy
    // has a limit of 150 bad guys
    if(random(spawn) < 0.5 && badList.size() < 150){
        badList.add(new Bad(random(20,width-20), 0));   //makse new bad guy
    }

    // runs all the functions for each bad guy
    for(int i = 0; i < badList.size(); i++){
        Bad temp = badList.get(i);
        temp.move();
        temp.display();
        if(temp.dead()){        //removes the bad guy from list if at the bottom of screen
            badList.remove(i);
        }

        //checks if bad guy hit the player
        if(dist(temp.x,temp.y,userX,userY) < 40){
                badList.remove(i);  //removes the bad guy from list
                health--;           //removes 1 point from players health
        }        
    }

    //runs all the functions for all the darts
    for(int i = 0; i < dartList.size(); i++){
        dart temp = dartList.get(i);
        temp.move();
        temp.display();
        if(temp.dead()){        //removes the dart from list if at the top of screen    
            dartList.remove(i);
        }

        //checks every bad gut to see if current dart hit it
        for(int j = 0; j < badList.size(); j++){
            Bad badTemp = badList.get(j);
            if(dist(badTemp.x,badTemp.y,temp.x,temp.y) < 30){   //if hit
                badList.remove(j);  //remove the bad guy
                dartList.remove(i); //remove the dart
                score++;            //increase the player score
            }
        }
    }

    //if the player is pressing a key
    if(keyPressed){
        if(key == 'a' && userX > 10){   //if the 'a' key is pressed and the player is not at the wall
            userX -= speed; //move the player left
        }

        if(key == 'd' && userX < width-10){//if the 'd' key is pressed and the player is not at the wall
            userX += speed; //move the player right
        }

        if(key == ' ' && coolDown == 0){//if the spacebar is pressed and no cooldown
            coolDown = 20;  //start the cooldown
            dartList.add(new dart(userX, userY));   //spawn new dart based on player x and y
        }
    }

    //removes the cooldown
    if(coolDown > 0){
        coolDown--;
    }

    //if the player has no more health
    if(health <= 0){
        noLoop();   //stop the draw loop
        fill(255);
        strokeWeight(100);
        text("Game Over",width/2,height/2); //display text
    }

    //if the button is true(not yet clicked), draw the button
    if(button){
        fill(0,200,0);
        ellipse(50, 700, 70, 50);
        fill(0);
        text("One Time\nWipe Out",50, 700);
        
    }

    //if the mouse is clicked
    if(mousePressed){
        color c = get(mouseX, mouseY); //checks what color the mouse is over
        if(c == color(0,200,0)){    //if color matches button color
            badList.clear();    //remove all bad guys
            button = false;     //tells the button it has been clicked
        }
    }

    //draws the player based on the userX and userY
    fill(255);
    triangle(userX-25,userY+25,userX,userY-50,userX+25,userY+25);

    //displays text for player health and score
    text("Health: " + health, 40,height-20);
    text("Score: " + score, 40,height-35);
}
