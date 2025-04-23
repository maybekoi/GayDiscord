package states;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.group.FlxGroup;
import dc.dmList.DMListSprite;

class Message extends FlxGroup
{
	public var username:FlxText;
	public var content:FlxText;
	public var timestamp:FlxText;
	public var avatar:FlxSprite;

	public function new(X:Float, Y:Float, UserName:String, Content:String, Time:String, AvatarPath:String)
	{
		super();

		avatar = new FlxSprite(X, Y);
		avatar.loadGraphic(AvatarPath);
		avatar.setGraphicSize(40, 40);
		avatar.updateHitbox();
		add(avatar);

		username = new FlxText(X + 50, Y, 0, UserName);
		username.setFormat(null, 16, FlxColor.WHITE);
		add(username);

		timestamp = new FlxText(username.x + username.width + 10, Y + 4, 0, Time);
		timestamp.setFormat(null, 12, 0xFF72767D);
		add(timestamp);

		content = new FlxText(X + 50, Y + 20, 600, Content);
		content.setFormat(null, 14, FlxColor.WHITE);
		add(content);
	}
}

typedef UserResponses = {
	var username:String;
	var avatar:String;
	var responses:Array<String>;
}

typedef Conversation = {
	var userMessages:Array<String>;
	var responses:Array<String>;
}

class PlayState extends FlxState
{
	private var leftSidebar:FlxSprite;
	private var serverList:FlxSprite;
	private var channelSidebar:FlxSprite;
	private var textInputBar:FlxSprite;
	private var rightSidebar:FlxSprite;
	private var bg:FlxSprite;
	private var directMessageText:FlxText;
	private var currentSelectedDM:DMListSprite;
	private var dmList:Array<DMListSprite>;
	private var messageContainer:FlxGroup;
	private var messages:Array<Message>;
	private var nextMessageY:Float;
	private var responseTimer:Float;
	private var isWaitingToRespond:Bool;
	private var userResponses:Map<String, UserResponses>;
	private var messageText:FlxText;
	private var premadeMessages:Array<String>;
	private var conversationIndex:Int = 0;
	private var isPlayerTurn:Bool = true;
	private var currentText:String = "";
	private var charIndex:Int = 0;
	private var isTyping:Bool = false;
	private var sendPrompt:FlxText;
	private var conversations:Map<String, Conversation>;
	private var currentConversation:Conversation;
	private var messagesByUser:Map<String, Array<Message>>;
	private var messageYByUser:Map<String, Float>;

	override public function create()
	{
		messagesByUser = new Map<String, Array<Message>>();
		messageYByUser = new Map<String, Float>();
		
		conversations = new Map<String, Conversation>();
		
		conversations.set("AD1340", {
			userMessages: [
				"yo.",
				"idk lmao",
				"no.",
				"anyways....hear me out on astolfo from uhhh Fate...",
				"COME ON HES LWK KINDA CUTE",
			],
			responses: [
				"wat",
				"is the order a rabbit?",
				":(",
				"WTF",
				"gay",
			]
		});

		conversations.set("SpanishFreddy", {
			userMessages: [
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*"
			],
			responses: [
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*"
			]
		});

		conversations.set("koi", {
			userMessages: [
				"who are you?",
				"but I'm me...",
				"oh...",
				"yuh",
				"I'm confronting myself"
			],
			responses: [
				"im you",
				"im you but fucking EVIL",
				"anyways wanna finish each other's sentences?",
				"I guess you could say...",
				"right now..."
			]
		});

		conversations.set("JUP!T3R", {
			userMessages: [
				"haiii",
				"ur a gay gay homosexual gay >:)",
				"haha ur gay",
				"yes u are",
				"oka bai lovb u :people_hugging:"
			],
			responses: [
				"haiii",
				"I LIKE BOYS",
				"WHAT NO IM NOT",
				"insert gif here",
				"BAIII"
			]
		});

		userResponses = new Map<String, UserResponses>();
		userResponses.set("AD1340", {
			username: "AD1340",
			avatar: "assets/images/avatars/ad1340.png",
			responses: [
				"wat",
				"is the order a rabbit?",
				":(",
				"WTF",
				"gay"
			]
		});

		userResponses.set("SpanishFreddy", {
			username: "SpanishFreddy",
			avatar: "assets/images/avatars/spanishfreddy.png",
			responses: [
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*",
				"*unity decomp nerd shit here*"
			]
		});

		userResponses.set("koi", {
			username: "koi",
			avatar: "assets/images/avatars/koi.png",
			responses: [
				"im you",
				"im you but fucking EVIL",
				"anyways wanna finish each other's sentences?",
				"I guess you could say...",
				"right now..."
			]
		});

		userResponses.set("JUP!T3R", {
			username: "JUP!T3R",
			avatar: "assets/images/avatars/wifey.png",
			responses: [
				"haiii",
				"I LIKE BOYS",
				"WHAT NO IM NOT",
				"insert gif here",
				"BAIII"
			]
		});

		currentConversation = null;
		
		bg = new FlxSprite(-80).loadGraphic('assets/images/discordColorChatYuh.png');
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		
		serverList = new FlxSprite(0, 0);
		serverList.makeGraphic(72, FlxG.height, 0xFF202225);
		add(serverList);

		channelSidebar = new FlxSprite(72, 0);
		channelSidebar.makeGraphic(240, FlxG.height, 0xFF2F3136);
		add(channelSidebar);

		rightSidebar = new FlxSprite(FlxG.width - 240, 0);
		rightSidebar.makeGraphic(240, FlxG.height, 0xFF2F3136);
		add(rightSidebar);

		messageContainer = new FlxGroup();
		add(messageContainer);
		messages = [];
		nextMessageY = 20;
		responseTimer = 0;
		isWaitingToRespond = false;

		textInputBar = new FlxSprite(312, FlxG.height - 68);
		textInputBar.makeGraphic(FlxG.width - 552, 44, 0xFF40444B);
		add(textInputBar);

		messageText = new FlxText(textInputBar.x + 10, textInputBar.y + 12, textInputBar.width - 20, "");
		messageText.setFormat(null, 14, FlxColor.WHITE);
		add(messageText);

		sendPrompt = new FlxText(textInputBar.x + 10, textInputBar.y - 20, 200, "Press any key to type, ENTER to send");
		sendPrompt.setFormat(null, 12, 0xFF96989D);
		//add(sendPrompt);

		directMessageText = new FlxText(85, 20, 200, "DIRECT MESSAGES");
		directMessageText.setFormat(null, 12, 0xFF96989D);
		add(directMessageText);

		dmList = new Array<DMListSprite>();
		
		var startY = 60;
		var spacing = 45;
		
		var ad1340 = new DMListSprite(80, startY, "AD1340", "assets/images/avatars/ad1340.png");
		dmList.push(ad1340);
		add(ad1340);

		var spanishfreddy = new DMListSprite(80, startY + spacing, "SpanishFreddy", "assets/images/avatars/spanishfreddy.png");
		dmList.push(spanishfreddy);
		add(spanishfreddy);

		var koi = new DMListSprite(80, startY + spacing * 2, "koi", "assets/images/avatars/koi.png");
		dmList.push(koi);
		add(koi);

		var futureWife = new DMListSprite(80, startY + spacing * 3, "JUP!T3R", "assets/images/avatars/wifey.png");
		dmList.push(futureWife);
		add(futureWife);

		for (dm in dmList) {
			if (dm.username != null) {
				messagesByUser.set(dm.username.text, []);
				messageYByUser.set(dm.username.text, 20);
			}
		}

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		for (dm in dmList)
		{
			if (FlxG.mouse.justPressed && isMouseOverDM(dm))
			{
				selectDM(dm);
				break;
			}
		}

		if (FlxG.keys.justPressed.ENTER && currentText.length > 0)
		{
			sendMessage();
			if (currentSelectedDM != null)
			{
				isWaitingToRespond = true;
				responseTimer = 0;
			}
		}
		else if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.ENTER)
		{
			typeNextCharacter();
			FlxG.sound.play("assets/sounds/keyClickOn" + FlxG.random.int(1, 4) + ".mp3");
		}

		if (isWaitingToRespond)
		{
			responseTimer += elapsed;
			if (responseTimer >= 1.0)
			{
				sendAutomatedResponse();
				isWaitingToRespond = false;
			}
		}
	}
	
	private function isMouseOverDM(dm:DMListSprite):Bool
	{
		var mouseX:Float = FlxG.mouse.x;
		var mouseY:Float = FlxG.mouse.y;
		return (mouseX >= dm.x && mouseX <= dm.x + dm.width &&
				mouseY >= dm.y && mouseY <= dm.y + dm.height);
	}
	
	private function selectDM(dm:DMListSprite):Void
	{
		if (currentSelectedDM != null)
		{
			currentSelectedDM.setSelected(false);
			var currentMessages = messagesByUser.get(currentSelectedDM.username.text);
			if (currentMessages != null) {
				for (msg in currentMessages) {
					msg.visible = false;
				}
			}
		}
		
		currentSelectedDM = dm;
		dm.setSelected(true);

		if (currentSelectedDM != null && currentSelectedDM.username != null)
		{
			var selectedMessages = messagesByUser.get(currentSelectedDM.username.text);
			if (selectedMessages != null) {
				for (msg in selectedMessages) {
					msg.visible = true;
				}
			}

			currentConversation = conversations.get(currentSelectedDM.username.text);
			conversationIndex = messagesByUser.get(currentSelectedDM.username.text).length;
			nextMessageY = messageYByUser.get(currentSelectedDM.username.text);
			isPlayerTurn = true;
			currentText = "";
			messageText.text = "";
			charIndex = 0;
		}
	}

	private function typeNextCharacter():Void
	{
		if (!isPlayerTurn || currentConversation == null) return;
		
		var currentMessage = currentConversation.userMessages[conversationIndex];
		
		if (charIndex < currentMessage.length)
		{
			currentText += currentMessage.charAt(charIndex);
			messageText.text = currentText;
			charIndex++;
		}
	}

	private function getTimeString():String
	{
		var now = Date.now();
		var hours = now.getHours();
		var minutes = now.getMinutes();
		var ampm = hours >= 12 ? "PM" : "AM";
		hours = hours % 12;
		hours = hours == 0 ? 12 : hours;
		return hours + ":" + StringTools.lpad(Std.string(minutes), "0", 2) + " " + ampm;
	}

	private function sendMessage():Void
	{
		if (currentSelectedDM != null && isPlayerTurn)
		{
			var message = new Message(
				320,
				nextMessageY,
				"koi",
				currentText,
				getTimeString(),
				"assets/images/avatars/koi.png"
			);
			
			messageContainer.add(message);
			
			var currentMessages = messagesByUser.get(currentSelectedDM.username.text);
			currentMessages.push(message);
			messagesByUser.set(currentSelectedDM.username.text, currentMessages);
			
			nextMessageY += 60;
			messageYByUser.set(currentSelectedDM.username.text, nextMessageY);

			messageText.text = "";
			currentText = "";
			charIndex = 0;
			isPlayerTurn = false;
			isWaitingToRespond = true;
			responseTimer = 0;
			FlxG.sound.play("assets/sounds/keyEnter.mp3", 0.7);
		}
	}

	private function sendAutomatedResponse():Void
	{
		if (currentSelectedDM != null && currentSelectedDM.username != null && !isPlayerTurn && currentConversation != null)
		{
			var userData = userResponses.get(currentSelectedDM.username.text);
			if (userData != null)
			{
				var response = currentConversation.responses[conversationIndex];
				
				var message = new Message(
					320,
					nextMessageY,
					userData.username,
					response,
					getTimeString(),
					userData.avatar
				);
				
				messageContainer.add(message);
				
				var currentMessages = messagesByUser.get(currentSelectedDM.username.text);
				currentMessages.push(message);
				messagesByUser.set(currentSelectedDM.username.text, currentMessages);
				
				nextMessageY += 60;
				messageYByUser.set(currentSelectedDM.username.text, nextMessageY);

				conversationIndex++;
				isPlayerTurn = true;
				
				if (conversationIndex >= currentConversation.userMessages.length)
				{
					isPlayerTurn = false;
				}
			}
		}
	}
}
