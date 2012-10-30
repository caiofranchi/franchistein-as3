package br.franchistein.quiz
{
	import br.franchistein.navigation.menu.AbstractMenuButton;

	public dynamic class QuizAnswer extends AbstractMenuButton
	{
		protected var movThis				:QuizAnswer;
		
		public var index					:int;
		public var label					:String;
		public var result					:String;
		public var correct					:Boolean;
		//
		private var qstQuestionReference	:QuizQuestion
		//
		public function QuizAnswer(pStrLabel:String,pIsCorrect:Boolean,pStrResult:String="")
		{
			movThis = this;
			//
			label = pStrLabel;
			correct = pIsCorrect;
			result = pStrResult;
		}
		//
		public function init():void {
		
		}
		//
		public function get reference():QuizQuestion {
			return qstQuestionReference;
		}
		public function set reference(pQstQuestionReference:QuizQuestion):void {
			qstQuestionReference = pQstQuestionReference;
		}
		//
	}
}