package br.franchistein.quiz
{
	import flash.events.Event;

	public class QuizEvent extends Event
	{
		public static var SELECTED_ANSWER		:String = "onSelectedItem";
		
		public static var STARTED_QUIZ			:String = "onStartedQuiz";
		public static var FINISHED_QUIZ			:String = "onFinishedQuiz";
		
		public static var TIME_FINISHED			:String = "onTimeIsOver";
		
		public static var QUESTION_IGNORE		:String = "onQuestionIgnore";
		public static var QUESTION_OPEN			:String = "onQuestionOpen";
		public static var QUESTION_ANSWERED		:String = "onQuestionAnswer";
		public static var QUESTION_CLOSE		:String = "onQuestionClose";
		
		//propriedades relativas
		public var quiz							:Quiz;
		public var question						:QuizQuestion = null;
		public var answer						:QuizAnswer = null;
		//
		public function QuizEvent(type:String,pQuizQuestion:QuizQuestion,bubbles:Boolean=false,cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//
			this.question = (pQuizQuestion == null) ? null : pQuizQuestion;
		}
	}
}