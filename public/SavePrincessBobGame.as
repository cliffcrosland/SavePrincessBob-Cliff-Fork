package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.external.ExternalInterface;
	import flash.utils.getQualifiedClassName;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	
	public class SavePrincessBobGame extends MovieClip {
		/*navigation between title screen, levels, and the setup menu accomplished
		by changing frames on the main stage. */
		
		public function SavePrincessBobGame() {
			//prevents auto-animating.  Maybe...
			this.stop();
	
			//buttons
			_makeYourOwn.addEventListener(MouseEvent.CLICK, setupGame);
			_startButton.addEventListener(MouseEvent.CLICK, startGameWrapper);
		}
		
		private function changeLevel(n:Number):void
		{
			this.gotoAndStop(n);
		}
		
		/* allows for printing flash errors in chrome
		*/
		public static function log(msg:String, caller:Object = null):void{
			var str:String = "";
			if(caller){
				str = getQualifiedClassName(caller);
				str += ":: ";
			}
			str += msg;
			trace(str);
			if(ExternalInterface.available){
				ExternalInterface.call("l",str);
			}
		}
		
		//the wrapper allows a button to call startGame, as well as any function that doesn't have an event to send in.
		function startGameWrapper(event:MouseEvent):void 
		{
			startGame();
		}
		function startGame():void
		{
			changeLevel(3);
			initializeGame();
		}
		
		//SETUP CODE ----------------------------------------- FRAME 2
	
		public var _heroPreview:CharPreview;
		public var _heroPhoto:UserPhoto;
		public var _heroFaceList:Array;
		var global_image:Bitmap;
		var _mouseDown:Boolean;
		var _oldPicX:Number;
		var _oldPicY:Number;
		
		
		//the pixel_change in a picture that will register (NOT SURE IF STILL NECESSARY)
		const PIC_EPSILON:Number = 20;
		
		function facebookIdToLargeImageUrl(facebookId:String):String {
			return "https://graph.facebook.com/" + facebookId + "/picture?type=large";
		}
		
		function facebookIdToSmallImageUrl(facebookId:String):String {
			return "https://graph.facebook.com/" + facebookId + "/picture?type=square";
		}
		/* Code Cliff made, don't think it works, we replaced it with onImageLoaded
		function onFacebookImageLoaded(facebookId:String, image:Bitmap, previewObject:CharPreview):Function {
			log("About to return a sweet function boyyy");
			return function(e:Event):void {
				log("I'm DONE LOADING I SWEAR!");
				image = new Bitmap(e.target.content.bitmapData);
				image.width = previewObject.width * 2;
				image.height = previewObject.height * 2;
				log("HEY BEFORE");
				_heroPreview = CharPreview (image);
				log("Hey");
			}
		}
		*/
		function onImageLoaded(e:Event):void {
			global_image = new Bitmap(e.target.content.bitmapData);
			global_image.x =  -global_image.width/2;
			global_image.y =  -global_image.height/2;
			_heroPreview._heroPhoto.addChild(global_image);
			
		}
		
		/*TODO: current mouse-response is okay, but there are problems.  MouseDown is only registered when clicking
		on the photo (it's possible _heroPreview is only defined for solid shapes.  Maybe I should add a big invisible 
		background.)  Also, there are some functionality problems when combining zoom with drag.  Whatevs.*/
		function setupGame(event:MouseEvent):void 
		{
			changeLevel(2);
			// The elements of the friends array can be accessed like this:
			//   var friend = friends[0];
			//   var friend_name = friend.name;  // Stephanie Brinton Parker
			//   var friend_facebook_id = friend.id;  // 34800
			var friends = ExternalInterface.call("window.SavePrincessBob.getFriendsArray");
			
			//var stephanie = friends[0];
			var myLoader:Loader = new Loader();
			var url:URLRequest = new URLRequest("https://graph.facebook.com/12312312/picture?type=large");
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			myLoader.load(url); 
			
			
			//intializeSetup();
			_heroZoomIn.addEventListener(MouseEvent.CLICK, picZoomIn);
			_heroZoomOut.addEventListener(MouseEvent.CLICK, picZoomOut);
			_heroRotateCW.addEventListener(MouseEvent.CLICK, picRotateCW);
			_heroRotateCCW.addEventListener(MouseEvent.CLICK, picRotateCCW);
			_heroPreview.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTrue);
			//POTENTIAL BUG: you might need to clear these stage listeners once you enter the game.
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseDownFalse);
			_heroPreview.addEventListener(MouseEvent.MOUSE_MOVE, movePic);
			
			_doneSetup.addEventListener(MouseEvent.CLICK, doneSetup);
			
			_mouseDown = false;
		}
		
		function picZoomIn(event:MouseEvent):void
		{
			_heroPreview._heroPhoto.getChildAt(1).scaleX += 0.1;
			_heroPreview._heroPhoto.getChildAt(1).scaleY += 0.1;
		}
		function picZoomOut(event:MouseEvent):void
		{
			_heroPreview._heroPhoto.getChildAt(1).scaleX -= 0.1;
			_heroPreview._heroPhoto.getChildAt(1).scaleY -= 0.1;
		}
		function picRotateCW(event:MouseEvent):void
		{
			_heroPreview._heroPhoto.getChildAt(1).rotation += 2;
		}
		function picRotateCCW(event:MouseEvent):void
		{
			_heroPreview._heroPhoto.getChildAt(1).rotation -= 2;
		}
		function mouseDownTrue(event:MouseEvent):void 
		{ 
			_mouseDown = true;
			_oldPicX = event.localX;
			_oldPicY = event.localY;
		}
		
		function mouseDownFalse(event:MouseEvent):void { _mouseDown = false; }
		
		function movePic(event:MouseEvent):void
		{
			if(_mouseDown){
				var _newPicX:Number = event.localX;
				var _newPicY:Number = event.localY;
				var Xchange = _newPicX - _oldPicX;
				var Ychange = _newPicY - _oldPicY;
				if(Math.abs(Xchange) < PIC_EPSILON && Math.abs(Ychange) < PIC_EPSILON){
					_heroPreview._heroPhoto.getChildAt(1).x += (Xchange);
					_heroPreview._heroPhoto.getChildAt(1).y += (Ychange);
					_oldPicX = _newPicX;
					_oldPicY = _newPicY;
				}
			}
		}
		
		function doneSetup(event:MouseEvent):void
		{
			//eventually this array will set the faces for all characters (5)
			_heroFaceList = new Array();
			_heroFaceList[0] = _heroPreview._heroPhoto.getChildAt(1);
			startGame();
		}
		
		/*
		function initializeSetup():void
		{
			_heroZoomIn.addEventListener(MouseEvent.CLICK, picZoomIn);
			_heroZoomOut.addEventListener(MouseEvent.CLICK, picZoomOut);
			_heroRotateCW.addEventListener(MouseEvent.CLICK, picRotateCW);
			_heroRotateCCW.addEventListener(MouseEvent.CLICK, picRotateCCW);
		}
		*/
		
		
		
		
		//game code
		
		public var _hero:BaseBody;
		public var _boundaries:Boundaries;
		public var _startMarker:StartMarker;
		
		private var _vx:Number;
		private var _vy:Number;
		private var _movingLeft:Boolean;
		private var _movingRight:Boolean;
		private var _jumping:Boolean;
		private var _holdingJump:Boolean;
		
		function initializeGame():void
		{
			faceTheHeroes();
			_startMarker.visible = false;
			_vx = 0;
			_vy = 0;
			_movingLeft = false;
			_movingRight = false;
			_jumping = false;
			_holdingJump = false;
			stage.focus = stage;
			
			//add event listeners
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		//add faces from setup to each hero
		function faceTheHeroes():void
		{
			if(_heroFaceList){
				_hero._heroHead.addChild(_heroFaceList[0]);
			}
		}
		
		private function enterFrameHandler(e:Event):void
		{
			//gravitate the player
			if(!_boundaries.hitTestPoint(_hero.x, _hero.y, true)){
			   if(!(_holdingJump && _vy < 0)) _vy += 2;
				else _vy += 1;
			} 
			
			//move the player
			_hero.x += _vx;
			_hero.y += _vy;
			
			if(!_movingLeft && !_movingRight){
				_vx *= 0.7;
				if(!_jumping) _hero.gotoAndStop(1);
			}
			else if(_vx > -14 && _vx < 14) _vx *=1.5;
				
			if(_hero.currentFrame == 35)_hero.gotoAndPlay(11);
			else if(_hero.currentFrame == 60) _hero.gotoAndPlay(36);
			
			//process collisions
			processCollisions();
			
			//scroll the stage
			//scrollStage();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case 37: //left_arrow
				if(_hero.scaleX > 0){
					_hero.scaleX *= -1;
				}
				//if(_vx > -16) _vx -= 5;
				if(!_movingLeft) _hero.gotoAndPlay(11);
				_movingLeft = true;
				if(_vx > -4) _vx = -3;
				//_vx = -15;
				break;
				
				case 38: //up arrow
				if(!_jumping){
					_vy = -14;
				} 
				if(!_jumping)_hero.gotoAndPlay(36);
				_jumping = true;
				_holdingJump = true;
				break;
				
				case 39: //right_arrow
				if(_hero.scaleX < 0){
					_hero.scaleX *= -1;
				}
				//if(_vx < 16) _vx += 5;
				if(!_movingRight) _hero.gotoAndPlay(11);
				_movingRight = true;
				
				if(_vx < 4) _vx = 3;
				//_vx = 15;
				break;
				
				case 65:
				//for the attack animation
				
				default:
			}
		}
		
		private function keyUpHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				
				
				case 38: //up arrow
					_holdingJump = false;
				break;
				
				case 37: //left_arrow
					_movingLeft = false;
				break;
				
				case 39: //right_arrow
					_movingRight = false;
				break;
				
				default:
			}
		}
		
		private function scrollStage():void
		{
			//you could use some awesome for loop to call this on 
			//every stage object except the hero.
			_boundaries.x += (stage.stageWidth * 0.5) - _hero.x;
			_boundaries.y += (stage.stageHeight * 0.5) - _hero.y;
			//__startMarker.x += (stage.stageWidth * 0.5) - _hero.x;
			//__startMarker.y += (stage.stageHeight * 0.5) - _hero.y;
			_hero.x = stage.stageWidth * 0.5;
			_hero.y = stage.stageHeight * 0.5;
		}
		
		private function processCollisions():void
		{
			//when player is falling
			if(_vy > 0)
			{
				//respawn if player fell off the stage
				if (_hero.y > stage.stageHeight)
				{
					_hero.x = _startMarker.x;
					_hero.y = _startMarker.y;
					_boundaries.x = 0;  // you will have to start with a strangely displayced boundary for this to reset it correctly.
					_boundaries.y = 0;
					_vy = 0;
				}
				//otherwise, process collisions with boundaries
				else
				{
					var groundCollision:Boolean = false;
					var wallCollision:Boolean = false;
					
					//ground, checking bottom right and bottom left
					if(_boundaries.hitTestPoint(_hero.x, _hero.y, true)){
						groundCollision = true;
					}
					if(_boundaries.hitTestPoint(_hero.x + _hero.width/2, _hero.y - _hero.height/2))
					{
						wallCollision = true;
	
					}
					
					if (groundCollision)
					{
						while(groundCollision)
						{
							_hero.y -= 0.1;
							if(!_boundaries.hitTestPoint(_hero.x, _hero.y, true)){
								groundCollision = false;
							}
						}
						_jumping = false;
						_vy = 0;
					}
					
					//turning this off for a second because wallcoll isn't working
					/*
					if (wallCollision)
					{
						while(wallCollision)
						{
							if(_movingRight)_hero.x -= 0.1;
							else _hero.x += 0.1;
							if(!_boundaries.hitTestPoint(_hero.x + _hero.width/2, _hero.y - _hero.height/2, true)){
								wallCollision = false;
							}
						}
						_vx = 0;
					}
					*/
				}
			}
	
		}
	}
}