package br.franchistein.quiz
{
	import br.franchistein.utils.ArrayUtils;
	
	import flash.display.MovieClip;

	public dynamic class QuizQuestion extends MovieClip
	{
		protected var movThis				:QuizQuestion;
		
		public var answeredQuestion			:QuizAnswer;
		
		private var strLabel				:String  = "";
		public var id						:String = "";
			
		private var numDuracaoMaxima		:Number;
		private var numPontosValidos		:Number;
		private var numPontosGanhados		:Number;
		
		private var isMultipleAnswers		:Boolean = false;		
		public var isAnswered				:Boolean = false;
		public var isCorrect				:Boolean = false;		
			
		public var answers					:Array  = []
			
		private var quizReference			:Quiz;
		//
		public function QuizQuestion(pStrLabel:String="",pNumTime:Number=0,pNumPontuation:Number=0)
		{
			movThis = this;
			//
			strLabel = pStrLabel;
			numDuracaoMaxima = pNumTime;
			numPontosValidos = pNumPontuation;
		}
		//
		public function init():void {
			for(var i:int=0;i<answers.length;i++){
				answers[i].index = i;
				answers[i].init();
			}
		}
		public function addAnswer(pQuizAnswer:QuizAnswer):void {
			pQuizAnswer.reference = movThis;
			answers.push(pQuizAnswer);
		}
		//
		public function shuffle():void {
			answers = ArrayUtils.randomArray(answers);
		}
		//
		public function answerQuestion(pQuizAnswer:QuizAnswer):void { //...params
			answeredQuestion = pQuizAnswer;
			answeredQuestion.activate();
			reference.onChooseAnswer(answeredQuestion);
			isAnswered = true;
			isCorrect = answeredQuestion.correct;
			//
			if(!isMultipleAnswers) {
				for(var i:int=0;i<answers.length;i++){
				
					if(answers[i]!=answeredQuestion){
						answers[i].deactivate();
					}
					
				}
			}
		}
		
		//GETTERS AND SETTERS
		public function get tempo():Number {
			return numDuracaoMaxima
		}
		
		public function set tempo(pNumDuracaoMaxima:Number):void {
			numDuracaoMaxima = pNumDuracaoMaxima
		}
		//
		public function get label():String {
			return strLabel
		}
		
		public function set label(pStrLabel:String):void {
			strLabel = pStrLabel;
		}
		//
		public function get pontuacao():Number {
			return numPontosValidos
		}
		
		public function set pontuacao(pNumPontuacao:Number):void {
			numPontosValidos = pNumPontuacao
		}
		//
		public function get reference():Quiz {
			return quizReference;
		}
		public function set reference(pQstQuizReference:Quiz):void {
			quizReference = pQstQuizReference;
		}
	}
}