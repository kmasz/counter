package 
{
	import se.svt.caspar.template.CasparTemplate;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.net.Socket;


	//public class zegar extends MovieClip
	public class counter extends CasparTemplate
	{
		var timer:Timer = null;
		var minuty:uint = 1;
		var sekundy:uint = 1;
		var start_flag = 1;
		var xmlLoader:URLLoader = null;
		var czas:String = new String();
		var socket:Socket = null;

		public function counter()
		{

			// constructor code 
			//var someBirthday:Date = new Date(1974,10,30,15,5);
			//trace(someBirthday);// Sat Nov 30 15:20:00 GMT-0800 1974
			//trace(someBirthday.getHours() + ":" + someBirthday.getMinutes());// 15:5
			//var localTime:String = getUSClockTime(someBirthday.getHours(),someBirthday.getMinutes());
			//trace(localTime);// 03:05 PM
			var myXML:XML = new XML();
			var XML_URL:String = "counter.xml";
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			xmlLoader = new URLLoader(myXMLURL);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			//waitLoop();
		}
		public function xmlLoaded(event:Event):void
		{
			SetData(XML(xmlLoader.data));
		}
		//public override function SetData(xmlData:XML):void
		public override function SetData(xmlData:XML):void
		{
			minuty = xmlData.MIN;
			sekundy = xmlData.SEC;
			//waitLoop();
		}
		override public function Play():void
		{
			TweenLite.to(zegarek, 0.1, {alpha:1, ease:Cubic.easeInOut});
			waitLoop();
		}
		function waitLoop():void
		{
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, refresz);
			if ( minuty == 0 && sekundy == 0)
			{
				hidding_clock();
			}
			else
			{
				timer.start();
				//counter_down();
				couter_start();
			}
			
			//if (start_flag == 1)
			//{
			//}
			//else
			//{
			//}
		function couter_start():void
		{
			czas = male(minuty) + ":" + male(sekundy)
			zegarek.czas1.text = czas;
			counter_down();
		}
		}
		function refresz(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, refresz);
			timer = null;
			//var newdate:Date = new Date();
			//var czas:String = new String();

			//czas = male(newdate.hours) + ":" + male(newdate.minutes) + ":" + male(newdate.seconds);
			czas = male(minuty) + ":" + male(sekundy)
			//trace(czas);
			zegarek.czas1.text = czas;
			waitLoop();
		}
		function male(liczba:uint):String
		{
			var wynik:String = new String();
			if (liczba < 10)
			{
				wynik = "0" + liczba.toString();
			}
			else
			{
				wynik = liczba.toString();
			}
			return wynik;
		}
		function counter_down():void
		{
			if (sekundy ==0)
			{
				minuty = minuty -1;
				sekundy = 59;
			}
			else
			{
				sekundy = sekundy -1;
			}
		}
		function hidding_clock():void
		{
			TweenLite.to(zegarek, 0.1, {alpha:0, delay:2, ease:Cubic.easeInOut, onComplete: next_play});
		}
		function next_play():void
		{
			socket = new Socket("localhost",5250);
			socket.writeUTFBytes("CG 1 ADD 1 COUNTER 0\r\n");
			socket.flush();
		}
	}
}
