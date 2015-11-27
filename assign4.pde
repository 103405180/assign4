PImage bg1Img,bg2Img;
PImage enemyImg,treasureImg,fighterImg,hpImg;
PImage start1Img,start2Img;
PImage end1Img,end2Img;
PImage shootImg;

float bgX=0;
float hpX=38.8;    //10hp=19.4, 20hp=38.8, 100hp=194
float fighterX=589, fighterY=240;
float treasureX=random(45,585),treasureY=random(45,405); 
float enemyX=0, enemyY=random(0,420);
int shootNbr=0;
final float spacingX=70, spacingY=40;

float [] shootX = new float [5];
float [] shootY = new float [5];
float [] shootX1 = new float [8];
float [] shootY1 = new float [8];

float [] enemyXArray = new float [5];
float [] enemyYArray = new float [5];

float [] enemyX1Array = new float [8];
float [] enemyY1Array = new float [8];

boolean [] enemy1Detect = new boolean [5];
boolean [] enemy2Detect = new boolean [5];
boolean [] enemy3Detect = new boolean [8];

boolean [] animation1 = new boolean [5];
boolean [] animation2 = new boolean [5];
boolean [] animation3 = new boolean [8];

boolean [] shootAviable = new boolean [5];
boolean [] shootDetect = new boolean [5];
boolean [] shootAviable1 = new boolean [8];
boolean [] shootDetect1 = new boolean [8];

int [] current1Frame = new int [5];
int [] current2Frame = new int [5];
int [] current3Frame = new int [8];

PImage [] images = new PImage[5];  //explode animation

boolean upPressed=false,downPressed=false,rightPressed=false,leftPressed=false, spacePressed=false;

final int GAME_START=0, GAME_RUN_LINE=1, GAME_RUN_SLASH=2, GAME_RUN_DIAMOND=3, GAME_OVER=4;
int gameState;

void setup(){
  size(640,480);
  
  bg1Img=loadImage("img/bg1.png");
  bg2Img=loadImage("img/bg2.png");
  enemyImg=loadImage("img/enemy.png");
  treasureImg=loadImage("img/treasure.png");
  fighterImg=loadImage("img/fighter.png");
  hpImg=loadImage("img/hp.png");
  start1Img=loadImage("img/start1.png");
  start2Img=loadImage("img/start2.png");
  end1Img=loadImage("img/end1.png");
  end2Img=loadImage("img/end2.png");
  shootImg=loadImage("img/shoot.png");   //31*27
  
  for (int i=0; i<5; i++){
    images[i] = loadImage("img/flame"+(i+1)+".png");
  }
  
  for(int i=0; i<5; i++){
    shootAviable[i]=false;
    shootDetect[i]=false;
  }
  for(int i=0; i<8; i++){
    shootAviable1[i]=false;
    shootDetect1[i]=false;
  }  

}

void draw(){
   //background
   image(bg1Img,bgX,0);
   image(bg2Img,bgX-640,0);
   image(bg1Img,bgX-1280,0);
   bgX++;
   bgX%=1280;
   
   //hp
   noStroke();
   fill(255,0,0);
   rect(22,14,hpX,16);
   image(hpImg,10,10);
   
   //treasure 41*41
   image(treasureImg,treasureX,treasureY);
  
   //fighter moving
   if(upPressed){
     fighterY-=5;
   }if(fighterY<0){
      fighterY=0;
    }
   if(downPressed){
     fighterY+=5;
   }if(fighterY>height-51){
     fighterY=height-51;
    }
   if(rightPressed){
     fighterX+=5;
   }if(fighterX>width-51){
     fighterX=width-51;
    }
   if(leftPressed){
     fighterX-=5;
   }if(fighterX<0){
      fighterX=0;
   }
   image(fighterImg,fighterX,fighterY);


   //eating treasure
   if(fighterX > treasureX-fighterImg.width && fighterX < treasureX+treasureImg.width && fighterY > treasureY-fighterImg.height && fighterY < treasureY+treasureImg.height){
     hpX+=19.4;
     treasureX=random(45,585);
     treasureY=random(45,405);
   }
   
   //shooting
   for(int i = 0; i<5; i++){
     if(shootAviable[i] == true){
       image (shootImg, shootX[i]-=5, shootY[i]);
       if(shootX[i] < 0){
         shootY[i]=1000;
         shootAviable[i] = false;
       }
     }
   }

   switch(gameState){
     
     case GAME_START:
     image(start2Img,0,0);
     if(mouseX>=210 && mouseX<=440 && mouseY>=380 && mouseY<=410){
       image(start1Img,0,0);
       if(mousePressed){      
         gameState=GAME_RUN_LINE;      
       }
     }
     break;
     
     case GAME_RUN_LINE:
     
     enemyX+=3;    

     for(int i=0; i<5; i++){

       if(enemy1Detect[i]==false){
         
         enemyXArray[i]=enemyX-i*spacingX;
         enemyYArray[i]=enemyY;
         
         if( fighterX > enemyXArray[i]-fighterImg.width && fighterX < enemyXArray[i]+enemyImg.width && fighterY > enemyYArray[i]-fighterImg.height && fighterY < enemyYArray[i]+enemyImg.height){
           hpX-=38.8;
           enemy1Detect[i]=true;
           animation1[i] = true;
         }
         
         if(shootX[i]>enemyXArray[i]-shootImg.width && shootX[i]<enemyXArray[i]+enemyImg.width
         && shootY[i]>enemyYArray[i]-shootImg.height && shootY[i]<enemyYArray[i]+enemyImg.height
         ){
           enemy1Detect[i]=true;
           animation1[i]=true;
           shootDetect[i]=true;
         }
       }
       
       if(shootDetect[i]==true){
         shootY[i]=1000;
         shootDetect[i]=false;
       }

       if(animation1[i]==true){
         
         if(frameCount % floor((60/10)) == 0){
           current1Frame[i]++;
         }
         if(current1Frame[i]<5){
           image(images[current1Frame[i]],enemyX-i*spacingX,enemyY);
         }
       }

       if(enemy1Detect[i]==true){
         enemyXArray[i]=-100;
       }

       image(enemyImg,enemyXArray[i],enemyYArray[i]);
     } 
     
     if (enemyX-4*spacingX > width){
       gameState=GAME_RUN_SLASH;
       enemyX=0;
       enemyY=random(0,255);

     }     
     
     break;
     
     case GAME_RUN_SLASH:

     enemyX+=3;
     //hp range
    
     for(int i=0; i<5; i++){

       if(enemy2Detect[i]==false){
         
         enemyXArray[i]=enemyX-i*spacingX;
         enemyYArray[i]=enemyY+i*spacingY;
         
         if( fighterX > enemyXArray[i]-fighterImg.width && fighterX < enemyXArray[i]+enemyImg.width && fighterY > enemyYArray[i]-fighterImg.height && fighterY < enemyYArray[i]+enemyImg.height){
          
           hpX-=38.8;
           enemy2Detect[i] = true;
           animation2[i] = true;
         }
         
         if(shootX[i]>enemyXArray[i]-shootImg.width && shootX[i]<enemyXArray[i]+enemyImg.width
         && shootY[i]>enemyYArray[i]-shootImg.height && shootY[i]<enemyYArray[i]+enemyImg.height
         ){
           enemy2Detect[i]=true;
           animation2[i]=true;
           shootDetect[i]=true;
         }
       }
       
       if(shootDetect[i]==true){
         shootY[i]=1000;
         shootDetect[i]=false;
       }         

       if(animation2[i]==true){
           
         if(frameCount % floor((60/10)) == 0){
           current2Frame[i]++;
         }
         if(current2Frame[i]<5){
           image(images[current2Frame[i]],enemyX-i*spacingX,enemyY+i*spacingY);
         }
       }

       if(enemy2Detect[i]==true){
         enemyXArray[i]=-100;
       }

       image(enemyImg,enemyXArray[i],enemyYArray[i]);
     } 
    
     if (enemyX-4*spacingX > width){
       gameState = GAME_RUN_DIAMOND;
       enemyX=0;
       enemyY=random(80,335); 
       for(int i = 0; i<8; i++){
         if(shootAviable1[i] == true){
           image (shootImg, shootX1[i]-=5, shootY1[i]);
           if(shootX1[i] < 0){
             shootY1[i]=1000;
             shootAviable1[i] = false;
           }
         }
   }       
     }


     break;
     
     case GAME_RUN_DIAMOND:
     
     enemyX+=3;
    
     for(int i=0; i<8; i++){

       if(enemy3Detect[i]==false){

         if(i>4){
           enemyX1Array[i]=enemyX-(i-4)*spacingX;
           enemyY1Array[i]=enemyY+(2-abs(i-6))*spacingY;
         }else{
            enemyX1Array[i]=enemyX-i*spacingX;
            enemyY1Array[i]=enemyY-(2-abs(i-2))*spacingY;
          }
         
         if( fighterX > enemyX1Array[i]-fighterImg.width && fighterX < enemyX1Array[i]+enemyImg.width && fighterY > enemyY1Array[i]-fighterImg.height && fighterY < enemyY1Array[i]+enemyImg.height){
          
           hpX-=38.8;
           enemy3Detect[i]=true;
           animation3[i] = true;
         }
         if(shootX1[i]>enemyX1Array[i]-shootImg.width && shootX1[i]<enemyX1Array[i]+enemyImg.width
         && shootY1[i]>enemyY1Array[i]-shootImg.height && shootY1[i]<enemyY1Array[i]+enemyImg.height
         ){
           enemy3Detect[i]=true;
           animation3[i]=true;
           shootDetect1[i]=true;
         }         
       }  
       
       if(shootDetect1[i]==true){
         shootY1[i]=1000;
         shootDetect1[i]=false;
       }        
       
       if(animation3[i]==true){
         
         if(frameCount % floor((60/10)) == 0){
           current3Frame[i]++;
         }
         if(current3Frame[i]<5){
           if(i>4){
             image(images[current3Frame[i]],enemyX-(i-4)*spacingX,enemyY+(2-abs(i-6))*spacingY);
           }else{
              image(images[current3Frame[i]],enemyX-i*spacingX,enemyY-(2-abs(i-2))*spacingY);
            }
         }
       }

       if(enemy3Detect[i]==true){
         enemyX1Array[i]=-100;
       }

       image(enemyImg,enemyX1Array[i],enemyY1Array[i]);
     } 
     
     if (enemyX-4*spacingX > width){
       gameState = GAME_RUN_LINE;
       enemyX=0;
       enemyY=random(0,420);
       enemyXArray = new float [5];
       enemyYArray = new float [5];  
       enemyX1Array = new float [8];
       enemyY1Array = new float [8];       
       enemy1Detect = new boolean [5];
       enemy2Detect = new boolean [5];
       enemy3Detect = new boolean [8];
       animation1 = new boolean [5];
       animation2 = new boolean [5];
       animation3 = new boolean [8];
       current1Frame = new int [5];
       current2Frame = new int [5];
       current3Frame = new int [8];
       
     }     

     break;
     
     case GAME_OVER:
       image(end2Img,0,0);
         if(mouseX>=210 && mouseX<=425 && mouseY>=310 && mouseY<=345){
           image(end1Img,0,0);
           if(mousePressed){             //click
           gameState=GAME_RUN_LINE;      //change case
  
            bgX=0;
            hpX=38.8;
            fighterX=589;
            fighterY=240;
            treasureX=random(45,585);
            treasureY=random(45,405); 
            enemyX=0;
            enemyY=random(0,420);
            enemyX=0;
            enemyY=random(0,420);
            enemyXArray = new float [5];
            enemyYArray = new float [5]; 
            enemyX1Array = new float [8];
            enemyY1Array = new float [8];
            enemy1Detect = new boolean [5];
            enemy2Detect = new boolean [5];
            enemy3Detect = new boolean [8];         
            animation1 = new boolean [5];
            animation2 = new boolean [5];
            animation3 = new boolean [8];           
            current1Frame = new int [5];
            current2Frame = new int [5];
            current3Frame = new int [8];
            for (int i=0; i<5; i++){
              shootAviable[i]=false;
              shootDetect[i]=false;
            }

           } 
         }
       break;
   }
     //hp range
     if (hpX>=194){
       hpX=194;
     }else if(hpX<1){
       gameState=GAME_OVER;  
      } 
     if (hpX>=194){
       hpX=194;
     }else if(hpX<1){
       gameState=GAME_OVER;  
      } 
  }

void keyPressed(){
  if(key==CODED){
    switch(keyCode){
      case UP:
        upPressed=true;
        break;
      case DOWN:
        downPressed=true;
        break;
      case RIGHT:
        rightPressed=true;
        break;
      case LEFT:
        leftPressed=true;
        break;
    }
  }
  if ( keyCode == ' ' ){
    spacePressed=true;
    if(gameState==1 || gameState==2 || gameState==3)
     if(shootAviable[shootNbr]==false || shootAviable1[shootNbr]==false) {
        shootAviable[shootNbr]=true;
        shootAviable1[shootNbr]=true;
        shootX[shootNbr]=fighterX;
        shootY[shootNbr]=fighterY;
        shootX1[shootNbr]=fighterX;
        shootY1[shootNbr]=fighterY;        
        shootNbr++;
        if(shootNbr>4){
          shootNbr=0;
        }
     }  
   }
  }

void keyReleased(){
  if(key==CODED){
   switch(keyCode){  
     case UP:
       upPressed=false;
       break;
     case DOWN:
       downPressed=false;
       break;
     case RIGHT:
       rightPressed=false;
       break;
     case LEFT:
       leftPressed=false;
       break;   
    }
  }
}
