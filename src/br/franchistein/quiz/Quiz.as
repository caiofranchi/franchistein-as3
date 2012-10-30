package br.franchistein.quiz
{
	import br.franchistein.utils.ArrayUtils;
	import br.franchistein.utils.ClassUtils;
	
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Quiz extends MovieClip implements IEventDispatcher
	{
		public var movThis				:Quiz;
		
		public var arrPerguntas			:Array = [];
		
		public var intPerguntaAtiva		:int = 0;
		public var intTotalPerguntas	:int;
		
		public var clsQuestionClass		:Class
		public var clsAnswerClass		:Class
		
		public var numTempoMaximo		:Number;
		public var numTempoTotal		:Number;
		
		private var isLoop				:Boolean = false;
		
		private var tmpTotal			:Timer
		private var tmpMaximo			:Timer
		private var tmpPerguntaAtual	:Timer
		
		public var xmlListQuestoes		:XMLList
		//
		/**
		 * @author Caio Franchi
		 * @version 0.1b
		 * 
		 */		
		public function Quiz()
		{
			movThis = this;	
		}
		
		// PUBLICS
		public function config(pClsQuestionClass:Class,pClsAnswerClass:Class,pNumMaxTime:Number=0,pIsShuffle:Boolean=false):void {
			//
			numTempoMaximo = pNumMaxTime;
			//
			tmpMaximo = new Timer(numTempoMaximo,1);
			//
			clsQuestionClass = pClsQuestionClass;
			clsAnswerClass = pClsAnswerClass;
			//
			tmpTotal = new Timer(1000);
			//shuffling the questions
			if(pIsShuffle) arrPerguntas = ArrayUtils.randomArray(arrPerguntas);
		}
		
		public function basicParse(pXML:XML):void {
			xmlListQuestoes = pXML..questao;
			
			//montando as questões no quando utilizado o formato básico
			for(var i:int = 0; i<xmlListQuestoes.length();i++){
				var quizQuestion:QuizQuestion = ClassUtils.generateDynamicConstructor(clsQuestionClass,xmlListQuestoes[i].pergunta.@questao,xmlListQuestoes[i].pergunta.@duracao,xmlListQuestoes[i].pergunta.@pontos)
				var xmlListRespostas:XMLList = xmlListQuestoes[i].pergunta.resposta
				//
				for(var j:int=0;j<xmlListRespostas.length();j++){
					var quizAnswer:QuizAnswer = ClassUtils.generateDynamicConstructor(clsAnswerClass,xmlListRespostas[j].@nome,String(xmlListRespostas[j].@isCorrect)=="true" ? true : false ,xmlListRespostas[j].@resultado);
					quizQuestion.addAnswer(quizAnswer);
				}
				intTotalPerguntas++;
				//
				addQuestion(quizQuestion);
			}
			//
		}
		
		public function start():void {
			tmpTotal.start();
			//timer total
			tmpMaximo = new Timer(numTempoMaximo);
			tmpMaximo.start();
			tmpMaximo.addEventListener(TimerEvent.TIMER_COMPLETE,onCompleteTempo);
			//timer de cada pergunta
			tmpPerguntaAtual = new Timer(1000)
			tmpPerguntaAtual.addEventListener(TimerEvent.TIMER_COMPLETE,onCompleteTempoQuestao)
			tmpPerguntaAtual.addEventListener(TimerEvent.TIMER,onTimerQuestao)
				
				
			for(var i:int=0;i<arrPerguntas.length;i++){
				var qstQuestion:QuizQuestion = arrPerguntas[i] as QuizQuestion;
				qstQuestion.isAnswered = false
				qstQuestion.isCorrect = false;
			}
			//
			openQuestion();
		}
		
		public function pause():void {
			tmpTotal.stop();
			tmpMaximo.stop();	
		}
		//
		public function addQuestion(pQuestion:QuizQuestion):void {
			pQuestion.reference = movThis
			arrPerguntas.push(pQuestion);
		}
		
		public function previousQuestion():void {
			var _intAtivar:int;
			_intAtivar = ((intPerguntaAtiva-1)<0) ? arrPerguntas.length-1 : intPerguntaAtiva-1;  
			openQuestion(_intAtivar);
		}
		
		public function nextQuestion():void {
			var _intAtivar:int;
			//_intAtivar = ((intPerguntaAtiva+1)>arrPerguntas.length-1) ? 0 : intPerguntaAtiva+1;
			if((intPerguntaAtiva+1)>arrPerguntas.length-1) {
				//terminou
				if(isLoop) openQuestion(0);
				//
				dispatchEvent(new QuizEvent(QuizEvent.FINISHED_QUIZ,null));                                                                                                                                                                                                       
			}else {
				_intAtivar = intPerguntaAtiva+1;
				openQuestion(_intAtivar);
			}
			
		}
		public function openQuestion(pNumIndex:int=0):QuizQuestion {
			var _numIndex:int = pNumIndex;
			var _questionAbrir:QuizQuestion = arrPerguntas[_numIndex] as QuizQuestion;
			_questionAbrir.init();
			//
			if(_questionAbrir.tempo>0){
				tmpPerguntaAtual = new Timer(1000,_questionAbrir.tempo);
				tmpPerguntaAtual.addEventListener(TimerEvent.TIMER,onTimerQuestao);
				tmpPerguntaAtual.start();
			}
			//
			intPerguntaAtiva = _numIndex;
			dispatchEvent(new QuizEvent(QuizEvent.QUESTION_OPEN,_questionAbrir));
			//
			return _questionAbrir;
		}
		//PRIVATES
		public function onChooseAnswer(pAnswer:QuizAnswer):void {
			dispatchEvent(new QuizEvent(QuizEvent.QUESTION_ANSWERED,null));  
		}
		private function onCompleteTempo(e:TimerEvent):void {
			//terminou o tempo do quiz
			tmpTotal.stop();
		}
		private function onCompleteTempoQuestao(e:TimerEvent):void {
			//terminou o tempo da questao
			tmpPerguntaAtual.stop();
		}
		private function onTimerQuestao(e:TimerEvent):void {
			//contando o tempo
			//trace(tmpPerguntaAtual.currentCount);
		}
		//GETTERS AND SETTERS
		public function get loop():Boolean {
			return isLoop;
		}
		public function set loop(pIsLoop:Boolean):void {
			isLoop = pIsLoop;
		}
		
		public function get currentQuestion():QuizQuestion {
			return arrPerguntas[intPerguntaAtiva]
		}
		//INTERFACE METHODS
		/*public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(evt : Event) : Boolean {
			return dispatcher.dispatchEvent(evt);
		}
		
		public function hasEventListener(type : String) : Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type : String) : Boolean {
			return dispatcher.willTrigger(type);
		}*/
	}
}